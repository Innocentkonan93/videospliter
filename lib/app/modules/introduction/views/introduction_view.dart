import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/utils/constants.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetWidget<IntroductionController> {
  const IntroductionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final size = MediaQuery.sizeOf(context);
    final height = size.height;

    return GetBuilder<IntroductionController>(
      builder: (controller) {
        final isLastPage =
            controller.currentPage.value == introductions.length - 1;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white,
                  AppColors.secondary.withValues(alpha: 0.08),
                  AppColors.secondary.withValues(alpha: 0.2),
                ],
                // stops: [],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  children: [
                    // Zone centrale avec PageView
                    Expanded(
                      child: PageView.builder(
                        itemCount: introductions.length,
                        controller: controller.pageController,
                        onPageChanged: (index) {
                          controller.currentPage.value = index;
                          controller.update();
                        },
                        itemBuilder: (context, index) {
                          final introduction = introductions[index];
                          final imagePath = introduction['image_path'] ?? '';
                          final title = introduction['title'] ?? '';
                          final description = introduction['description'] ?? '';

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Spacer(),

                              // Carte d'illustration en haut
                              if (imagePath.isNotEmpty)
                                Center(
                                  child: Container(
                                        height: height * 0.40,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          // color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            28,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.04,
                                              ),
                                              blurRadius: 24,
                                              offset: const Offset(0, 12),
                                            ),
                                          ],
                                        ),
                                        child: Image.asset(
                                          "assets/images/intro/$imagePath",
                                          fit: BoxFit.contain,
                                        ),
                                      )
                                      .animate()
                                      .fadeIn(duration: 600.ms, delay: 100.ms)
                                      .slideY(
                                        begin: 0.05,
                                        end: 0,
                                        curve: Curves.easeOutQuad,
                                      ),
                                ),

                              const Spacer(flex: 2),

                              // Titre en bas de l'illustration
                              Text(
                                    title,
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w800,
                                          height: 1.2,
                                        ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 400.ms, delay: 200.ms)
                                  .slideX(begin: -0.05, end: 0),
                              const SizedBox(height: 12),

                              // Description
                              Text(
                                description,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: AppColors.black.withValues(alpha: 0.6),
                                  height: 1.4,
                                ),
                              ).animate().fadeIn(
                                duration: 400.ms,
                                delay: 300.ms,
                              ),

                              const Spacer(),
                            ],
                          );
                        },
                      ),
                    ),

                    // Zone inférieure avec les boutons d'actions
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
                      child:
                          isLastPage
                              ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.requestNotifications();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(
                                        double.infinity,
                                        56,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      "allow".tr,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () {
                                      controller.completedIntro();
                                    },
                                    child: Text(
                                      "later".tr,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: AppColors.black.withValues(
                                              alpha: 0.5,
                                            ),
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ).animate().fadeIn(duration: 300.ms)
                              : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      controller.completedIntro();
                                    },
                                    child: Text(
                                      "skip".tr,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            color: AppColors.black.withValues(
                                              alpha: 0.4,
                                            ),
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 72,
                                        height: 72,
                                        child: TweenAnimationBuilder<double>(
                                          tween: Tween<double>(
                                            end:
                                                (controller.currentPage.value +
                                                    1) /
                                                introductions.length,
                                          ),
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          curve: Curves.easeInOut,
                                          builder: (context, value, child) {
                                            return CircularProgressIndicator(
                                              value: value,
                                              strokeWidth: 3,
                                              backgroundColor: AppColors
                                                  .secondary
                                                  .withValues(alpha: 0.15),
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                    Color
                                                  >(AppColors.primary),
                                            );
                                          },
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          controller.pageController.nextPage(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                        child: Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.primary
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: const HugeIcon(
                                            icon:
                                                HugeIcons
                                                    .strokeRoundedArrowRight01,
                                            color: Colors.white,
                                            size: 24,
                                          ),
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
        );
      },
    );
  }
}
