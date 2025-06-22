import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_spliter/app/modules/settings/views/thank_you_view.dart';
import 'package:video_spliter/app/services/bot_service.dart';
import 'package:video_spliter/app/services/firebase_service.dart';
import 'package:video_spliter/app/utils/methods_utils.dart';

class SettingsController extends GetxController {
  final firebaseService = FirebaseService();
  final botService = BotService();

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
      final isSent = await botService.sendFeedback(
        bugDescriptionController.text,
        imagePaths: selectedImagesPath,
      );
      if (isSent) {
        clearForm();
        Get.off(() => const ThankYouView());
        isSending(false);
        update();
      } else {
        Get.back();
        clearForm();
        showSnackBar(
          "Une erreur est survenue lors de l'envoi du rapport, veuillez réessayer plus tard",
          isError: true,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      isSending(false);
      Get.back();
      clearForm();
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
    super.onInit();
  }

  void clearForm() {
    bugDescriptionController.clear();
    selectedImagesPath.clear();
    uploadingFilesPath.clear();
    selectedFilesPath.clear();
  }
}
