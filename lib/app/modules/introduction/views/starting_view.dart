import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:video_spliter/app/modules/introduction/controllers/introduction_controller.dart';

class StartingView extends GetWidget<IntroductionController> {
  const StartingView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(IntroductionController());
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Spacer(flex: 2),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/logo/logo.png"),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
                shape: BoxShape.circle,
              ),
            ),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(60),
            //   child: Image.asset(
            //     "assets/logo/logo.png",
            //     width: 120,
            //     height: 120,
            //   ),
            // ),
            Spacer(),
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 1.2),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
