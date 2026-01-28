import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_kit_16kb/ffprobe_kit.dart';
// import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/configs/caches/cache_helper.dart';
import 'package:video_spliter/app/services/analytics_service.dart';
import 'package:video_spliter/app/services/app_service.dart';
import 'package:video_spliter/app/services/file_service.dart';
import 'package:video_spliter/app/utils/methods_utils.dart';
import 'package:video_spliter/app/services/ad_mob_service.dart';
import 'package:video_spliter/app/services/save_segments_service.dart';
import 'package:video_spliter/app/services/video_service.dart';
import 'package:video_spliter/app/services/sharing_service.dart';
import 'package:video_spliter/app/widgets/deletion_dialog.dart';
import 'package:video_spliter/app/widgets/folder_name_dialog.dart';

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

  /// Map des contrôleurs vidéo pour chaque fichier
  final Map<File, VideoPlayerController> videoControllers = {};

  /// Page actuellement affichée
  RxInt currentPage = 0.obs;

  /// Durée de découpage en secondes
  RxDouble sliceDuration = 30.0.obs;

  /// Indicateur si l'utilisateur peut sélectionner une vidéo
  final canSelectVideo = false.obs;

  /// Indicateur si l'application est en arrière-plan
  final isAppInBackground = false.obs;

  /// Bannière publicitaire
  BannerAd? banner;

  /// Nombre de découpages réussis
  final successfulCuts = 0.obs;

  /// Progression du traitement
  RxDouble progress = 0.0.obs;

  /// Indicateur si la bannière publicitaire est chargée
  final isBannerLoaded = false.obs;

  /// Dossier actuellement sélectionné pour les options
  final selectedFolder = "".obs;

  // ==================== MÉTHODES DE SÉLECTION DE FICHIERS ====================

  /// Permet à l'utilisateur de sélectionner une vidéo depuis le système de fichiers
  /// Demande les permissions nécessaires avant la sélection
  Future<void> pickVideo() async {
    try {
      selectedFolder.value = "";
      await requestPermissions();
      final result = await FilePicker.platform.pickFiles(type: FileType.video);

      if (result != null && result.files.single.path != null) {
        final videoFile = File(result.files.single.path!);
        selectedVideo.value = videoFile;
        // compresser les videos de grande taille

        log((videoFile.lengthSync() / (1024 * 1024)).toString());
        // Enregistrer l'import de la vidéo dans analytics
        try {
          final mediaInfoSession = await FFprobeKit.getMediaInformation(
            videoFile.path,
          );
          final info = mediaInfoSession.getMediaInformation();
          final durationSec = double.tryParse(info?.getDuration() ?? '0') ?? 0;
          final sizeMb = videoFile.lengthSync() / (1024 * 1024);
          // Enregistrer l'import de la vidéo dans analytics
          await AnalyticsService.videoImported(
            durationSec: durationSec.round(),
            sizeMb: sizeMb,
            source: 'file_picker',
          );
          // Compresser uniquement les vidéos lourdes (> 50 Mo) pour optimiser le temps
          if (sizeMb > 1) {
            await compressVideo();
          }
        } catch (e) {
          // Si l'analyse de la vidéo échoue, on enregistre quand même l'import
          // avec des valeurs par défaut
          final sizeMb = videoFile.lengthSync() / (1024 * 1024);
          await AnalyticsService.videoImported(
            durationSec: 0,
            sizeMb: sizeMb,
            source: 'file_picker',
          );
        }
      }

      update();
    } catch (e) {
      showSnackBar(e.toString());
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
    final parts = await VideoService.splitBySSAsync(
      videoFile: selectedVideo.value!,
      sliceDuration: sliceDuration.value,
    );
    videoParts.addAll(parts);
    return parts;
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
    adMobService.loadInterstitialAd(
      onAdDismissed: () {
        update();
      },
      onAdReady: () {
        adMobService.showInterstitialAd();
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

  // ==================== MÉTHODES DE GESTION DES CONTRÔLEURS VIDÉO ====================

  /// Initialise les contrôleurs vidéo pour une liste de fichiers
  /// Évite la duplication en vérifiant l'existence avant création
  Future<void> initVideoControllers(
    List<File> parts, {
    bool isSaved = false,
  }) async {
    for (final file in parts) {
      if (!videoControllers.containsKey(file)) {
        final controller = VideoPlayerController.file(file);
        await controller.initialize();
        videoControllers[file] = controller;
      }
    }
    if (isSaved) {
      update();
    }
  }

  /// Libère la mémoire en disposant tous les contrôleurs vidéo
  /// Nettoie la map des contrôleurs
  Future<void> disposeVideoControllers() async {
    for (final controller in videoControllers.values) {
      await controller.dispose();
    }
    videoControllers.clear();
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

  // ==================== MÉTHODES DE GESTION DES ÉVÉNEMENTS ====================

  /// Appelée après un découpage réussi
  /// Gère l'affichage des publicités et les demandes d'évaluation
  void onSplitDone() {
    successfulCuts.value++;

    // Affiche une publicité récompensée tous les 5 découpages
    if (successfulCuts.value % 5 == 0) {
      adMobService.loadRewardedAd(
        onEarnedReward: () {
          successfulCuts.value = 0;
        },
      );
    }

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
    print(statuses);
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
    banner = adMobService.loadBannerAd();
    isBannerLoaded.value = true;
    update();
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
        selectedVideo.value = File(file.value!);
      }
      update();
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
        selectedVideo.value = sharedVideo;

        // Afficher une notification à l'utilisateur
        Get.snackbar(
          'Vidéo reçue',
          'Une vidéo a été partagée depuis l\'extension',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        update();
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
    super.onInit();
  }

  @override
  void onClose() {
    banner?.dispose();
    WidgetsBinding.instance.removeObserver(this);
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

        // Affiche une publicité si l'utilisateur revient après 30 secondes
        if (timeAway > 30 && !_interstitialRecentlyShown.value) {
          _interstitialRecentlyShown.value = true;

          adMobService.loadInterstitialAd(
            onAdDismissed: () {
              // Empêche l'affichage répétitif pendant 3 minutes
              Future.delayed(const Duration(minutes: 3), () {
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
