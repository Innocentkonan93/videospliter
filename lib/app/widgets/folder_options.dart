import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/controllers/home_controller.dart';

class FolderOptions extends GetWidget<HomeController> {
  const FolderOptions({super.key, required this.onDone});
  final Function() onDone;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final folderName = controller.selectedFolder.value;
      return controller.selectedFolder.value.isNotEmpty
          ? Padding(
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      await controller.renameFolder(folderName);
                      controller.selectedFolder.value = "";
                      onDone();
                      controller.update();
                    },
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedPencilEdit01,
                      color: AppColors.white,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                    ),
                    label: Text("rename_folder".tr),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      controller.selectedFolder.value = "";
                      await controller.deleteFolder(folderName);
                      controller.selectedFolder.value = "";
                      onDone();
                      controller.update();
                    },
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedDelete01,
                      color: AppColors.white,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                    ),
                    label: Text("delete_folder".tr),
                  ),
                ],
              ),
            ),
          ).animate().slideY(duration: 100.ms, begin: 1.0, end: 0.0)
          : SizedBox();
    });
  }
}
