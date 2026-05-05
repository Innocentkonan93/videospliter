import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:video_player/video_player.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/services/video_service.dart';

class VideoPreviewView extends StatefulWidget {
  final File videoFile;
  final bool showAppBar;
  final bool showTopInfo;
  const VideoPreviewView({
    super.key,
    required this.videoFile,
    this.showAppBar = true,
    this.showTopInfo = true,
  });

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
    // If showAppBar is false, we probably want a transparent scaffold or just the body
    // But VideoPlayer needs a black background usually
    Widget content = SafeArea(
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
                            Colors.black.withValues(alpha: 0.7),
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Top info bar (Only if AppBar is hidden, otherwise it might be redundant, but let's keep it for file size info)
                          // Actually, if we use this in a list, we might want to hide the file size if it's too cluttered.
                          // For now, keep it.
                          // Top info bar
                          if (widget.showTopInfo)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${'duration'.tr}: ${_formatDuration(_controller.value.duration)}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    '${'size'.tr}: $fileSize',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            )
                          else
                            const SizedBox(height: 56),

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
                                    IconButton.filledTonal(
                                      icon: HugeIcon(
                                        icon: _controller.value.isPlaying
                                            ? HugeIcons.strokeRoundedPause
                                            : HugeIcons.strokeRoundedPlay,
                                        size: 40,
                                        color: AppColors.primary,
                                      ),
                                      onPressed: _togglePlayback,
                                    ),
                                    // Hide Share button here if we are in "Embedded" mode (showAppBar = false)
                                    // because parent likely handles sharing all.
                                    if (widget.showAppBar)
                                      IconButton.filled(
                                        icon: const HugeIcon(
                                          icon: HugeIcons.strokeRoundedShare01,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          VideoService.shareVideos([
                                            widget.videoFile,
                                          ]);
                                        },
                                      )
                                    else
                                      const SizedBox(
                                        width: 48,
                                      ), // Spacer to balance
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
    );

    if (!widget.showAppBar) {
      return Scaffold(backgroundColor: Colors.black, body: content);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const HugeIcon(icon: HugeIcons.strokeRoundedCancel01, color: AppColors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const HugeIcon(icon: HugeIcons.strokeRoundedMoreVertical, color: AppColors.white),
            onSelected: (String value) {
              // Handle menu item tap actions here
              // e.g. if (value == 'share') { ... }
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'share',
                    child: Row(
                      children: [
                        const HugeIcon(icon: HugeIcons.strokeRoundedShare01, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text('share'.tr),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'save',
                    child: Row(
                      children: [
                        const HugeIcon(icon: HugeIcons.strokeRoundedDownload01, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text('save'.tr),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'details',
                    child: Row(
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedInformationCircle,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text('details'.tr),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: content,
    );
  }
}
