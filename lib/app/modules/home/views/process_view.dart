import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/widgets/segment_preview_card.dart';
import 'package:video_spliter/app/modules/home/views/result_view.dart';
import 'package:video_spliter/app/services/analytics_service.dart';
import 'package:video_spliter/app/services/feedback_service.dart';
import 'package:video_spliter/app/services/local_notifications_service.dart';
import 'package:video_spliter/app/utils/methods_utils.dart';
import 'package:video_spliter/app/services/feature_manager.dart';
import 'package:video_spliter/app/services/revenuecat_service.dart';
import '../controllers/home_controller.dart';

class ProcessView extends StatefulWidget {
  const ProcessView({super.key});

  @override
  State<ProcessView> createState() => _ProcessViewState();
}

class _ProcessViewState extends State<ProcessView> {
  final controller = Get.find<HomeController>();
  final List<String> messages = [
    "cutting_in_progress".tr,
    "no_manual_cutting".tr,
    "share_easily".tr,
    "transform_video".tr,
    "ideal_for_stories".tr,
    "videos_become_simple".tr,
    "create_automatically".tr,
    "use_cutit_like_pro".tr,
  ];
  final RxInt _messageIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    _startMessageRotation();
    _processVideo();
  }

  void _startMessageRotation() {
    String lastMessage = messages[_messageIndex.value];
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return false;

      int nextIndex = (_messageIndex.value + 1) % messages.length;
      String nextMessage = messages[nextIndex];
      if (nextMessage != lastMessage) {
        _messageIndex.value = nextIndex;
        lastMessage = nextMessage;
      }

      return true;
    });
  }

  Future<void> _processVideo() async {
    final startTime = DateTime.now();
    try {
      final isPro = FeatureManager.isProUser;
      final parts =
          isPro
              ? await controller.splitVideoParallelIsolate()
              : await controller.splitVideoIsolate();
      AnalyticsService.videoProcessingStarted(
        videoDurationSec: controller.selectedVideo.value?.lengthSync() ?? 0,
        segmentCount: parts?.length ?? 0,
      );
      if (parts != null && parts.isNotEmpty) {
        await Future.delayed(const Duration(seconds: 1));
        vibrate();
        Get.off(() => ResultView(parts: controller.videoParts));

        // Funnel post-succès : Inviter à passer Pro si l'utilisateur est gratuit
        if (FeatureManager.shouldShowProContent) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            showGeneralDialog(
              context: Get.context!,
              barrierDismissible: true,
              barrierLabel: '',
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (context, animation, secondaryAnimation) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  title: Text("cut_done_title".tr, textAlign: TextAlign.center),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedChampion,
                        color: Colors.amber,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text("pro_success_cta".tr, textAlign: TextAlign.center),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text("later".tr),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.find<RevenueCatService>().presentPaywall(
                          placement: 'post_processing',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                      ),
                      child: Text("premium_title".tr),
                    ),
                  ],
                );
              },
              transitionBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return Transform.scale(
                  scale: Curves.easeOutBack.transform(animation.value),
                  child: Opacity(opacity: animation.value, child: child),
                );
              },
            );
          });
        }

        controller.onSplitDone();
        if (controller.isAppInBackground.value) {
          LocalNotificationService().showNotification(
            id: 1,
            title: "cut_done_title".tr,
            body: "cut_done_body".tr,
          );
        }
        showSnackBar("cut_done_notification".tr);
        controller.videoParts.sort((a, b) => a.path.compareTo(b.path));
        AnalyticsService.videoProcessingCompleted(
          processingTimeSec: DateTime.now().difference(startTime).inSeconds,
          segmentCount: parts.length,
          videoDurationSec: controller.selectedVideo.value?.lengthSync() ?? 0,
        );
      } else {
        Get.back();
        showSnackBar(
          "Aucun segment généré (vidéo trop courte ou erreur)",
          isError: true,
        );
      }
    } catch (e) {
      print(e);
      final isPro = FeatureManager.isProUser;
      FeedbackService().send(
        message: isPro ? 'Découpage parallèle échoué' : 'Découpage échoué',
        step: isPro ? 'cutting_parallel' : 'cutting',
        type: FeedbackType.automatic,
        error: {
          'code': isPro ? 'FFMPEG_ERROR_PARALLEL' : 'FFMPEG_ERROR',
          'raw': e.toString(),
          'stack_trace': StackTrace.current.toString(),
        },
        videoContext: {
          'path': controller.selectedVideo.value?.path,
          'size_bytes':
              controller.selectedVideo.value?.existsSync() == true
                  ? controller.selectedVideo.value?.lengthSync()
                  : 0,
          'slice_duration': controller.sliceDuration.value,
        },
      );
      Get.back();
      showSnackBar("error_cutting".tr, isError: true);
    }
  }

  Widget _buildSegmentCard(int index, double progress, File? file) {
    final isCompleted = file != null;
    final isActive = !isCompleted && progress > 0.0;

    Widget cardContent;

    if (isCompleted) {
      cardContent = SegmentPreviewCard(
        file: file,
        label: "${'segment'.tr} ${index + 1}",
        showCheckmark: true,
        usePlayer: false,
      );
    } else if (isActive) {
      cardContent = Stack(
        children: [
          Positioned.fill(child: Container(color: const Color(0xFFF5F5F7))),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  color: AppColors.primary.withValues(alpha: 0.12),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${(progress * 100).toInt()}%",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "segment".tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            child: Text(
              "${'segment'.tr} ${index + 1}",
              style: TextStyle(
                color: AppColors.primary.withValues(alpha: 0.6),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      );
    } else {
      cardContent = Stack(
        children: [
          Positioned.fill(child: Container(color: const Color(0xFFF5F5F7))),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedScissor,
                  color: AppColors.grey.withValues(alpha: 0.4),
                  size: 28,
                ),
                const SizedBox(height: 4),
                Text(
                  "please_wait".tr,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.grey.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            child: Text(
              "${'segment'.tr} ${index + 1}",
              style: TextStyle(
                color: AppColors.grey.withValues(alpha: 0.6),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color:
              isActive
                  ? AppColors.primary
                  : isCompleted
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : Colors.transparent,
          width: isActive ? 2.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: cardContent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: GetBuilder<HomeController>(
          init: controller,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "cutting_title".tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Obx(
                      () => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (child, animation) => FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                        child: Text(
                          messages[_messageIndex.value],
                          key: ValueKey(messages[_messageIndex.value]),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.black.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (controller.segmentProgresses.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator.adaptive(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "please_wait".tr,
                              style: const TextStyle(
                                color: AppColors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.85,
                            ),
                        itemCount: controller.segmentProgresses.length,
                        itemBuilder: (context, index) {
                          final progress = controller.segmentProgresses[index];
                          final file =
                              index < controller.segmentFiles.length
                                  ? controller.segmentFiles[index]
                                  : null;
                          return _buildSegmentCard(index, progress, file);
                        },
                      ),
                    ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Progression globale",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black.withValues(alpha: 0.7),
                              ),
                            ),
                            Text(
                              "${(controller.progress.value * 100).toStringAsFixed(1)} %",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: controller.progress.value,
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.1,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (controller.progress.value < 1.0) ...[
                    if (FeatureManager.isProUser)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.orange,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedFlash,
                              color: AppColors.orange,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "turbo_mode_active".tr,
                              style: const TextStyle(
                                color: AppColors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () {
                          Get.find<RevenueCatService>().presentPaywall(
                            placement: 'processing_turbo_ad',
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const HugeIcon(
                                    icon: HugeIcons.strokeRoundedFlash,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "upgrade_turbo_title".tr,
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "upgrade_turbo_desc".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],

                  if (controller.progress.value >= 1.0)
                    const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
