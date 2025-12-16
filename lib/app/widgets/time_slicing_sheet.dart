import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/utils/constants.dart';

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
                Text(
                  'define_duration_excerpts'.tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                //
                // Liste de durées prédéfinies
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...predefinedDurations.map(
                        (duration) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text("${duration}s"),
                            checkmarkColor: Colors.white,
                            selected:
                                controller.sliceDuration.value.toInt() ==
                                duration,
                            selectedColor: AppColors.orange,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  controller.sliceDuration.value =
                                      duration.toDouble();
                                  initValue = duration.toDouble();
                                });
                              }
                            },
                            labelStyle: TextStyle(
                              color:
                                  controller.sliceDuration.value.toInt() ==
                                          duration
                                      ? AppColors.white
                                      : AppColors.black,
                            ),

                            backgroundColor: AppColors.white,
                            shape: StadiumBorder(
                              side: BorderSide(
                                width: 0.5,
                                color:
                                    controller.sliceDuration.value.toInt() ==
                                            duration
                                        ? AppColors.orange
                                        : const Color.fromARGB(
                                          100,
                                          167,
                                          167,
                                          167,
                                        ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
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
                        thumbColor: AppColors.orange,
                        padding: EdgeInsets.zero,
                        activeColor: AppColors.orange,
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
                  '${'duration_defined'.tr} ${controller.sliceDuration.value.toInt()} s',
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
                      Get.snackbar('error'.tr, 'only_mobile'.tr);
                      return;
                    }
                    Get.back(result: initValue);
                    // Get.to(() => const ProcessingView());
                  },
                  child: Text('cut'.tr),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
