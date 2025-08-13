import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/views/progressing_view.dart';

import '../modules/home/controllers/home_controller.dart';

class TimeSlicingSheet extends StatefulWidget {
  const TimeSlicingSheet({super.key});

  @override
  State<TimeSlicingSheet> createState() => _TimeSlicingSheetState();
}

class _TimeSlicingSheetState extends State<TimeSlicingSheet> {
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    double initValue = controller.sliceDuration.value;
    final theme = context.theme;
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
                  'Définir la durée de chaque extrait vidéo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text('1s', style: theme.textTheme.titleMedium),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Slider(
                        min: 1,
                        max: 60,
                        divisions: 60,
                        label: '${initValue.toInt()}s',
                        thumbColor: AppColors.primary,
                        padding: EdgeInsets.zero,
                        activeColor: AppColors.primary,
                        value: controller.sliceDuration.value,
                        onChanged: (value) {
                          controller.sliceDuration.value = value;
                          setState(() {
                            initValue = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text('60s', style: theme.textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Durée définie : ${controller.sliceDuration.value.toInt()} s',
                  style: theme.textTheme.titleMedium,
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
                    Get.back(result: initValue);
                    // Get.to(() => const ProcessingView());
                  },
                  child: const Text('Découper'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
