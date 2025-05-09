import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/views/my_cutouts_view.dart';
import 'package:video_spliter/app/modules/home/views/progressing_view.dart';
import 'package:video_spliter/app/widgets/custom_video_player_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.secondary, AppColors.primary],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      const Text(
                        'VideoSpliter',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Transformez vos vidéos en moments magiques !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Découpez, partagez et profitez de vos vidéos en quelques clics',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const Spacer(),

                      // Affichage conditionnel selon la vidéo choisie
                      controller.selectedVideo.value == null
                          ? Center(
                            child: ElevatedButton(
                              onPressed: controller.pickVideo,
                              child: const Text('Choisir une vidéo'),
                            ),
                          )
                          : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: AspectRatio(
                                  aspectRatio: 4 / 3,
                                  child: CustomVideoPlayerWidget(
                                    videoFile: controller.selectedVideo.value!,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Fichier : ${controller.selectedVideo.value!.path.split('/').last}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.cut),
                                label: const Text('Découper'),
                                onPressed: () {
                                  if (!GetPlatform.isMobile) {
                                    Get.snackbar(
                                      'Erreur',
                                      'Disponible uniquement sur Android/iOS',
                                    );
                                    return;
                                  }
                                  Get.to(() => const ProcessingView());
                                },
                              ),
                            ],
                          ),
                      const Spacer(),
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
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
