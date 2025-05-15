import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/services/video_service.dart';

class VideoPreviewView extends StatefulWidget {
  final File videoFile;
  const VideoPreviewView({super.key, required this.videoFile});

  @override
  State<VideoPreviewView> createState() => _VideoPreviewViewState();
}

class _VideoPreviewViewState extends State<VideoPreviewView> {
  late VideoPlayerController _controller;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() => isReady = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Aperçu de la vidéo")),
      body: Center(
        child:
            isReady
                ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      VideoPlayer(_controller),
                      if (!_controller.value.isPlaying)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.play_arrow,
                              size: 60,
                              color: Colors.white,
                            ),
                            onPressed: _togglePlayback,
                          ),
                        ),
                    ],
                  ),
                )
                : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          VideoService.shareVideos([widget.videoFile]);
        },
        label: const Text('Partager'),
        icon: const Icon(Icons.share),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
    );
  }
}
