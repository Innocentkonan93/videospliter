// ignore_for_file: file_names
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/views/video_player_view.dart';
import 'package:video_spliter/app/services/video_service.dart';

class AllVideosPreview extends StatefulWidget {
  const AllVideosPreview({
    super.key,
    required this.parts,
    required this.currentIndex,
  });
  final List<File> parts;
  final int currentIndex;

  @override
  State<AllVideosPreview> createState() => _AllVideosPreviewState();
}

class _AllVideosPreviewState extends State<AllVideosPreview> {
  late PageController controller;
  int currentPage = 0;
  final ValueNotifier<double> _currentVideoProgress = ValueNotifier<double>(
    0.0,
  );

  @override
  void initState() {
    super.initState();
    currentPage = widget.currentIndex;
    controller = PageController(initialPage: widget.currentIndex);
  }

  @override
  void dispose() {
    controller.dispose();
    _currentVideoProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Content (Video List)
          PageView.builder(
            controller: controller,
            itemCount: widget.parts.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
              _currentVideoProgress.value = 0.0;
            },
            itemBuilder: (context, index) {
              return VideoPreviewView(
                videoFile: widget.parts[index],
                isPlaying: index == currentPage,
                onProgress: (progress) {
                  if (index == currentPage) {
                    _currentVideoProgress.value = progress;
                  }
                },
              );
            },
          ),

          // 2. Touch Navigation Zones (Left / Right edge zones for story-style navigation)
          Positioned(
            left: 0,
            top: 100,
            bottom: 210,
            width: MediaQuery.of(context).size.width * 0.25,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (currentPage > 0) {
                  controller.animateToPage(
                    currentPage - 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
          Positioned(
            right: 0,
            top: 100,
            bottom: 210,
            width: MediaQuery.of(context).size.width * 0.25,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (currentPage < widget.parts.length - 1) {
                  controller.animateToPage(
                    currentPage + 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),

          // 3. Top Navigation Bar (Story Style)
          Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        // Progress Indicators
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          child: Row(
                            children: List.generate(widget.parts.length, (
                              index,
                            ) {
                              return Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    controller.animateToPage(
                                      index,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                      vertical: 2,
                                    ),
                                    child: Container(
                                      height: 3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        boxShadow: [
                                          if (index == currentPage)
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 4,
                                            ),
                                        ],
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      child:
                                          index < currentPage
                                              ? Container(
                                                color: AppColors.orange,
                                              )
                                              : index > currentPage
                                              ? Container(
                                                color: Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                              )
                                              : ValueListenableBuilder<double>(
                                                valueListenable:
                                                    _currentVideoProgress,
                                                builder: (
                                                  context,
                                                  progress,
                                                  child,
                                                ) {
                                                  return Stack(
                                                    children: [
                                                      Container(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.3,
                                                            ),
                                                      ),
                                                      FractionallySizedBox(
                                                        alignment:
                                                            Alignment
                                                                .centerLeft,
                                                        widthFactor: progress,
                                                        child: Container(
                                                          color:
                                                              AppColors.orange,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                        // Toolbar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              // Close Button
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const HugeIcon(
                                    icon: HugeIcons.strokeRoundedCancel01,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Title / Counter
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "preview".tr,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "${"segment".tr} ${currentPage + 1} / ${widget.parts.length}",
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontSize: 12,
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
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: -0.2, end: 0, duration: 400.ms),

          // 5. Side Actions (TikTok Style) - Avoids Overlap with Bottom Controls and Timeline
          Positioned(
                right: 16,
                bottom:
                    150, // Adjusted to sit right above the horizontal timeline (height 80, bottom 120 -> ends at 200)
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSideActionButton(
                      icon: HugeIcons.strokeRoundedShare01,
                      label: 'share'.tr,
                      isPrimary: false,
                      onTap: () {
                        VideoService.shareVideos([widget.parts[currentPage]]);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSideActionButton(
                      icon: HugeIcons.strokeRoundedDownload01,
                      label: 'export'.tr,
                      isPrimary: true,
                      onTap: () {
                        VideoService.saveVideos([widget.parts[currentPage]]);
                      },
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 450.ms)
              .slideX(begin: 0.2, end: 0, duration: 450.ms),
        ],
      ),
    );
  }

  Widget _buildSideActionButton({
    required List<List<dynamic>> icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isPrimary ? AppColors.orange : AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: HugeIcon(icon: icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              shadows: [Shadow(color: Colors.black, blurRadius: 4)],
            ),
          ),
        ],
      ),
    );
  }
}
