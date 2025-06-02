import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/controllers/home_controller.dart';

class CustomVideoPlayerWidget extends StatefulWidget {
  final File videoFile;

  const CustomVideoPlayerWidget({super.key, required this.videoFile});

  @override
  State<CustomVideoPlayerWidget> createState() =>
      _CustomVideoPlayerWidgetState();
}

class _CustomVideoPlayerWidgetState extends State<CustomVideoPlayerWidget> {
  late VideoPlayerController _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(
            height: Get.height * .3,
            width: double.infinity,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        return Container(
          height: Get.height * .3,
          width: double.infinity,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown, // <-- ajuste l’échelle sans déformer
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: AspectRatio(
                    aspectRatio: 1920 / 1080,
                    child: GestureDetector(
                      onTap: _togglePlayPause,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    controller.clearAll();
                    controller.update();
                  },
                  icon: const Icon(Icons.cancel, color: AppColors.white),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: _togglePlayPause,
                  icon: Visibility(
                    visible: _controller.value.isPlaying,
                    replacement: const Icon(
                      Icons.play_circle_filled,
                      color: AppColors.white,
                      size: 45,
                    ),
                    child: Icon(
                      Icons.pause_circle_filled,
                      color: AppColors.white.withValues(alpha: .15),
                      size: 45,
                    ),
                  ),
                ),
              ),
              // Center(
              //   child: IconButton(
              //     icon: const Icon(Icons.pause_circle_filled),
              //     onPressed: _togglePlayPause,
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
