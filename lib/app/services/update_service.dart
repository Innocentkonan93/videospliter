import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:versionarte/versionarte.dart';
import 'package:video_spliter/app/configs/app_colors.dart';

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

  /// Vérifie si une mise à jour est nécessaire
  Future<void> checkForUpdates() async {
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
      }
    } catch (e) {
      debugPrint('Error checking for updates: $e');
    }
  }

  // / Affiche le dialogue de mise à jour
  void _showUpdateDialog(
    String? message,
    BuildContext context,
    bool isMandatory,
  ) async {
    _isDialogShowing = true;
    final theme = context.theme;

    await showDialog(
      context: context,
      barrierDismissible: !isMandatory,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  if (!isMandatory)
                    Positioned(
                      right: -8,
                      top: -8,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: AppColors.grey),
                      ),
                    ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.rocket_launch_rounded,
                          color: AppColors.primary,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        isMandatory
                            ? 'update_mandatory_title'.tr
                            : 'update_optional_title'.tr,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        message ?? "",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.black.withOpacity(0.7),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            Versionarte.launchDownloadUrl({
                              TargetPlatform.android:
                                  "https://play.google.com/store/apps/details?id=com.meetsum.cutIt",
                              TargetPlatform.iOS:
                                  "https://apps.apple.com/fr/app/cutit-couper-diviser-vidéo/id6747193487",
                            });
                          },
                          child: Text(
                            'update_button'.tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (!isMandatory) ...[
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'later'.tr,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    _isDialogShowing = false;
  }
}
