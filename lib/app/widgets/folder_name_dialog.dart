import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_spliter/app/configs/app_colors.dart';

class FolderNameDialog extends StatelessWidget {
  const FolderNameDialog({super.key, this.folderName, this.isNew = false});
  final String? folderName;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    final name = TextEditingController();
    if (folderName != null) {
      name.text = folderName!.split("-").first;
    }
    return AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary,
            child: Icon(CupertinoIcons.folder, color: AppColors.white),
          ),
          SizedBox(height: 10),
          Text(
            folderName?.isNotEmpty ?? false
                ? 'rename_folder'.tr
                : 'save_folder'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.zero,

      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(hintText: 'new_folder'.tr),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          style: TextButton.styleFrom(
            backgroundColor: AppColors.red.withValues(alpha: .1),
            foregroundColor: AppColors.red,
            elevation: 0,
          ),
          child: Text('cancel'.tr),
        ),

        ElevatedButton(
          onPressed: () {
            Get.back(result: name.text);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
          ),
          child: Text('ok'.tr),
        ),
      ],
    );
  }
}
