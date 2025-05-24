import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/views/my_cutouts_view.dart';
import 'package:video_spliter/app/widgets/custom_video_player_view.dart';
import 'package:video_spliter/app/widgets/time_slicing_sheet.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.clearAll();
    final theme = context.theme;
    return Scaffold(
      body: GetBuilder<HomeController>(
        init: controller,
        builder: (controller) {
          return PageView(
            scrollDirection: Axis.vertical,
            controller: controller.pageController,
            children: [
              Container(
                // padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.secondary, AppColors.primary],
                  ),
                ),
                child: Stack(
                  children: [
                    Opacity(
                      opacity: .5,
                      child: Image.asset("assets/images/bg.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (controller.banner != null)
                            SafeArea(
                              child: FutureBuilder(
                                future: controller.banner?.load(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      controller.banner != null) {
                                    return Container(
                                      alignment: Alignment.center,
                                      width:
                                          controller.banner!.size.width
                                              .toDouble(),
                                      height:
                                          controller.banner!.size.height
                                              .toDouble(),
                                      child: AdWidget(ad: controller.banner!),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                          const Spacer(),

                          const Text(
                            'Découpez, partagez et enregistrez vos vidéos en quelques clics',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              color: AppColors.white,
                            ),
                          ),
                          const Spacer(),

                          // Affichage conditionnel selon la vidéo choisie
                          controller.selectedVideo.value == null
                              ? Center(
                                child: ElevatedButton.icon(
                                      onPressed: () {
                                        controller.pickVideo();
                                      },
                                      label: Text(
                                        'Charger une vidéo',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      icon: const Icon(
                                        Icons.video_call_rounded,
                                        color: AppColors.primary,
                                        size: 30,
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
                                        milliseconds: 500,
                                      ),
                                      curve: Curves.easeInOut,
                                      begin: const Offset(1.0, 1.0),
                                      end: const Offset(1.1, 1.1),
                                    )
                                    .then()
                                    .scale(
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      curve: Curves.easeInOut,
                                      begin: const Offset(1.1, 1.1),
                                      end: const Offset(1.0, 1.0),
                                    ),
                              )
                              : Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
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
                                    icon: const Icon(
                                      Icons.cut,
                                      color: AppColors.primary,
                                      size: 24,
                                    ),
                                    label: Text(
                                      'Découper',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    onPressed: () async {
                                      showModalBottomSheet(
                                        context: context,
                                        showDragHandle: true,
                                        enableDrag: false,
                                        builder: (context) {
                                          return const TimeSlicingSheet();
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                          const Spacer(flex: 2),
                          GestureDetector(
                            onTap: () {
                              controller.pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.swipe_vertical,
                                  color: AppColors.white,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    Container(),
                                  ],
                                ),
                                Text(
                                  "Mes découpages",
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    // fontWeight: FontWeight.w800,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // listes des découpages
              MyCutoutsView(),
            ],
          );
        },
      ),
    );
  }
}
