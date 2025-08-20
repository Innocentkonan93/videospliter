import 'dart:async';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Service pour gérer la réception des vidéos partagées via l'extension iOS
class SharingService extends GetxService {
  /// Stream pour écouter les vidéos partagées
  final Rx<File?> sharedVideo = Rx<File?>(null);

  /// Indicateur si une vidéo a été partagée
  final RxBool hasSharedVideo = false.obs;

  /// Timer pour vérifier périodiquement les vidéos partagées
  Timer? _checkTimer;

  /// Nom du groupe d'applications pour le partage de données
  // static const String _appGroupName = 'group.com.meetsum.cutit';

  @override
  void onInit() {
    super.onInit();
    _startListening();
  }

  @override
  void onClose() {
    _stopListening();
    super.onClose();
  }

  /// Démarre l'écoute des vidéos partagées
  void _startListening() {
    log("🎯 SharingService: Démarrage de l'écoute des vidéos partagées");

    // Vérifier immédiatement s'il y a une vidéo partagée
    _checkForSharedVideo();

    // Vérifier périodiquement (toutes les 2 secondes)
    _checkTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _checkForSharedVideo();
    });
  }

  /// Arrête l'écoute des vidéos partagées
  void _stopListening() {
    log("🛑 SharingService: Arrêt de l'écoute des vidéos partagées");
    _checkTimer?.cancel();
    _checkTimer = null;
  }

  /// Vérifie s'il y a une nouvelle vidéo partagée
  Future<void> _checkForSharedVideo() async {
    try {
      // Utiliser le plugin flutter_sharing_intent pour iOS
      if (Platform.isIOS) {
        await _checkIOSSharedVideo();
      }
    } catch (e) {
      log(
        "❌ SharingService: Erreur lors de la vérification des vidéos partagées: $e",
      );
    }
  }

  /// Vérifie les vidéos partagées sur iOS
  Future<void> _checkIOSSharedVideo() async {
    try {
      // Ici nous utiliserons une méthode native pour accéder à UserDefaults partagé
      // Pour l'instant, nous simulons avec une méthode de test
      final result = await _getSharedVideoFromUserDefaults();

      if (result != null && result.isNotEmpty) {
        _handleSharedVideo(result);
      }
    } catch (e) {
      log("❌ SharingService: Erreur iOS: $e");
    }
  }

  /// Récupère la vidéo partagée depuis UserDefaults (méthode native)
  Future<String?> _getSharedVideoFromUserDefaults() async {
    try {
      // Appel à la méthode native iOS
      const platform = MethodChannel('com.meetsum.cutit/sharing');
      final result = await platform.invokeMethod('getSharedVideo');
      return result;
    } on PlatformException catch (e) {
      log("❌ SharingService: Erreur de plateforme: $e");
      return null;
    }
  }

  /// Gère une vidéo partagée reçue
  Future<void> _handleSharedVideo(String videoPath) async {
    try {
      log("📥 SharingService: Vidéo partagée reçue: $videoPath");

      // Vérifier si le fichier existe
      final file = File(videoPath);
      if (await file.exists()) {
        sharedVideo.value = file;
        hasSharedVideo.value = true;

        log("✅ SharingService: Vidéo partagée chargée avec succès");

        // Nettoyer les données partagées après traitement
        await _clearSharedVideoData();
      } else {
        log("⚠️ SharingService: Fichier vidéo introuvable: $videoPath");
      }
    } catch (e) {
      log(
        "❌ SharingService: Erreur lors du traitement de la vidéo partagée: $e",
      );
    }
  }

  /// Nettoie les données de vidéo partagée
  Future<void> _clearSharedVideoData() async {
    try {
      if (Platform.isIOS) {
        const platform = MethodChannel('com.meetsum.cutit/sharing');
        await platform.invokeMethod('clearSharedVideo');
        log("🧹 SharingService: Données partagées nettoyées");
      }
    } catch (e) {
      log("❌ SharingService: Erreur lors du nettoyage: $e");
    }
  }

  /// Récupère la vidéo partagée actuelle et la réinitialise
  File? getAndClearSharedVideo() {
    final video = sharedVideo.value;
    if (video != null) {
      sharedVideo.value = null;
      hasSharedVideo.value = false;
      log("📤 SharingService: Vidéo partagée récupérée et réinitialisée");
    }
    return video;
  }

  /// Vérifie s'il y a une vidéo partagée en attente
  bool get hasPendingSharedVideo =>
      hasSharedVideo.value && sharedVideo.value != null;
}
