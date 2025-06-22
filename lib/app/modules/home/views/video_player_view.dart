import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  String? fileSize;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {
          isReady = true;
          _calculateFileSize();
        });
      });

    _controller.addListener(() {
      setState(() {}); // Update progress bar
    });
  }

  void _calculateFileSize() {
    final bytes = widget.videoFile.lengthSync();
    if (bytes < 1024) {
      fileSize = '$bytes B';
    } else if (bytes < 1024 * 1024) {
      fileSize = '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      fileSize = '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
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

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close),
          color: AppColors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _toggleControls,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Video Player
                    isReady
                        ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                        : const Center(child: CircularProgressIndicator()),

                    // Controls Overlay
                    if (_showControls && isReady)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Top info bar
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Durée: ${_formatDuration(_controller.value.duration)}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Taille: $fileSize',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),

                            // Bottom controls
                            Column(
                              children: [
                                // Progress bar
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: VideoProgressIndicator(
                                    _controller,
                                    allowScrubbing: true,
                                    colors: VideoProgressColors(
                                      playedColor: AppColors.primary,
                                      bufferedColor: Colors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                      backgroundColor: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  ),
                                ),

                                // Play/Pause and time
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatDuration(
                                          _controller.value.position,
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          _controller.value.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                        onPressed: _togglePlayback,
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.share,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          VideoService.shareVideos([
                                            widget.videoFile,
                                          ]);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
  }
}
