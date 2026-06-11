// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/configs/caches/cache_helper.dart';
import 'package:video_spliter/app/services/analytics_service.dart';
import 'package:video_spliter/app/services/app_service.dart';
import 'package:video_spliter/app/services/file_service.dart';
import 'package:video_spliter/app/services/background_processing_service.dart';
import 'package:video_spliter/app/utils/methods_utils.dart';
import 'package:video_spliter/app/utils/video_logic.dart';
import 'package:video_spliter/app/utils/constants.dart';
import 'package:video_spliter/app/services/ad_mob_service.dart';
import 'package:video_spliter/app/services/save_segments_service.dart';
import 'package:video_spliter/app/services/video_service.dart';
import 'package:video_spliter/app/services/parallel_video_service.dart';
import 'package:video_spliter/app/services/revenuecat_service.dart';
import 'package:video_spliter/app/services/feature_manager.dart';
import 'package:video_spliter/app/services/sharing_service.dart';
import 'package:video_spliter/app/widgets/deletion_dialog.dart';
import 'package:video_spliter/app/widgets/folder_name_dialog.dart';
import 'package:video_spliter/app/widgets/premium_limit_dialog.dart';

/// Contrôleur principal pour la gestion des vidéos et de l'interface utilisateur
/// Gère le découpage de vidéos, la sélection de fichiers, les publicités et le cycle de vie de l'application
class HomeController extends GetxController with WidgetsBindingObserver {
  // ==================== PROPRIÉTÉS PRIVÉES ====================

  /// Subscription pour écouter les intentions de partage
  late StreamSubscription intentDataStreamSubscription;

  /// Helper pour la gestion du cache
  final CacheHelper cacheHelper = CacheHelper();

  /// Service de gestion des publicités
  final AdMobService adMobService = AdMobService();

  /// Service de gestion des vidéos partagées
  // final SharingService sharingService = Get.find<SharingService>();

  /// Temps de mise en pause de l'application
  DateTime? _pausedTime;

  /// Indicateur si une publicité interstitielle a été récemment affichée
  final _interstitialRecentlyShown = false.obs;

  // ==================== PROPRIÉTÉS PUBLIQUES OBSERVABLES ====================

  /// Vidéo actuellement sélectionnée
  Rx<File?> selectedVideo = Rx<File?>(null);

  /// Liste des parties de vidéo générées après découpage
  RxList<File> videoParts = <File>[].obs;

  /// Liste des parties de vidéo sélectionnées par l'utilisateur
  RxList<File> selectedVideoParts = <File>[].obs;

  /// Contrôleur de pagination pour les vues
  PageController pageController = PageController();

  /// Page actuellement affichée
  RxInt currentPage = 0.obs;

  /// Durée de découpage en secondes
  RxDouble sliceDuration = 60.0.obs;

  /// Indicateur si l'utilisateur peut sélectionner une vidéo
  final canSelectVideo = false.obs;

  /// Indicateur si l'application est en arrière-plan
  final isAppInBackground = false.obs;

  /// Raccourci vers la bannière globale
  BannerAd? get banner => adMobService.bannerAd;

  /// Nombre de découpages réussis
  final successfulCuts = 0.obs;

  /// Progression du traitement
  RxDouble progress = 0.0.obs;

  /// Progression individuelle de chaque segment
  final RxList<double> segmentProgresses = <double>[].obs;

  /// Fichiers de segments terminés
  final RxList<File?> segmentFiles = <File?>[].obs;

  /// Indicateur si la bannière publicitaire est chargée
  bool get isBannerLoaded => adMobService.isBannerAdLoaded;
  final isVideoLoading = false.obs;

  /// Dossier actuellement sélectionné pour les options
  final selectedFolder = "".obs;

  /// Custom
  final isCustom = false.obs;

  /// select Social
  final selectedSocial = "Whatsapp".obs;

  // ==================== MÉTHODES DE SÉLECTION DE FICHIERS ====================

  /// Permet à l'utilisateur de sélectionner une vidéo depuis le système de fichiers
  /// Demande les permissions nécessaires avant la sélection
  /// Valide et traite une vidéo importée (taille, durée, compression).
  /// Affiche automatiquement une boîte de dialogue explicative si l'utilisateur dépasse les limites gratuites.
  /// Retourne true si la vidéo a été acceptée et stockée dans selectedVideo.
  Future<bool> processAndValidateVideo(
    File videoFile, {
    required String source,
  }) async {
    selectedFolder.value = "";
    isVideoLoading.value = true;
    update();

    try {
      final sizeMb = videoFile.lengthSync() / (1024 * 1024);
      final isPro = FeatureManager.isProUser;
      final maxAllowedSize = isPro ? maxVideoSizeMb : maxVideoSizeMbFree;

      // 1. Vérification de la taille
      if (!VideoLogic.isFileSizeValid(sizeMb, maxAllowedSize)) {
        if (!isPro && sizeMb <= maxVideoSizeMb) {
          // Vidéo trop lourde pour un utilisateur gratuit, mais OK pour Pro
          if (FeatureManager.isProVersionAvailable) {
            isVideoLoading.value = false;
            update();
            final upgrade = await Get.dialog<bool>(
              PremiumLimitDialog(
                isSizeExceeded: true,
                value: sizeMb,
                limit: maxVideoSizeMbFree,
              ),
            );
            if (upgrade == true) {
              await Get.find<RevenueCatService>().presentPaywall();
            }
            return false;
          }
        }

        // Autre cas (vidéo trop lourde même en Pro, ou Pro non disponible)
        showSnackBar(
          "La vidéo est trop lourde. Veuillez choisir une vidéo moins lourde !",
          isError: true,
        );
        isVideoLoading.value = false;
        update();
        return false;
      }

      log("Taille vidéo : ${sizeMb.toStringAsFixed(2)} Mo");

      // 2. Vérification de la durée
      try {
        final mediaInfoSession = await FFprobeKit.getMediaInformation(
          videoFile.path,
        );
        final info = mediaInfoSession.getMediaInformation();
        final durationSec = double.tryParse(info?.getDuration() ?? '0') ?? 0;
        final maxAllowedDuration =
            isPro ? maxVideoDurationSec : maxVideoDurationSecFree;

        if (!VideoLogic.isDurationValid(durationSec, maxAllowedDuration)) {
          if (!isPro && durationSec <= maxVideoDurationSec) {
            // Vidéo trop longue pour gratuit, mais OK pour Pro
            if (FeatureManager.isProVersionAvailable) {
              isVideoLoading.value = false;
              update();
              final upgrade = await Get.dialog<bool>(
                PremiumLimitDialog(
                  isSizeExceeded: false,
                  value: durationSec,
                  limit: maxVideoDurationSecFree,
                ),
              );
              if (upgrade == true) {
                await Get.find<RevenueCatService>().presentPaywall();
              }
              return false;
            }
          }

          // Autre cas
          showSnackBar(
            "La vidéo est trop longue. Veuillez choisir une vidéo moins longue",
            isError: true,
          );
          isVideoLoading.value = false;
          update();
          return false;
        }

        selectedVideo.value = videoFile;

        // Enregistrer l'import de la vidéo dans analytics
        await AnalyticsService.videoImported(
          durationSec: durationSec.round(),
          sizeMb: sizeMb,
          source: source,
        );

        // Compresser uniquement les vidéos lourdes (> 100 Mo) pour optimiser le temps
        if (VideoLogic.shouldCompress(sizeMb, maxVideoSizeMbForCompress)) {
          await compressVideo();
        }

        isVideoLoading.value = false;
        update();
        return true;
      } catch (e) {
        // Si l'analyse de la vidéo échoue, on enregistre quand même l'import
        // avec des valeurs par défaut
        selectedVideo.value = videoFile;
        await AnalyticsService.videoImported(
          durationSec: 0,
          sizeMb: sizeMb,
          source: source,
        );

        isVideoLoading.value = false;
        update();
        return true;
      }
    } catch (e) {
      isVideoLoading.value = false;
      showSnackBar(e.toString(), isError: true);
      update();
      return false;
    }
  }

  /// Permet à l'utilisateur de sélectionner une vidéo depuis le système de fichiers
  /// Demande les permissions nécessaires avant la sélection
  Future<void> pickVideo() async {
    try {
      await requestPermissions();
      final result = await FilePicker.pickFiles(type: FileType.video);

      if (result != null && result.files.single.path != null) {
        final videoFile = File(result.files.single.path!);
        await processAndValidateVideo(videoFile, source: 'file_picker');
      }
    } catch (e) {
      showSnackBar(e.toString(), isError: true);
    }
  }

  // ==================== MÉTHODES DE TRAITEMENT VIDÉO ====================

  /// Découpe la vidéo sélectionnée en segments de durée définie (méthode synchrone)

  /// Retourne la liste des fichiers générés ou null si aucune vidéo n'est sélectionnée

  Future<void> compressVideo() async {
    if (selectedVideo.value == null) return;
    final compressedVideo = await VideoService().compressVideo(
      inputPath: selectedVideo.value!.path,
      outputPath: '${selectedVideo.value!.path}.compressed.mp4',
    );
    if (compressedVideo != null) {
      selectedVideo.value = File(compressedVideo);
    }
  }

  /// Découpe la vidéo sélectionnée en segments de durée définie (méthode asynchrone avec isolate)
  /// Améliore les performances en utilisant un thread séparé
  Future<List<File>?> splitVideoIsolate() async {
    if (selectedVideo.value == null) return null;
    videoParts.clear();
    segmentProgresses.clear();
    segmentFiles.clear();

    final isPro = FeatureManager.isProUser;

    final bgTaskId = await BackgroundProcessingService.start(
      'Découpage de vidéo en cours...',
    );

    try {
      final parts = await VideoService.splitBySSAsync(
        videoFile: selectedVideo.value!,
        sliceDuration: sliceDuration.value,
        isPro: isPro,
        onProgress: (double p) {
          progress.value = p;
          BackgroundProcessingService.update(
            'Progression : ${(p * 100).toStringAsFixed(0)}%',
          );
          update();
        },
        onSegmentsCalculated: (count) {
          segmentProgresses.assignAll(List.filled(count, 0.0));
          segmentFiles.assignAll(List.filled(count, null));
          update();
        },
        onSegmentProgress: (index, p) {
          if (index < segmentProgresses.length) {
            segmentProgresses[index] = p;
            segmentProgresses.refresh();
            update();
          }
        },
        onSegmentComplete: (index, file) {
          if (index < segmentFiles.length) {
            segmentFiles[index] = file;
            segmentFiles.refresh();
            vibrate(); // Retour haptique lors de la complétion d'un segment
            update();
          }
        },
      );
      parts.sort((a, b) => a.path.compareTo(b.path));
      videoParts.addAll(parts);
      return parts;
    } finally {
      await BackgroundProcessingService.stop(bgTaskId);
    }
  }

  /// Découpe la vidéo en parallèle (multi-threading via ParallelVideoService)
  Future<List<File>?> splitVideoParallelIsolate() async {
    if (selectedVideo.value == null) return null;
    videoParts.clear();
    segmentProgresses.clear();
    segmentFiles.clear();

    final isPro = FeatureManager.isProUser;

    final bgTaskId = await BackgroundProcessingService.start(
      'Découpage parallèle de vidéo...',
    );

    try {
      final parts = await ParallelVideoService.splitBySSParallelAsync(
        videoFile: selectedVideo.value!,
        sliceDuration: sliceDuration.value,
        isPro: isPro,
        onProgress: (double p) {
          progress.value = p;
          BackgroundProcessingService.update(
            'Progression : ${(p * 100).toStringAsFixed(0)}%',
          );
          update();
        },
        onSegmentsCalculated: (count) {
          segmentProgresses.assignAll(List.filled(count, 0.0));
          segmentFiles.assignAll(List.filled(count, null));
          update();
        },
        onSegmentProgress: (index, p) {
          if (index < segmentProgresses.length) {
            segmentProgresses[index] = p;
            segmentProgresses.refresh();
            update();
          }
        },
        onSegmentComplete: (index, file) {
          if (index < segmentFiles.length) {
            segmentFiles[index] = file;
            segmentFiles.refresh();
            vibrate(); // Retour haptique lors de la complétion d'un segment
            update();
          }
        },
      );
      parts.sort((a, b) => a.path.compareTo(b.path));
      videoParts.addAll(parts);
      return parts;
    } finally {
      await BackgroundProcessingService.stop(bgTaskId);
    }
  }

  // ==================== MÉTHODES DE SAUVEGARDE ====================

  /// Sauvegarde les segments vidéo sélectionnés dans un dossier
  /// Affiche une publicité interstitielle après la sauvegarde
  /// Retourne true si la sauvegarde est réussie
  Future<bool> saveSegments(String? baseFolderName) async {
    await SaveSegmentsService.saveSegments(
      selectedVideoParts.isEmpty ? videoParts : selectedVideoParts,
      baseFolderName,
    );
    selectedVideo.value = null;
    pageController.jumpToPage(1);
    clearAll();
    // Demande de notation après une sauvegarde réussie
    AppService().handleRatingRequestAfterCutting();

    adMobService.showInterstitialAd(
      onAdClosed: () {
        update();
      },
    );

    return true;
  }

  /// Affiche un dialogue pour renommer un dossier
  /// Met à jour le système de fichiers si un nouveau nom est fourni
  Future<void> renameFolder(String folderName) async {
    final result = await showFolderDialog(name: folderName);
    if (result != null) {
      await FileService.renameFolder(folderName, result);
    }
  }

  Future<void> deleteFolder(String folderName) async {
    final result = await showDialog(
      context: Get.context!,
      builder: (context) {
        return DeletionDialog(folderName: folderName);
      },
    );

    if (result == true) {
      await FileService.deleteFolders([folderName]);
    }
  }

  // ==================== MÉTHODES DE SÉLECTION ====================

  /// Gère la sélection/désélection d'une partie de vidéo
  /// Toggle la sélection si le fichier est déjà sélectionné
  void selectVideoPart(File part) {
    if (selectedVideoParts.contains(part)) {
      selectedVideoParts.remove(part);
    } else {
      selectedVideoParts.add(part);
    }
    update();
  }

  /// Sélectionne ou désélectionne toutes les parties de vidéo
  /// Toggle entre sélection complète et aucune sélection
  void selectAllVideoParts(List<File> parts) {
    if (selectedVideoParts.isEmpty) {
      selectedVideoParts.addAll(parts);
    } else {
      selectedVideoParts.clear();
    }
    update();
  }

  /// Vérifie si la limite journalière est dépassée pour l'utilisateur gratuit
  Future<bool> checkDailyLimit() async {
    final isPro = FeatureManager.isProUser;
    log("🔍 [Daily Limit] Vérification : isProUser = $isPro");
    if (isPro) return true;

    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastExportDate = await CacheHelper.getString(key: 'last_export_date');
    int exportsCount = CacheHelper.getInteger(key: 'daily_exports_count');

    log(
      "📊 [Daily Limit] Date actuelle : $today | Dernière date de découpe : '$lastExportDate' | Compteur actuel : $exportsCount",
    );

    if (lastExportDate != today) {
      log(
        "♻️ [Daily Limit] Nouvelle journée détectée. Réinitialisation du compteur.",
      );
      exportsCount = 0;
      await CacheHelper.saveData(key: 'last_export_date', value: today);
      await CacheHelper.saveData(key: 'daily_exports_count', value: 0);
    }

    const int maxDailyFreeCuts = 3;
    if (exportsCount >= maxDailyFreeCuts) {
      log(
        "🚫 [Daily Limit] Limite journalière de $maxDailyFreeCuts atteinte ! Accès refusé.",
      );
      return false;
    }

    log(
      "✅ [Daily Limit] Autorisé. ${maxDailyFreeCuts - exportsCount} découpes restantes pour aujourd'hui.",
    );
    return true;
  }

  /// Incrémente le nombre d'exports quotidiens pour l'utilisateur gratuit
  Future<void> incrementDailyExportCount() async {
    if (FeatureManager.isProUser) return;
    final exportsCount = CacheHelper.getInteger(key: 'daily_exports_count');
    await CacheHelper.saveData(
      key: 'daily_exports_count',
      value: exportsCount + 1,
    );
    log(
      "📈 [Daily Limit] Compteur incrémenté. Nouvelle valeur en cache : ${exportsCount + 1}",
    );
  }

  // ==================== MÉTHODES DE GESTION DES ÉVÉNEMENTS ====================

  /// Appelée après un découpage réussi
  /// Gère l'affichage des publicités et les demandes d'évaluation
  Future<void> onSplitDone() async {
    successfulCuts.value++;
    await incrementDailyExportCount();

    // Affiche une publicité récompensée tous les 5 découpages (Supprimé : on passe en Opt-in pour l'Export HD)

    // Demande une évaluation tous les 2 découpages
    if (successfulCuts.value % 2 == 0) {
      AppService().handleRatingRequestAfterCutting();
      successfulCuts.value = 0;
    }

    update();
    CacheHelper.saveData(key: "successfulCuts", value: successfulCuts.value);
  }

  /// Gère l'affichage/masquage des options pour un dossier
  /// Toggle la sélection du dossier
  void showFolderOptions(String folderName) {
    if (selectedFolder.value == folderName) {
      selectedFolder.value = "";
    } else {
      selectedFolder.value = folderName;
    }
    update();
  }

  Future showFolderDialog({String? name}) async {
    return await showGeneralDialog(
      context: Get.context!,
      transitionDuration: const Duration(milliseconds: 100),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.decelerate),
            ),
            child: FolderNameDialog(folderName: name),
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
    );
  }

  // ==================== MÉTHODES DE PERMISSIONS ====================

  /// Demande les permissions nécessaires selon la plateforme
  /// Android: Permission de stockage, iOS: Permission photos
  Future<void> requestPermissions() async {
    List<Permission> permissions = [];

    if (Platform.isAndroid) {
      permissions.add(Permission.storage);
    } else if (Platform.isIOS) {
      permissions.add(Permission.photos);
    }

    final statuses = await permissions.request();
    if (kDebugMode) {
      print(statuses);
    }
  }

  // ==================== MÉTHODES UTILITAIRES ====================

  /// Remet à zéro tous les états et sélections
  /// Nettoie l'interface utilisateur
  void clearAll() {
    canSelectVideo.value = false;
    selectedVideo.value = null;
    videoParts.clear();
    selectedVideoParts.clear();
    progress.value = 0.0;
    selectedFolder.value = "";
    update();
  }

  // ==================== MÉTHODES DE GESTION DES PUBLICITÉS ====================

  /// Charge et affiche la bannière publicitaire
  void loadBannerAd() {
    adMobService.loadBannerAd(
      onAdLoadedCallback: () {
        update();
      },
    );
  }

  // ==================== MÉTHODES DE PARTAGE ====================

  /// Initialise l'écoute des intentions de partage
  /// Gère deux cas: app en mémoire et app lancée via partage
  void initSharingListener() {
    log("listening");
    // Cas 1 : Application déjà en mémoire
    intentDataStreamSubscription = FlutterSharingIntent.instance
        .getMediaStream()
        .listen(
          (List<SharedFile> files) {
            if (files.isNotEmpty) {
              handleSharedVideo(files.first);
            }
          },
          onError: (err) {
            print("Erreur de partage (stream) : $err");
          },
        );

    // Cas 2 : Application lancée via partage
    FlutterSharingIntent.instance.getInitialSharing().then((
      List<SharedFile> files,
    ) {
      if (files.isNotEmpty) {
        handleSharedVideo(files.first);
      }
    });
  }

  /// Traite une vidéo reçue via partage
  /// Met à jour la vidéo sélectionnée avec le fichier partagé
  void handleSharedVideo(SharedFile file) {
    try {
      print("📥 Vidéo reçue : ${file.value}");
      if (file.value != null) {
        final videoFile = File(file.value!);
        processAndValidateVideo(videoFile, source: 'share_intent');
      }
    } catch (e) {
      print(e);
    }
  }

  /// Initialise l'écoute des vidéos partagées via l'extension iOS
  void initSharedVideoListener() {
    final sharingService = Get.find<SharingService>();
    // Écouter les changements de vidéo partagée
    ever(sharingService.hasSharedVideo, (hasVideo) {
      if (hasVideo == true) {
        _handleSharedVideoFromExtension();
      }
    });

    // Vérifier immédiatement s'il y a une vidéo partagée
    if (sharingService.hasPendingSharedVideo) {
      _handleSharedVideoFromExtension();
    }
  }

  /// Gère une vidéo partagée reçue via l'extension iOS
  void _handleSharedVideoFromExtension() {
    try {
      final sharingService = Get.find<SharingService>();
      final sharedVideo = sharingService.getAndClearSharedVideo();
      if (sharedVideo != null) {
        print(
          "📱 HomeController: Vidéo partagée reçue via extension: ${sharedVideo.path}",
        );
        processAndValidateVideo(sharedVideo, source: 'share_extension').then((
          success,
        ) {
          if (success) {
            // Afficher une notification à l'utilisateur
            Get.snackbar(
              'Vidéo reçue',
              'Une vidéo a été partagée depuis l\'extension',
              snackPosition: SnackPosition.TOP,
              backgroundColor: AppColors.primary,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
          }
        });
      }
    } catch (e) {
      print(
        "❌ HomeController: Erreur lors du traitement de la vidéo partagée: $e",
      );
    }
  }

  // ==================== MÉTHODES DU CYCLE DE VIE ====================

  @override
  void onInit() {
    loadBannerAd();
    initSharingListener();
    initSharedVideoListener();
    WidgetsBinding.instance.addObserver(this);
    successfulCuts.value = CacheHelper.getInteger(key: "successfulCuts");

    if (Get.isRegistered<RevenueCatService>()) {
      ever(FeatureManager.isProUserRx, (isPro) {
        if (isPro) {
          adMobService.disposeBannerAd();
          update();
        }
      });
    }

    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    adMobService.disposeBannerAd();
    super.onClose();
  }

  /// Gère les changements d'état du cycle de vie de l'application
  /// Affiche des publicités interstitielles après une absence prolongée
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _pausedTime = DateTime.now();
        break;

      case AppLifecycleState.resumed:
        final now = DateTime.now();
        final timeAway =
            _pausedTime != null ? now.difference(_pausedTime!).inSeconds : 0;

        // Affiche une publicité App Open si l'utilisateur revient après 30 secondes
        if (timeAway > 30 && !_interstitialRecentlyShown.value) {
          _interstitialRecentlyShown.value = true;

          adMobService.showAppOpenAdIfAvailable(
            onAdClosed: () {
              // Empêche l'affichage répétitif pendant 1 minute
              Future.delayed(const Duration(minutes: 1), () {
                _interstitialRecentlyShown.value = false;
              });
            },
          );
        }
        isAppInBackground.value = false;
        update();
        break;

      case AppLifecycleState.hidden:
        intentDataStreamSubscription.cancel();
        isAppInBackground.value = true;
        update();
        break;

      default:
        break;
    }
  }
}
