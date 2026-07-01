import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
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
    final theme = context.theme;
    return Obx(
      () => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  Text(
                    'choose_format'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey.withValues(alpha: .8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 24.0,
                    runSpacing: 16.0,
                    children: [
                      // Social media icons
                      ...socialMedia.map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  controller.isCustom.value = false;
                                  controller.selectedSocial.value = e['name'];
                                  controller.sliceDuration.value =
                                      e['duration'].toDouble();
                                },
                                splashColor: Colors.transparent,
                                borderRadius: BorderRadius.circular(60),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color:
                                        controller.selectedSocial.value ==
                                                e['name']
                                            ? e['color']
                                            : const Color.fromARGB(
                                              255,
                                              219,
                                              219,
                                              219,
                                            ).withValues(alpha: .26),
                                    shape: BoxShape.circle,
                                    // border: Border.all(
                                    //   color:
                                    //       controller.selectedSocial.value ==
                                    //               e['name']
                                    //           ? AppColors.orange
                                    //           : Colors.transparent,
                                    //   width: 2,
                                    // ),
                                  ),
                                  child: HugeIcon(
                                    icon: e['icon'],
                                    size: 35,
                                    color:
                                        controller.selectedSocial.value ==
                                                e['name']
                                            ? AppColors.white
                                            : AppColors.black.withValues(
                                              alpha: .7,
                                            ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                e['name'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      controller.selectedSocial.value ==
                                              e['name']
                                          ? AppColors.orange
                                          : AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Custom button (abacus icon)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                controller.isCustom.value = true;
                                controller.selectedSocial.value = "";
                              },
                              borderRadius: BorderRadius.circular(60),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      controller.isCustom.value
                                          ? AppColors.primary
                                          : const Color.fromARGB(
                                            255,
                                            219,
                                            219,
                                            219,
                                          ).withValues(alpha: .26),
                                  shape: BoxShape.circle,
                                ),
                                child: HugeIcon(
                                  icon: HugeIcons.strokeRoundedAbacus,
                                  size: 35,
                                  color:
                                      controller.isCustom.value
                                          ? AppColors.white
                                          : AppColors.black.withValues(
                                            alpha: .7,
                                          ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'custom'.tr,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color:
                                    controller.isCustom.value
                                        ? AppColors.orange
                                        : AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Custom duration controls
                  SizedBox(
                    height:
                        100, // Adjusted to fit custom controls and social controls
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child:
                          controller.isCustom.value
                              ? Column(
                                key: const ValueKey('custom_controls'),
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ...predefinedDurations.map(
                                          (duration) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0,
                                            ),
                                            child: ChoiceChip(
                                              label: Text("${duration}s"),
                                              side: BorderSide(
                                                width: 0,
                                                color: Colors.transparent,
                                              ),
                                              checkmarkColor: Colors.white,
                                              selected:
                                                  controller.sliceDuration.value
                                                      .toInt() ==
                                                  duration,
                                              selectedColor: AppColors.orange,
                                              onSelected: (selected) {
                                                if (selected) {
                                                  controller
                                                          .sliceDuration
                                                          .value =
                                                      duration.toDouble();
                                                }
                                              },
                                              labelStyle: TextStyle(
                                                color:
                                                    controller
                                                                .sliceDuration
                                                                .value
                                                                .toInt() ==
                                                            duration
                                                        ? AppColors.white
                                                        : AppColors.black,
                                              ),
                                              backgroundColor: AppColors.white,
                                              shape: StadiumBorder(
                                                side: BorderSide(
                                                  width: 0.5,
                                                  color:
                                                      controller
                                                                  .sliceDuration
                                                                  .value
                                                                  .toInt() ==
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
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        '1s',
                                        style: theme.textTheme.titleMedium,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Slider(
                                          min: 1,
                                          max: 180,
                                          divisions: 180,
                                          label:
                                              '${controller.sliceDuration.value.toInt()}s',
                                          thumbColor: AppColors.orange,
                                          year2023: false,
                                          padding: EdgeInsets.zero,
                                          activeColor: AppColors.orange,
                                          // secondaryTrackValue: 20,
                                          value: controller.sliceDuration.value,
                                          onChanged: (value) {
                                            controller.sliceDuration.value =
                                                value;
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '180s',
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                              : Container(
                                key: const ValueKey('social_controls'),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Text(
                                  "${'social_preset'.tr}: ${controller.selectedSocial.value}",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color:
                                        socialMedia.firstWhere(
                                          (element) =>
                                              element['name'] ==
                                              controller.selectedSocial.value,
                                          orElse: () => socialMedia.first,
                                        )['color'],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${'duration_defined'.tr} ${controller.sliceDuration.value.toInt()} s',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (!GetPlatform.isMobile) {
                          Get.snackbar('error'.tr, 'only_mobile'.tr);
                          return;
                        }
                        Get.back(result: controller.sliceDuration.value);
                      },
                      child: Text(
                        'cut'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
