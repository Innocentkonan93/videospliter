import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/views/result_view.dart';
import '../controllers/home_controller.dart';

class ProcessingView extends StatefulWidget {
  const ProcessingView({super.key});

  @override
  State<ProcessingView> createState() => _ProcessingViewState();
}

class _ProcessingViewState extends State<ProcessingView> {
  final controller = Get.find<HomeController>();
  final List<String> messages = [
    "🪄 Prépare-toi, la magie commence...",
    "🎬 On découpe ta vidéo au pixel près !",
    "⏳ Ça bosse dur derrière le rideau...",
    "🍿 C’est le moment d’aller chercher du popcorn...",
    "🚀 Transformation en cours, attache ta ceinture !",
    "🧠 On réfléchit fort... très fort !",
    "🛠️ Ça prend un peu de temps, mais ça vaut le coup !",
    "🔥 Encore quelques secondes et c’est prêt !",
    "✅ Fini dans 3... 2... presque 1...",
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
      await Future.delayed(const Duration(seconds: 10));
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
    await controller.splitVideo();
    await Future.delayed(const Duration(seconds: 1));
    Get.off(() => ResultView(parts: controller.videoParts));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  messages[_messageIndex.value],
                  key: ValueKey(messages[_messageIndex.value]),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
