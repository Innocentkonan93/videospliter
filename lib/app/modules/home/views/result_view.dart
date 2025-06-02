import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/views/all_videos_preview..dart';
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
    controller.canSelectVideo.value = true;
    controller.selectedVideoParts.addAll(widget.parts);
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
      builder: (controller) {
        return Scaffold(
          // backgroundColor: AppColors.white,d
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
                      if (controller.selectedVideoParts.isEmpty)
                        PopupMenuItem(
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_rounded, size: 20),
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
                      if (controller.selectedVideoParts.isNotEmpty)
                        PopupMenuItem(
                          child: Row(
                            children: [
                              const Icon(Icons.circle_outlined, size: 20),
                              const SizedBox(width: 10),
                              const Text('Désélectionner'),
                            ],
                          ),
                          onTap: () {
                            controller.canSelectVideo.value = true;
                            controller.selectedVideoParts.clear();
                            controller.update();
                          },
                        ),
                      // if (!widget.isSaved)
                      //   PopupMenuItem(
                      //     child: Row(
                      //       children: [
                      //         const Icon(Icons.save, size: 20),
                      //         const SizedBox(width: 10),
                      //         const Text('Sauvegarder'),
                      //       ],
                      //     ),
                      //     onTap: () => controller.saveSegments(),
                      //   ),
                    ],
              ),
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
                          // Get.to(() => VideoPreviewView(videoFile: file));
                          Get.to(() => AllVideosPreview(parts: widget.parts));
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
                      GestureDetector(
                        onTap: () {
                          controller.selectVideoPart(file);
                        },
                        child: Align(
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
                      ),
                  ],
                ),
              );
            },
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
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
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  ),
                  icon: const Icon(Icons.share),
                  label: const Text('Partager'),
                ),
                if (!widget.isSaved)
                  TextButton.icon(
                    onPressed: () {
                      controller.saveSegments();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                    ),
                    icon: const Icon(Icons.save),
                    label: const Text('Enregistrer'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
