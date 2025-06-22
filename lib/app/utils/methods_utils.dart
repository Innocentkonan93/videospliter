import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_spliter/app/configs/app_colors.dart';

void showSnackBar(String message, {bool? isError = false}) {
  ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
  ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            isError == true ? Icons.error : Icons.check_circle_rounded,
            color: AppColors.white,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Get.theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isError == true ? AppColors.red : AppColors.green,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 10),
      elevation: 0,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

void vibrate() async {
  // HapticFeedback.lightImpact(); // ou Vibration.vibrate(duration: 50);
  HapticFeedback.mediumImpact(); // moyen
  // HapticFeedback.heavyImpact(); // fort
  // HapticFeedback.selectionClick(); // clic type sélection
}
