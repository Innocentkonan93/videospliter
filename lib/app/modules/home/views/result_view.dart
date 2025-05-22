import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/views/video_player_view.dart';
import 'package:video_spliter/app/services/video_service.dart';
import 'package:video_spliter/app/utils/methods_utils.dart';
import '../controllers/home_controller.dart';

class ResultView extends StatefulWidget {
  const ResultView({super.key, required this.parts, this.isSaved = false});

  final List<File> parts;
  final bool isSaved;

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  final controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    controller.initVideoControllers(widget.parts);
  }

  @override
  void dispose() {
    controller.disposeVideoControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            leading: Visibility(
              visible: !controller.canSelectVideo.value,
              replacement: IconButton(
                onPressed: () {
                  controller.canSelectVideo.value = false;
                  controller.selectedVideoParts.clear();
                  controller.update();
                },
                icon: const Icon(Icons.close),
              ),
              child: BackButton(
                onPressed: () {
                  Get.back();
                  controller.clearAll();
                },
              ),
            ),
            title: Text(
              controller.canSelectVideo.value
                  ? 'Sélectionner'
                  : 'Résultats du découpage',
            ),
            actions: [
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                offset: Offset(0, kToolbarHeight),
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded),
                            const SizedBox(width: 10),
                            const Text('Tout sélectionner'),
                          ],
                        ),
                        onTap: () {
                          controller.canSelectVideo.value = true;
                          controller.selectedVideoParts.addAll(widget.parts);
                          controller.update();
                        },
                      ),
                      if (!widget.isSaved)
                        PopupMenuItem(
                          child: Row(
                            children: [
                              const Icon(Icons.save),
                              const SizedBox(width: 10),
                              const Text('Sauvegarder'),
                            ],
                          ),
                          onTap: () => controller.saveSegments(),
                        ),
                    ],
              ),
              // if (controller.selectedVideoParts.isNotEmpty)
              //   IconButton(
              //     icon: const Icon(Icons.share),
              //     onPressed: () {
              //       VideoService.shareVideos(controller.selectedVideoParts);
              //     },
              //   ),
            ],
          ),
          body: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: widget.parts.length,
            itemBuilder: (context, index) {
              final file = widget.parts[index];
              final playerController = controller.videoControllers[file];

              return GestureDetector(
                onLongPress: () {
                  controller.canSelectVideo.value = true;
                  controller.update();
                },
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        if (controller.canSelectVideo.value) {
                          controller.selectVideoPart(file);
                        } else {
                          Get.to(() => VideoPreviewView(videoFile: file));
                        }
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child:
                                playerController != null &&
                                        playerController.value.isInitialized
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AspectRatio(
                                            aspectRatio:
                                                playerController
                                                    .value
                                                    .aspectRatio,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: VideoPlayer(
                                                playerController,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                          ),
                        ],
                      ),
                    ),
                    if (controller.canSelectVideo.value)
                      Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          controller.selectedVideoParts.contains(file)
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color:
                              controller.selectedVideoParts.contains(file)
                                  ? AppColors.primary
                                  : AppColors.grey,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          floatingActionButton: Visibility(
            visible: !controller.canSelectVideo.value,
            replacement: FloatingActionButton.extended(
              onPressed: () {
                if (controller.selectedVideoParts.isEmpty) {
                  showSnackBar(
                    'Aucune vidéo sélectionnée. Veuillez sélectionner au moins une vidéo',
                    isError: true,
                  );
                  return;
                }
                VideoService.shareVideos(controller.selectedVideoParts);
              },
              label: const Text('Partager'),
              icon: const Icon(Icons.share),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
            ),
            child:
                !widget.isSaved
                    ? FloatingActionButton.extended(
                      onPressed: controller.saveSegments,
                      label: const Text('Enregistrer'),
                      icon: const Icon(Icons.save),
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                    )
                    : SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
