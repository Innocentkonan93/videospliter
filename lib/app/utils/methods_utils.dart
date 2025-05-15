import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_spliter/app/configs/app_colors.dart';

void showSnackBar(String message, {bool? isError = false}) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: AppColors.white),
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
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
