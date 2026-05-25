// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_spliter/app/configs/caches/cache_helper.dart';
import 'package:video_spliter/app/modules/settings/views/thank_you_view.dart';
import 'package:video_spliter/app/services/app_service.dart';
import 'package:video_spliter/app/services/feedback_service.dart';
import 'package:video_spliter/app/services/firebase_service.dart';
import 'package:video_spliter/app/utils/constants.dart';
import 'package:video_spliter/app/utils/methods_utils.dart';
import 'package:video_spliter/app/services/analytics_service.dart';
import 'package:video_spliter/app/services/firebase_notification_service.dart';

class SettingsController extends GetxController {
  final firebaseService = FirebaseService();

  final formKey = GlobalKey<FormState>();
  final imagePicker = ImagePicker();
  final appName = ''.obs;
  final packageName = ''.obs;
  final version = ''.obs;
  final buildNumber = ''.obs;
  final buildSignature = ''.obs;
  final storeInstaller = ''.obs;
  final selectedImagesPath = <String>[].obs;

  final bugDescriptionController = TextEditingController();
  final isPicking = false.obs;
  final isSaving = false.obs;
  final isUploading = false.obs;
  final isSending = false.obs;
  final uploadingFilesPath = <Map<dynamic, String>>[].obs;
  final selectedFilesPath = <Map<dynamic, String>>[].obs;

  // RxBool isFrench = (Get.locale?.languageCode.toString() == 'fr').obs;

  final selectedLanguage = ''.obs;

  Future<void> selectLanguage(String language) async {
    final oldLanguage = selectedLanguage.value;
    Get.updateLocale(Locale(language));
    // isFrench.value = language == 'fr';
    selectedLanguage.value = language;
    // Sauvegarder la langue sélectionnée dans le cache
    await CacheHelper.saveData(key: selectedLanguageKey, value: language);

    // Mettre à jour les topics FCM de l'utilisateur
    if (Get.isRegistered<FirebaseNotificationService>()) {
      FirebaseNotificationService.to.syncTopics();
    }

    // Enregistrer le changement de langue dans Google Analytics (met également à jour la user property)
    AnalyticsService.languageChanged(
      fromLanguage: oldLanguage.isNotEmpty ? oldLanguage : 'unknown',
      toLanguage: language,
    );

    update();
  }

  Future<void> loadSavedLanguage() async {
    try {
      final savedLanguage = await CacheHelper.getString(
        key: selectedLanguageKey,
      );
      if (savedLanguage.isNotEmpty) {
        selectedLanguage.value = savedLanguage;
        Get.updateLocale(Locale(savedLanguage));
      } else {
        // Si aucune langue n'est sauvegardée, utiliser la langue du système
        final deviceLocale = Get.deviceLocale;
        if (deviceLocale != null) {
          selectedLanguage.value = deviceLocale.languageCode;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors du chargement de la langue sauvegardée: $e');
      }
    }
  }

  Future<void> pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      await Permission.camera.request();
    } else {
      await Permission.photos.request();
    }
    isPicking(true);
    final XFile? result = await imagePicker.pickImage(source: source);
    if (result != null) {
      selectedImagesPath.add(result.path);
      isPicking(false);
    } else {
      isPicking(false);
      return;
    }
  }

  Future<void> storeRequestFiles() async {
    for (var i = 0; i < selectedImagesPath.length; i++) {
      Map<dynamic, String> map = {i: selectedImagesPath[i]};
      selectedFilesPath.add(map);
    }
    try {
      if (selectedFilesPath.isNotEmpty) {
        isUploading(true);
        await Future.wait(
          selectedFilesPath.map((map) async {
            String field = map.entries.first.key.toString();
            String url = await firebaseService.uploadImage(
              "/reports/bugs/",
              map.entries.first.value,
            );

            Map<dynamic, String> item = {field: url};
            uploadingFilesPath.add(item);
          }),
        );
        isUploading(false);
      }
    } catch (e) {
      // showErrorDialog();
      if (kDebugMode) {
        print(e);
      }
      isSaving(false);
      isUploading(false);
    }
  }

  Future<dynamic> getFeedbackFilesUrl() async {
    Map<dynamic, dynamic> jsonB = {};

    for (var i = 0; i < uploadingFilesPath.length; i++) {
      jsonB.addAll(uploadingFilesPath[i]);
    }

    return jsonB;
  }

  Future<void> getPackageInfo() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appName(packageInfo.appName);
      packageName(packageInfo.packageName);
      version(packageInfo.version);
      buildNumber(packageInfo.packageName);
      buildSignature(packageInfo.buildSignature);
      storeInstaller(packageInfo.installerStore);
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendFeedback() async {
    try {
      isSending(true);
      update();

      List<String> imageUrls = [];
      if (selectedImagesPath.isNotEmpty) {
        for (String path in selectedImagesPath) {
          try {
            String url = await firebaseService.uploadImage(
              "/reports/bugs/",
              path,
            );
            imageUrls.add(url);
          } catch (e) {
            print("Failed to upload image $path: $e");
          }
        }
      }

      await FeedbackService().send(
        message: bugDescriptionController.text,
        type: FeedbackType.manual,
        step: 'manual_report',
        attachments: imageUrls,
      );

      clearForm();
      Get.off(() => const ThankYouView());
      // Demande de notation après un feedback envoyé avec succès
      AppService().handleRatingRequestAfterFeedback();
      isSending(false);
      update();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      isSending(false);
      Get.back();
      // clearForm(); // Maybe don't clear form on error so user can retry?
      // But original code cleared it. I will follow original behavior or improve?
      // Original: clearForm(); showSnackBar(...)
      // Better UX: keep form so they don't lose text.
      showSnackBar(
        "Une erreur est survenue lors de l'envoi du rapport, veuillez réessayer plus tard",
        isError: true,
      );
      update();
    }
  }

  @override
  void onInit() {
    getPackageInfo();
    loadSavedLanguage();
    super.onInit();
  }

  void clearForm() {
    bugDescriptionController.clear();
    selectedImagesPath.clear();
    uploadingFilesPath.clear();
    selectedFilesPath.clear();
  }
}
