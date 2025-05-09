import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/views/video_player_view.dart';
import 'package:video_spliter/app/services/save_segments_service.dart';
import '../controllers/home_controller.dart';

class ResultView extends GetView<HomeController> {
  const ResultView({super.key, required this.parts});

  final List<File> parts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Résultats du découpage')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: parts.length,
        itemBuilder: (context, index) {
          final file = parts[index];
          return Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () => Get.to(() => VideoPreviewView(videoFile: file)),
              child: Column(
                children: [
                  Expanded(
                    child: FutureBuilder<VideoPlayerController>(
                      future: () async {
                        final controller = VideoPlayerController.file(file);
                        await controller.initialize();
                        return controller;
                      }(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: VideoPlayer(snapshot.data!),
                            ),
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.find<HomeController>().saveSegments();
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
