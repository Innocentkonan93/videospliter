import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:versionarte/versionarte.dart';
import 'package:video_spliter/app/configs/app_colors.dart';

class AppUpdateDialog extends StatelessWidget {
  const AppUpdateDialog({
    super.key,

    required this.isMandatory,
    required this.message,
  });

  final bool isMandatory;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: ShapeDecoration(
          color: AppColors.white,
          shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          shadows: [
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
    );
  }
}
