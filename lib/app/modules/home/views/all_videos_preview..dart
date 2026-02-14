import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    super.initState();
    currentPage = widget.currentIndex;
    controller = PageController(initialPage: widget.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Content (Video List)
          Dismissible(
            key: const Key('all_videos_preview_dismiss'),
            direction: DismissDirection.vertical,
            onDismissed: (_) => Get.back(),
            child: PageView.builder(
              controller: controller,
              itemCount: widget.parts.length,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return VideoPreviewView(
                  videoFile: widget.parts[index],
                  showAppBar: false,
                  showTopInfo: false,
                );
              },
            ),
          ),

          // 2. Top Navigation Bar (Story Style)
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
                        children: List.generate(widget.parts.length, (index) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: 3,
                                decoration: BoxDecoration(
                                  color:
                                      index < currentPage
                                          ? Colors.white
                                          : index == currentPage
                                          ? Theme.of(context).primaryColor
                                          : Colors.white.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(1.5),
                                  boxShadow: [
                                    if (index == currentPage)
                                      BoxShadow(
                                        color: Theme.of(
                                          context,
                                        ).primaryColor.withValues(alpha: 0.5),
                                        blurRadius: 4,
                                      ),
                                  ],
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
                              child: const Icon(
                                Icons.close,
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
                                  color: Colors.white.withValues(alpha: 0.7),
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
          ),

          // 3. Side Actions (TikTok Style) - Avoids Overlap with Bottom Controls
          Positioned(
            right: 16,
            bottom: 120, // Positioned above the seek bar area
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSideActionButton(
                  icon: Icons.share_rounded,
                  label: 'share'.tr,
                  isPrimary: true,
                  onTap: () {
                    VideoService.shareVideos([widget.parts[currentPage]]);
                  },
                ),
                // const SizedBox(height: 16),
                // _buildSideActionButton(
                //   icon: Icons.save_alt_rounded,
                //   label: 'save'.tr,
                //   isPrimary: true,
                //   onTap: () {
                //     VideoService.saveVideos([widget.parts[currentPage]]);
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideActionButton({
    required IconData icon,
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
              color:
                  isPrimary
                      ? Theme.of(context).primaryColor
                      : Colors.black.withValues(alpha: 0.4),
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
            child: Icon(icon, color: Colors.white, size: 28),
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
