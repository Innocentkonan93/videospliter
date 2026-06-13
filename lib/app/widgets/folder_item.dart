import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/views/result_view.dart';

import '../modules/home/controllers/home_controller.dart';

class FolderItem extends GetWidget<HomeController> {
  const FolderItem({
    super.key,
    required this.folder,
    required this.folderName,
    required this.createdAt,
    required this.itemCount,
  });

  final Directory folder;
  final String folderName;
  final DateTime createdAt;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return GetBuilder<HomeController>(
      builder: (controller) {
        return GestureDetector(
          onTap: () async {
            final List<File> parts = [];
            try {
              await for (var entity in folder.list(
                recursive: false,
                followLinks: false,
              )) {
                if (entity is File && entity.path.endsWith('.mp4')) {
                  parts.add(entity);
                }
              }

              if (parts.isEmpty) {
                Get.snackbar('Aucun fichier', 'Ce dossier est vide');
                return;
              }

              Get.to(() => ResultView(parts: parts, isSaved: true));
            } catch (e) {
              log("Erreur lors de la lecture du dossier : $e");
              Get.snackbar('Erreur', 'Impossible de lire le dossier');
            }
          },
          child: Container(
            decoration:
                controller.selectedFolder.value == folderName
                    ? BoxDecoration(
                      color: AppColors.grey.withValues(alpha: .2),
                      border: Border.all(
                        color: AppColors.grey.withValues(alpha: .2),
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    )
                    : null,
            child: Column(
              children: [
                Expanded(
                  child: SizedBox.expand(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/folder.webp'),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 45,
                          left: 15,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const HugeIcon(
                                  icon: HugeIcons.strokeRoundedVideo01,
                                  color: AppColors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$itemCount',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 30,
                          right: 10,
                          child: Text(
                            DateFormat('dd.MM.yyyy').format(createdAt),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.white.withValues(alpha: .25),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 10,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  folderName.split('-').first,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  controller.showFolderOptions(folderName);
                                },
                                child: const HugeIcon(
                                  icon:
                                      HugeIcons
                                          .strokeRoundedMoreHorizontalCircle01,
                                  color: AppColors.black,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
