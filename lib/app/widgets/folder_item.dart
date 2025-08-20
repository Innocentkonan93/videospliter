import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  });

  final Directory folder;
  final String folderName;
  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return GetBuilder<HomeController>(
      init: HomeController(),
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
                                image: AssetImage('assets/images/folder.png'),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 30,
                          left: 20,
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
                                child: Icon(CupertinoIcons.ellipsis_circle),
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
