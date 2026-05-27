import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/widgets/segment_preview_card.dart';
import 'package:video_spliter/app/modules/home/views/all_videos_preview..dart';
import 'package:video_spliter/app/services/video_service.dart';
import 'package:video_spliter/app/utils/methods_utils.dart';
import 'package:video_spliter/app/utils/responsive.dart';
import 'package:video_spliter/app/services/feature_manager.dart';
import 'package:video_spliter/app/widgets/premium_banner.dart';
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: Visibility(
              visible: !controller.canSelectVideo.value,
              replacement: IconButton(
                onPressed: () {
                  controller.canSelectVideo.value = false;
                  controller.selectedVideoParts.clear();
                  controller.selectedFolder.value = "";
                  controller.update();
                },
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedCancel01,
                  color: AppColors.black,
                ),
              ),
              child: BackButton(
                color: AppColors.black,
                onPressed: () {
                  Get.back();
                  controller.clearAll();
                },
              ),
            ),
            title: Text(
              controller.canSelectVideo.value
                  ? '${controller.selectedVideoParts.length} ${controller.selectedVideoParts.length > 1 ? 'clips_selected'.tr : 'clip_selected'.tr}'
                  : 'cutting_results'.tr,
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  controller.canSelectVideo.value = true;
                  controller.selectAllVideoParts(widget.parts);
                  controller.update();
                },
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedCheckList,
                  color:
                      controller.selectedVideoParts.length !=
                              widget.parts.length
                          ? AppColors.grey
                          : AppColors.primary,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Obx(
                () =>
                    FeatureManager.shouldShowProContent
                        ? const PremiumBanner(placement: 'result_view')
                        : const SizedBox.shrink(),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: widget.parts.length,
                  itemBuilder: (context, index) {
                    final file = widget.parts[index];
                    final isSelected = controller.selectedVideoParts.contains(
                      file,
                    );

                    return GestureDetector(
                      onLongPress: () {
                        controller.canSelectVideo.value = true;
                        controller.selectVideoPart(file);
                        controller.update();
                      },
                      onTap: () {
                        if (controller.canSelectVideo.value) {
                          controller.selectVideoPart(file);
                        } else {
                          Get.to(
                            () => AllVideosPreview(
                              parts: widget.parts,
                              currentIndex: index,
                            ),
                          );
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border:
                              isSelected
                                  ? Border.all(
                                    color: AppColors.primary,
                                    width: 3,
                                  )
                                  : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: SegmentPreviewCard(
                                  file: file,
                                  label: "${'segment'.tr} ${index + 1}",
                                  showPlayIcon: !controller.canSelectVideo.value,
                                  usePlayer: true,
                                ),
                              ),
                              // Selection Indicator
                              if (controller.canSelectVideo.value)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? AppColors.primary
                                              : Colors.white.withValues(
                                                alpha: 0.5,
                                              ),
                                      shape: BoxShape.circle,
                                      border:
                                          isSelected
                                              ? null
                                              : Border.all(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child:
                                        isSelected
                                            ? const HugeIcon(
                                              icon:
                                                  HugeIcons.strokeRoundedTick01,
                                              color: Colors.white,
                                              size: 16,
                                            )
                                            : const SizedBox(
                                              width: 16,
                                              height: 16,
                                            ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 20,
            color: AppColors.white,
            surfaceTintColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (controller.selectedVideoParts.isEmpty) {
                        showSnackBar('no_video_selected'.tr, isError: true);
                        return;
                      }
                      VideoService.shareVideos(controller.selectedVideoParts);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          controller.selectedVideoParts.isEmpty
                              ? Colors.grey[200]
                              : AppColors.primary,
                      foregroundColor:
                          controller.selectedVideoParts.isEmpty
                              ? Colors.grey
                              : AppColors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedShare01,
                      color: Colors.white,
                    ),
                    label: Text('share'.tr),
                  ),
                ),
                if (!widget.isSaved) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await controller.showFolderDialog();
                        if (result != null) {
                          controller.saveSegments(result as String);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const HugeIcon(
                        icon: HugeIcons.strokeRoundedFloppyDisk,
                        color: Colors.white,
                      ),
                      label: Text('save'.tr),
                    ),
                  ),
                ],
                if (widget.isSaved) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        VideoService.saveVideos(controller.selectedVideoParts);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            controller.selectedVideoParts.isEmpty
                                ? Colors.grey[200]
                                : AppColors.orange,
                        foregroundColor:
                            controller.selectedVideoParts.isEmpty
                                ? Colors.grey
                                : AppColors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const HugeIcon(
                        icon: HugeIcons.strokeRoundedDownload01,
                        color: Colors.white,
                      ),
                      label: Text('export'.tr),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
