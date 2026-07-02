import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
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
                child: IconButton.filledTonal(
                  onPressed: () {
                    controller.clearAll();
                    controller.update();
                    Get.back();
                  },
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedCancel01,
                    color: AppColors.white,
                    size: 15,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.white.withValues(alpha: .1),

                    minimumSize: const Size(20, 20),
                    maximumSize: const Size(35, 35),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: _togglePlayPause,
                  icon: Visibility(
                    visible: _controller.value.isPlaying,
                    replacement: const HugeIcon(
                      icon: HugeIcons.strokeRoundedPlayCircle,
                      color: AppColors.white,
                      size: 45,
                    ),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedPauseCircle,
                      color: AppColors.white.withValues(alpha: .15),
                      size: 45,
                    ),
                  ),
                ),
              ),
              if (_controller.value.isPlaying)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    colors: const VideoProgressColors(
                      playedColor: AppColors.primary,
                      bufferedColor: Colors.white38,
                      backgroundColor: Colors.white12,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
