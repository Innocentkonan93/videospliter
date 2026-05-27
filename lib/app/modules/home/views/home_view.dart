import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/views/my_cutouts_view.dart';
import 'package:video_spliter/app/modules/home/views/process_view.dart';
import 'package:video_spliter/app/modules/settings/views/settings_view.dart';
import 'package:video_spliter/app/widgets/custom_video_player_view.dart';
import 'package:video_spliter/app/widgets/time_slicing_sheet.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // controller.clearAll();
    final theme = context.theme;
    final size = MediaQuery.sizeOf(context);
    final height = size.height;
    final width = size.width;
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            controller: controller.pageController,
            // padEnds: true,
            key: ValueKey("Cuting_page_view"),
            onPageChanged: (index) {
              controller.currentPage.value = index;
              controller.update();
            },
            children: [
              Container(
                // padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.secondary, AppColors.primary],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Opacity(
                      opacity: .5,
                      child: Image.asset(
                        "assets/images/bg.png",
                        fit: BoxFit.cover,
                        height: height,
                        width: width,
                      ),
                    ),
                    SizedBox.expand(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (controller.banner != null &&
                                controller.isBannerLoaded)
                              SafeArea(
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      controller.banner!.size.width.toDouble(),
                                  height:
                                      controller.banner!.size.height.toDouble(),
                                  child: AdWidget(
                                    key: ObjectKey(controller.banner),
                                    ad: controller.banner!,
                                  ),
                                ),
                              ),
                            const Spacer(flex: 4),

                            Text(
                              "cut_share_save".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                color: AppColors.white,
                              ),
                            ),
                            const Spacer(flex: 1),
                            // Affichage conditionnel selon la vidéo choisie
                            controller.isVideoLoading.value
                                ? Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 10,
                                    children: [
                                      SizedBox(
                                        width: 12,
                                        height: 12,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor: AlwaysStoppedAnimation(
                                            AppColors.white,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "import_video".tr,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(color: AppColors.white),
                                      ),
                                    ],
                                  ),
                                )
                                : controller.selectedVideo.value == null
                                ? Center(
                                  child: IconButton(
                                        onPressed: () {
                                          controller.pickVideo();
                                        },
                                        style: IconButton.styleFrom(
                                          backgroundColor: AppColors.white,
                                          foregroundColor: AppColors.primary,
                                          elevation: 10,
                                          minimumSize: Size(60, 60),
                                        ),
                                        tooltip: "Ajouter une vidéo",
                                        icon: const HugeIcon(
                                          icon: HugeIcons.strokeRoundedAdd01,
                                          color: AppColors.primary,
                                        ),
                                      )
                                      .animate(
                                        autoPlay: true,
                                        onPlay: (controller) {
                                          controller.repeat();
                                        },
                                      )
                                      .scale(
                                        duration: const Duration(
                                          milliseconds: 1000,
                                        ),
                                        curve: Curves.easeInOut,
                                        begin: const Offset(1.0, 1.0),
                                        end: const Offset(1.1, 1.1),
                                      )
                                      .then()
                                      .scale(
                                        duration: const Duration(
                                          milliseconds: 700,
                                        ),
                                        curve: Curves.easeInOut,
                                        begin: const Offset(1.1, 1.1),
                                        end: const Offset(1.0, 1.0),
                                      ),
                                )
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      constraints: BoxConstraints(
                                        maxWidth: 400,
                                      ),
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 0,
                                      ),
                                      child: CustomVideoPlayerWidget(
                                        videoFile:
                                            controller.selectedVideo.value!,
                                      ),
                                    ),

                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      icon: const HugeIcon(
                                        icon: HugeIcons.strokeRoundedScissor,
                                        color: AppColors.primary,
                                        size: 24,
                                      ),
                                      label: Text(
                                        'cut_video'.tr,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      onPressed: () async {
                                        final result =
                                            await showModalBottomSheet(
                                              context: context,
                                              showDragHandle: true,
                                              isScrollControlled: true,
                                              enableDrag: false,
                                              backgroundColor: AppColors.white,
                                              builder: (context) {
                                                return const TimeSlicingSheet();
                                              },
                                            );
                                        if (result != null &&
                                            result is double) {
                                          controller.sliceDuration.value =
                                              result;
                                          Get.to(() => const ProcessView());
                                        }
                                      },
                                    ),
                                  ],
                                ),
                            const Spacer(flex: 2),
                            SafeArea(
                              child: GestureDetector(
                                onTap: () {
                                  controller.pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const HugeIcon(
                                          icon:
                                              HugeIcons
                                                  .strokeRoundedArrowDownDouble,
                                          color: AppColors.white,
                                        )
                                        .animate(
                                          autoPlay: true,
                                          onPlay: (controller) {
                                            controller.repeat();
                                          },
                                        )
                                        .slideY(
                                          duration: const Duration(
                                            milliseconds: 1000,
                                          ),
                                          curve: Curves.easeInOut,
                                          begin: -0.5,
                                          end: 0.5,
                                        )
                                        .then()
                                        .slideY(
                                          duration: const Duration(
                                            milliseconds: 1000,
                                          ),
                                          curve: Curves.easeInOut,
                                          begin: 0.5,
                                          end: -0.5,
                                        ),
                                    const SizedBox(height: 5),

                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        HugeIcon(
                                          icon: HugeIcons.strokeRoundedFolder01,
                                          color: AppColors.white,
                                          size: 24,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "my_cutouts".tr,
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                                // fontWeight: FontWeight.w800,
                                                color: AppColors.white,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // listes des découpages
              MyCutoutsView(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(
                () => const SettingsView(),
                transition: Transition.rightToLeft,
              );
            },
            // backgroundColor: Colors.transparent,
            elevation: 0,
            mini: true,
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedSettings02,
              color: AppColors.primary,
              size: 24,
            ),
          ),
        );
      },
    );
  }
}
