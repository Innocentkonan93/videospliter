import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/utils/methods_utils.dart';

class PremiumLimitDialog extends StatelessWidget {
  final bool isSizeExceeded;
  final double value;
  final double limit;

  const PremiumLimitDialog({
    super.key,
    required this.isSizeExceeded,
    required this.value,
    required this.limit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    String descText = "";
    if (isSizeExceeded) {
      descText = 'size_limit_exceeded_desc'.tr
          .replaceAll('@size', value.toStringAsFixed(1))
          .replaceAll('@limit', limit.toInt().toString());
    } else {
      descText = 'duration_limit_exceeded_desc'.tr
          .replaceAll('@duration', formatDuration(Duration(seconds: value.toInt())))
          .replaceAll('@limit', (limit / 60).toInt().toString());
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: ShapeDecoration(
          color: AppColors.white,
          shape: const RoundedSuperellipseBorder(
            borderRadius: BorderRadius.all(Radius.circular(35)),
          ),
          shadows: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -8,
              top: -8,
              child: IconButton(
                onPressed: () => Navigator.pop(context, false),
                icon: const Icon(Icons.close, color: AppColors.grey),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedChampion,
                    color: AppColors.orange,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'limit_exceeded_title'.tr,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  descText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.black.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.orange.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text(
                        'upgrade_to_pro'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'later'.tr,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

@Preview(name: 'Exceeded Size Limit Dialog', group: 'Dialogs')
Widget previewSizeLimit() {
  return const PremiumLimitDialog(
    isSizeExceeded: true,
    value: 254.5,
    limit: 150.0,
  );
}

@Preview(name: 'Exceeded Duration Limit Dialog', group: 'Dialogs')
Widget previewDurationLimit() {
  return const PremiumLimitDialog(
    isSizeExceeded: false,
    value: 1200.0,
    limit: 600.0,
  );
}
