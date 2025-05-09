import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_spliter/app/modules/home/views/result_view.dart';
import '../controllers/home_controller.dart';

class ProcessingView extends StatefulWidget {
  const ProcessingView({super.key});

  @override
  State<ProcessingView> createState() => _ProcessingViewState();
}

class _ProcessingViewState extends State<ProcessingView> {
  final controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _processVideo();
  }

  Future<void> _processVideo() async {
    await controller.splitVideo();
    await Future.delayed(const Duration(seconds: 1));
    Get.off(() => ResultView(parts: controller.videoParts));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("Découpage en cours...", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
