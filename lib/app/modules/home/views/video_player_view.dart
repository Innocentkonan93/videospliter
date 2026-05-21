import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:video_player/video_player.dart';
import 'package:video_spliter/app/configs/app_colors.dart';

class VideoPreviewView extends StatefulWidget {
  final File videoFile;
  final bool isPlaying;
  final ValueChanged<double>? onProgress;

  const VideoPreviewView({
    super.key,
    required this.videoFile,
    this.isPlaying = false,
    this.onProgress,
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
        if (widget.isPlaying) {
          _controller.play();
        }
      });

    _controller.addListener(() {
      if (mounted) {
        setState(() {}); // Update progress bar
        if (widget.onProgress != null && _controller.value.isInitialized) {
          final duration = _controller.value.duration;
          final position = _controller.value.position;
          if (duration.inMilliseconds > 0) {
            final progress = position.inMilliseconds / duration.inMilliseconds;
            widget.onProgress!(progress.clamp(0.0, 1.0));
          }
        }
      }
    });
  }

  @override
  void didUpdateWidget(VideoPreviewView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (isReady) {
        if (widget.isPlaying) {
          _controller.play();
        } else {
          _controller.pause();
        }
      }
    }
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

    return SafeArea(
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Top info bar (Only if AppBar is hidden, otherwise it might be redundant, but let's keep it for file size info)
                          // Actually, if we use this in a list, we might want to hide the file size if it's too cluttered.
                          // For now, keep it.
                          // Top info bar
                          // if (widget.showTopInfo)

                          // Bottom controls (minimalist)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 24.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(_controller.value.position),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton.filledTonal(
                                  icon: HugeIcon(
                                    icon:
                                        _controller.value.isPlaying
                                            ? HugeIcons.strokeRoundedPause
                                            : HugeIcons.strokeRoundedPlay,
                                    size: 40,
                                    color: AppColors.primary,
                                  ),
                                  onPressed: _togglePlayback,
                                ),
                                Text(
                                  '$fileSize',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
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
  }
}
