import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_spliter/app/configs/caches/cache_helper.dart';
import 'package:video_spliter/app/routes/app_pages.dart';
import 'package:video_spliter/app/services/firebase_notification_service.dart';
import 'package:video_spliter/app/services/revenuecat_service.dart';
import 'package:video_spliter/app/utils/constants.dart';

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
      // showSnackBar(
      //   "permission_denied_to_receive_notifications".tr,
      //   isError: true,
      // );
      completedIntro();
    }
  }

  void completedIntro() async {
    try {
      await CacheHelper.saveData(key: introductionKey, value: true);
      // Funnel: Présenter le Paywall à la fin de l'intro pour les nouveaux utilisateurs
      final revenueCatService = Get.find<RevenueCatService>();
      await revenueCatService.presentPaywallIfNeeded(placement: 'onboarding');

      // Navigation vers la Home après fermeture du Paywall (ou si déjà Pro)
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      debugPrint(e.toString());
      Get.offAllNamed(Routes.HOME);
    }
  }
}
