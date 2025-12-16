import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_spliter/app/configs/app_colors.dart';

class PremiumCard extends StatelessWidget {
  const PremiumCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Card(
      color: AppColors.primary.withValues(alpha: 0.95),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.snackbar(
            "Premium",
            "Upgrade to Cutit Premium coming soon!",
            backgroundColor: AppColors.white,
            colorText: AppColors.primary,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              Icon(
                Icons.workspace_premium_rounded,
                color: Colors.yellow,
                size: 36,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "premium_title".tr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "premium_subtitle".tr,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
