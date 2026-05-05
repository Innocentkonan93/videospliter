import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/services/revenuecat_service.dart';
import 'package:video_spliter/app/services/feature_manager.dart';
import 'package:video_spliter/app/services/ad_mob_service.dart';

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
    final isUserPro = FeatureManager.isProUser;

    // Default to Pro if they are a pro user, otherwise Free
    isProSelected = isUserPro;
  }

  void _onExportPressed() {
    if (isProSelected) {
      if (FeatureManager.isProUser) {
        Get.back(result: true); // true = pro
      } else {
        // Option HD pour un utilisateur gratuit : proposer de regarder une pub
        _showAdOrProDialog();
      }
    } else {
      Get.back(result: false); // false = free
    }
  }

  void _showAdOrProDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'export_hd_title'.tr,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text('export_hd_desc'.tr, style: TextStyle(fontSize: 15)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx); // Close dialog
                  Get.find<RevenueCatService>().presentPaywall();
                },
                child: Text(
                  'go_pro'.tr,
                  style: TextStyle(
                    color: AppColors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx); // Close dialog
                  // Show rewarded ad
                  AdMobService().showRewardedAd(
                    onEarnedReward: () {
                      Get.back(result: true); // Reward granted, proceed with HD
                    },
                    onAdFailedToLoad: () {
                      Get.snackbar(
                        'error'.tr,
                        'ad_load_error'.tr,
                        backgroundColor: Colors.red[100],
                        colorText: Colors.red[900],
                      );
                    },
                  );
                },
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedPlayCircle,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'unlock'.tr,
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isUserPro = FeatureManager.isProUser;
    final isProAvailable = FeatureManager.isProVersionAvailable;

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 32),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24),
          HugeIcon(
            icon: HugeIcons.strokeRoundedDownload04,
            color: AppColors.primary.withValues(alpha: 0.8),
            size: 32,
          ),
          const SizedBox(height: 16),
          // Text(
          //   'export_type'.tr,
          //   style: theme.textTheme.headlineSmall?.copyWith(
          //     fontWeight: FontWeight.w900,
          //     color: AppColors.black,
          //     letterSpacing: -0.5,
          //   ),
          // ),
          // const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'choose_export_quality'.tr,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildExportOption(
                title: 'Normal',
                subtitle: '480p • SD',
                icon: HugeIcons.strokeRoundedVideo02,
                isSelected: !isProSelected,
                color: Colors.blueGrey,
                onTap: () => setState(() => isProSelected = false),
              ),
              if (isProAvailable) ...[
                const SizedBox(width: 16),
                _buildExportOption(
                  title: 'HD',
                  subtitle: '1080p • Full HD',
                  icon: HugeIcons.strokeRoundedAiVideo,
                  isSelected: isProSelected,
                  color: AppColors.orange,
                  isProBadge: true,
                  isProUser: isUserPro,
                  onTap: () => setState(() => isProSelected = true),
                ),
              ],
            ],
          ),

          const SizedBox(height: 40),

          // Export Button
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.orange.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _onExportPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedSuperellipseBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'export'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowRight01,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportOption({
    required String title,
    required String subtitle,
    required List<List<dynamic>> icon,
    required bool isSelected,
    required Color color,
    VoidCallback? onTap,
    bool isProBadge = false,
    bool isProUser = false,
  }) {
    final theme = context.theme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        width: 150,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: isSelected ? color.withValues(alpha: 0.08) : theme.cardColor,
          shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: isSelected ? color : Colors.grey.withValues(alpha: 0.2),
              width: isSelected ? 2.5 : 1,
            ),
          ),
          shadows:
              isSelected
                  ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ]
                  : [],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? color.withValues(alpha: 0.15)
                            : Colors.grey.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: HugeIcon(
                    icon: icon,
                    color: isSelected ? color : Colors.grey[500]!,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isSelected ? color : Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        isSelected
                            ? color.withValues(alpha: 0.7)
                            : Colors.grey[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (isProBadge)
              Positioned(
                top: -24,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient:
                        isProUser
                            ? const LinearGradient(
                              colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                            )
                            : const LinearGradient(
                              colors: [Color(0xFFE94057), AppColors.primary],
                            ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isProUser) ...[
                        const Icon(Icons.check, color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        isProUser ? "ACTIVE" : "PRO",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (isSelected)
              Positioned(
                top: -8,
                left: -8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle, color: color, size: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
