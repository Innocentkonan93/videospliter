import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/controllers/home_controller.dart';

class DeletionDialog extends GetView<HomeController> {
  const DeletionDialog({super.key, this.onDone, required this.folderName});

  final VoidCallback? onDone;
  final String folderName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.red,
            child: Icon(CupertinoIcons.trash, color: AppColors.white),
          ),
          SizedBox(height: 10),
          Text(
            '${'delete_folder'.tr} \n"${folderName.split("-").first}"',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.red,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Text('delete_folder_confirm'.tr, textAlign: TextAlign.center),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          style: TextButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
          ),
          child: Text('cancel'.tr),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          style: TextButton.styleFrom(
            backgroundColor: AppColors.red.withValues(alpha: .1),
            foregroundColor: AppColors.red,
          ),
          child: Text('delete'.tr),
        ),
      ],
    );
  }
}
