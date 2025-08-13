import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/views/result_view.dart';
import 'package:video_spliter/app/utils/methods_utils.dart';
import '../controllers/home_controller.dart';

class ProcessingView extends StatefulWidget {
  const ProcessingView({super.key});

  @override
  State<ProcessingView> createState() => _ProcessingViewState();
}

class _ProcessingViewState extends State<ProcessingView> {
  final controller = Get.find<HomeController>();
  final List<String> messages = [
    "✂️ Découpage en cours… ne quitte pas l'application.",
    "🔪 Plus besoin de couper manuellement tes vidéos.",
    "📱 Partage plus facilement des longues vidéos en plusieurs parties.",
    "🎯 Transforme une vidéo en plusieurs statuts en un clic.",
    "📸 Idéal pour les stories, les statuts WhatsApp et tes shorts YouTube.",
    "🚀 Tes longues vidéos deviennent simples à publier.",
    "⏱️ Crée automatiquement des extraits de 10, 30, 60 secondes.",
    "🎬 Utilise cutit pour découper tes vidéos comme un pro",
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
    final parts = await controller.splitVideo();
    if (parts != null) {
      await controller.initVideoControllers(parts);
      await Future.delayed(const Duration(seconds: 1));
      vibrate();
      Get.off(() => ResultView(parts: controller.videoParts));
      controller.onSplitDone();
      showSnackBar(
        "Découpage terminée, vous pouvez le partager ou l'enregistrer",
      );
      controller.videoParts.sort((a, b) => a.path.compareTo(b.path));
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
                    // Lottie.asset(
                    //   'assets/animations/loading.json',
                    //   width: 200,
                    //   height: 200,
                    // ),
                    // TweenAnimationBuilder<double>(
                    //   tween: Tween<double>(
                    //     begin: 0,
                    //     end: controller.progress.value,
                    //   ),
                    //   duration: const Duration(milliseconds: 300),
                    //   builder: (context, value, _) {
                    //     return ClipRRect(
                    //       borderRadius: BorderRadius.circular(12),
                    //       child: LinearProgressIndicator(
                    //         value: value,
                    //         minHeight: 12,
                    //         backgroundColor: Colors.grey[300],
                    //         valueColor: AlwaysStoppedAnimation<Color>(
                    //           AppColors.primary,
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                    CircularPercentIndicator(
                      radius: 100.0,
                      lineWidth: 10.0,
                      percent: controller.progress.value,
                      animateFromLastPercent: true,
                      animation: true,
                      circularStrokeCap: CircularStrokeCap.round,
                      center:
                          controller.progress.value == 1.0
                              ? Icon(
                                Icons.check_rounded,
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
                      // AnimatedDigitWidget(
                      //   value: controller.progress.value * 100,
                      //   duration: const Duration(milliseconds: 1000),
                      //   textStyle: const TextStyle(
                      //     fontSize: 24,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      progressColor:
                          controller.progress.value == 1.0
                              ? AppColors.green
                              : AppColors.primary,
                    ),
                    // const SizedBox(height: 10),
                    // Text(
                    //   "${(controller.progress.value * 100).toStringAsFixed(1)} %",
                    // ),
                    SizedBox(height: 80),
                    Divider(color: Colors.grey[300], height: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          color: const Color.fromARGB(255, 198, 136, 20),
                          size: 60,
                        ),
                      ],
                    ),
                    Text(
                      "Ne vérrouillez pas l'écran et ne quittez pas l'application pendant le traitement",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
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
