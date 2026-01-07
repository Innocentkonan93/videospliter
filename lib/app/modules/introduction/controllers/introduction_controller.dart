import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_spliter/app/configs/caches/cache_helper.dart';
import 'package:video_spliter/app/routes/app_pages.dart';
import 'package:video_spliter/app/services/firebase_notification_service.dart';
import 'package:video_spliter/app/utils/constants.dart';
import 'package:video_spliter/app/utils/methods_utils.dart';

class IntroductionController extends GetxController {
  bool? isIntroductionViewed;
  final pageController = PageController();
  final currentPage = 0.obs;
  final isLoading = false.obs;

  void requestNotifications() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      await FirebaseNotificationService().initFirebaseNotifications();
      completedIntro();
    } else {
      showSnackBar(
        "permission_denied_to_receive_notifications".tr,
        isError: true,
      );
    }
  }

  void completedIntro() async {
    try {
      await CacheHelper.saveData(key: introductionKey, value: true);
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getIntroResult() async {
    isLoading.value = true;
    update();

    await Future.delayed(const Duration(seconds: 2));

    isIntroductionViewed = await CacheHelper.getBool(key: introductionKey);

    if (isIntroductionViewed == true) {
      Get.offAllNamed(Routes.HOME);
    }

    isLoading.value = false;
    update();
  }

  @override
  void onInit() async {
    getIntroResult();
    super.onInit();
  }
}
