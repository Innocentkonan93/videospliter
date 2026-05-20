import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/views/result_view.dart';
import 'package:video_spliter/app/services/analytics_service.dart';
import 'package:video_spliter/app/services/feedback_service.dart';
import 'package:video_spliter/app/services/local_notifications_service.dart';
import 'package:video_spliter/app/utils/methods_utils.dart';
import 'package:video_spliter/app/services/feature_manager.dart';
import 'package:video_spliter/app/services/revenuecat_service.dart';
import '../controllers/home_controller.dart';

class ProcessingView extends StatefulWidget {
  const ProcessingView({super.key});

  @override
  State<ProcessingView> createState() => _ProcessingViewState();
}

class _ProcessingViewState extends State<ProcessingView> {
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
    // final parts = await controller.splitVideo();
    final startTime = DateTime.now();
    try {
      final parts = await controller.splitVideoIsolate();
      AnalyticsService.videoProcessingStarted(
        videoDurationSec: controller.selectedVideo.value?.lengthSync() ?? 0,
        segmentCount: parts?.length ?? 0,
      );
      if (parts != null && parts.isNotEmpty) {
        await controller.initVideoControllers(parts);
        await Future.delayed(const Duration(seconds: 1));
        vibrate();
        Get.off(() => ResultView(parts: controller.videoParts));

        // Funnel post-succès : Inviter à passer Pro si l'utilisateur est gratuit
        if (FeatureManager.shouldShowProContent) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            Get.dialog(
              AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text("cut_done_title".tr),
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
              ),
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
      FeedbackService().send(
        message: 'Découpage échoué',
        step: 'cutting',
        type: FeedbackType.automatic,
        error: {
          'code': 'FFMPEG_ERROR',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
            opacity: .2,
          ),
        ),
        child: GetBuilder<HomeController>(
          init: controller,
          builder: (context) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        // color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CircularPercentIndicator(
                      radius: 100.0,
                      lineWidth: 10.0,
                      percent: controller.progress.value,
                      animateFromLastPercent: true,
                      animation: true,
                      circularStrokeCap: CircularStrokeCap.round,
                      center:
                          controller.progress.value == 1.0
                              ? const HugeIcon(
                                icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                                color: AppColors.green,
                                size: 80,
                              )
                              : Text(
                                "${(controller.progress.value * 100).toStringAsFixed(1)} %",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      progressColor:
                          controller.progress.value == 1.0
                              ? AppColors.green
                              : AppColors.primary,
                    ),
                    SizedBox(height: 30),
                    if (controller.progress.value == 1)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator.adaptive(),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
