
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/views/progressing_view.dart';

import '../modules/home/controllers/home_controller.dart';

class TimeSlicingSheet extends GetWidget<HomeController> {
  const TimeSlicingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Choisir la durée de découpage',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => Text(
                        '${controller.sliceDuration.value.toInt()} secondes',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Slider(
                      min: 10,
                      max: 60,
                      divisions: 10,
                      value: controller.sliceDuration.value,
                      onChanged: (value) {
                        controller.sliceDuration.value = value;
                        controller.update();
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                      ),
                      onPressed: () {
                        if (!GetPlatform.isMobile) {
                          Get.snackbar(
                            'Erreur',
                            'Disponible uniquement sur Android/iOS',
                          );
                          return;
                        }
                        Get.back();
                        Get.to(() => const ProcessingView());
                      },
                      child: const Text('Confirmer'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
