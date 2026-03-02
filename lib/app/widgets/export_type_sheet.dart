import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/services/revenuecat_service.dart';

class ExportTypeSheet extends StatefulWidget {
  const ExportTypeSheet({super.key});

  @override
  State<ExportTypeSheet> createState() => _ExportTypeSheetState();
}

class _ExportTypeSheetState extends State<ExportTypeSheet> {
  bool isProSelected = false;

  @override
  void initState() {
    super.initState();
    final isUserPro =
        Get.isRegistered<RevenueCatService>() &&
        Get.find<RevenueCatService>().isProUser.value;

    // Default to Pro if they are a pro user, otherwise Free
    isProSelected = isUserPro;
  }

  void _onExportPressed() {
    if (isProSelected) {
      final revenueCatService = Get.find<RevenueCatService>();
      if (revenueCatService.isProUser.value) {
        Get.back(result: true); // true = pro
      } else {
        Get.back(); // Close sheet
        revenueCatService.presentPaywall();
      }
    } else {
      Get.back(result: false); // false = free
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isUserPro =
        Get.isRegistered<RevenueCatService>() &&
        Get.find<RevenueCatService>().isProUser.value;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'export_type'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'choose_export_quality'.tr,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Spacer(),
              Expanded(
                child: _buildExportOption(
                  title: 'Normal',
                  isSelected: !isProSelected,
                  color: Colors.blueGrey,
                  onTap: () => setState(() => isProSelected = false),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildExportOption(
                  title: 'HD',
                  isSelected: isProSelected,
                  color: AppColors.orange,
                  isProBadge: true,
                  isProUser: isUserPro,
                  onTap:
                      isUserPro
                          ? () => setState(() => isProSelected = true)
                          : () =>
                              Get.find<RevenueCatService>().presentPaywall(),
                ),
              ),
              Spacer(),
            ],
          ),

          const SizedBox(height: 30),

          // Export Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onExportPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedSuperellipseBorder(
                  borderRadius: BorderRadius.circular(15),
                  side:
                      isProSelected
                          ? const BorderSide(color: AppColors.orange, width: 2)
                          : BorderSide.none,
                ),
                elevation: 0,
              ),
              child: Text(
                'export'.tr,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildExportOption({
    required String title,
    required bool isSelected,
    required Color color,
    VoidCallback? onTap,
    bool isProBadge = false,
    bool isProUser = false,
  }) {
    final theme = context.theme;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            width: double.infinity,
            decoration: ShapeDecoration(
              color:
                  isSelected
                      ? color.withValues(alpha: 0.1)
                      : Colors.transparent,
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color:
                      isSelected ? color : Colors.grey.withValues(alpha: 0.4),
                  width: isSelected ? 2 : 1.5,
                ),
              ),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Colors.grey[700],
              ),
            ),
          ),
          if (isProBadge)
            Positioned(
              top: -10,
              right: -5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient:
                      isProUser
                          ? null
                          : const LinearGradient(
                            colors: [Color(0xFF8A2387), Color(0xFFE94057)],
                          ),
                  color: isProUser ? AppColors.green : null,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child:
                    isProUser
                        ? const Icon(Icons.check, color: Colors.white, size: 14)
                        : const Text(
                          "PRO",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
        ],
      ),
    );
  }
}
