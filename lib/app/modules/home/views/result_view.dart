import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/views/video_player_view.dart';
import 'package:video_spliter/app/services/video_service.dart';
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
            leading: BackButton(
              onPressed: () {
                Get.back();
                controller.clearAll();
              },
            ),
            title: Text(
              controller.canSelectVideo.value
                  ? 'Sélectionner'
                  : 'Résultats du découpage',
            ),
            actions: [
              if (controller.selectedVideoParts.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    VideoService.shareVideos(controller.selectedVideoParts);
                  },
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
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          floatingActionButton:
              !widget.isSaved
                  ? FloatingActionButton.extended(
                    onPressed: controller.saveSegments,
                    label: const Text('Enregistrer'),
                    icon: const Icon(Icons.save),
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  )
                  : null,
        );
      },
    );
  }
}
