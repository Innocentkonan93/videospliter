import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/introduction/views/starting_view.dart';
import 'package:video_spliter/app/utils/constants.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetWidget<IntroductionController> {
  const IntroductionView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(IntroductionController());
    final theme = context.theme;
    return GetBuilder<IntroductionController>(
      init: IntroductionController(),
      builder: (controller) {
        if (controller.isLoading.value) {
          return StartingView();
        }
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.secondary,
                  AppColors.primary,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SizedBox.expand(
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Text(
                        //   "${controller.currentPage.value + 1}/${introductions.length}",
                        //   style: theme.textTheme.bodyMedium?.copyWith(
                        //     color: Colors.white,
                        //   ),
                        // ),
                        TextButton(
                          onPressed: () {
                            controller.completedIntro();
                          },
                          child: Text(
                            "Passer",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          ...List.generate(
                            introductions.length,
                            (index) => Expanded(
                              child: Container(
                                height: 4,
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color:
                                      controller.currentPage.value == index
                                          ? Colors.white
                                          : Colors.white.withValues(
                                            alpha: 0.25,
                                          ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        itemCount: introductions.length,
                        controller: controller.pageController,
                        onPageChanged: (index) {
                          controller.currentPage.value = index;
                          controller.update();
                          print(index);
                        },
                        itemBuilder: (context, index) {
                          final introduction = introductions[index];
                          final imagePath = introduction['image_path'];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),

                            child: Column(
                              children: [
                                Text(
                                  introduction['description'] ?? "",
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ).animate().fadeIn(),
                                SizedBox(height: 100),
                                Visibility(
                                  visible: imagePath.isNotEmpty,
                                  replacement: SizedBox.shrink(),
                                  child: Image.asset(
                                        "assets/images/intro/$imagePath",
                                      )
                                      .animate(delay: 200.ms)
                                      .slideY(
                                        begin: 1,
                                        end: 0,
                                        curve: Curves.fastOutSlowIn,
                                      )
                                      .fadeIn(duration: 1500.ms),
                                ),
                                SizedBox(height: 100),
                                if (controller.currentPage.value >= 4)
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.requestNotifications();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppColors.black,
                                      shape: RoundedSuperellipseBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                    ),
                                    child: Text(
                                      "Autoriser",
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                // Text(introductions[index]['description']),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton:
              controller.currentPage.value < introductions.length - 1
                  ? FloatingActionButton(
                    onPressed: () {
                      if (controller.currentPage.value <
                          introductions.length - 1) {
                        controller.pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );

                        controller.update();
                      }
                    },
                    shape: CircleBorder(),
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_right_alt_rounded,
                      color: AppColors.black,
                    ),
                  )
                  : null,
        );
      },
    );
  }
}
