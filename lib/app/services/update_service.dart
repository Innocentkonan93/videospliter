import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:versionarte/versionarte.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/widgets/app_update_dialog.dart';

class UpdateService extends GetxService with WidgetsBindingObserver {
  /// Instance statique pour un accès facile
  static UpdateService get to => Get.find();

  bool _isDialogShowing = false;

  Future<UpdateService> init() async {
    return this;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkForUpdates();
    }
  }

  static Future<bool> get isUpdateAvailable async {
    try {
      final result = await Versionarte.check(
        versionarteProvider: RemoteConfigVersionarteProvider(
          keyName: 'app_version',
        ),
      );

      return result.status == VersionarteStatus.outdated ||
          result.status == VersionarteStatus.forcedUpdate ||
          result.status == VersionarteStatus.inactive;
    } catch (e) {
      debugPrint('Error checking for updates: $e');
      return false;
    }
  }

  static Future<bool> get isForceUpdateAvailable async {
    try {
      final result = await Versionarte.check(
        versionarteProvider: RemoteConfigVersionarteProvider(
          keyName: 'app_version',
        ),
      );

      return result.status == VersionarteStatus.outdated ||
          result.status == VersionarteStatus.inactive;
    } catch (e) {
      debugPrint('Error checking for updates: $e');
      return false;
    }
  }

  /// Vérifie si une mise à jour est nécessaire
  Future<void> checkForUpdates({bool showNoUpdateDialog = false}) async {
    if (_isDialogShowing) return;

    try {
      final result = await Versionarte.check(
        versionarteProvider: RemoteConfigVersionarteProvider(
          keyName: 'app_version',
        ),
      );

      if (result.status == VersionarteStatus.outdated ||
          result.status == VersionarteStatus.forcedUpdate ||
          result.status == VersionarteStatus.inactive) {
        final isMandatory =
            result.status == VersionarteStatus.forcedUpdate ||
            result.status == VersionarteStatus.inactive;

        _showUpdateDialog(
          result.getMessageForLanguage(Get.locale?.languageCode ?? "en"),
          Get.context!,
          isMandatory,
        );
      } else if (showNoUpdateDialog) {
        Get.snackbar(
          'update_check'.tr,
          'app_up_to_date'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: AppColors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 16,
        );
      }
    } catch (e) {
      debugPrint('Error checking for updates: $e');
      if (showNoUpdateDialog) {
        Get.snackbar(
          'error'.tr,
          'update_check_error'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.red,
          colorText: AppColors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 16,
        );
      }
    }
  }

  // / Affiche le dialogue de mise à jour
  void _showUpdateDialog(
    String? message,
    BuildContext context,
    bool isMandatory,
  ) async {
    _isDialogShowing = true;

    await showDialog(
      context: context,
      barrierDismissible: !isMandatory,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: AppUpdateDialog(
            message: message ?? "",
            isMandatory: isMandatory,
          ),
        );
      },
    );

    _isDialogShowing = false;
  }
}
