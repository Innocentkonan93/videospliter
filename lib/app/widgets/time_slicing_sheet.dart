import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/utils/constants.dart';
import 'package:video_spliter/app/widgets/custom_video_player_view.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
    final height = MediaQuery.sizeOf(context).height;
    return Obx(
      () => SafeArea(
        child: SizedBox(
          height: height * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (controller.selectedVideo.value != null)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: .1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CustomVideoPlayerWidget(
                      key: ValueKey(controller.selectedVideo.value!.path),
                      videoFile: controller.selectedVideo.value!,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'define_duration_excerpts'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      child: Row(
                        children: [
                          // Custom button (abacus icon)
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                PremiumTapEffect(
                                  onTap: () {
                                    controller.isCustom.value = true;
                                    controller.selectedSocial.value = "";
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    padding: EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color:
                                          controller.isCustom.value
                                              ? AppColors.primary
                                              : const Color.fromARGB(
                                                255,
                                                235,
                                                235,
                                                235,
                                              ),
                                      shape: BoxShape.circle,
                                      boxShadow:
                                          controller.isCustom.value
                                              ? [
                                                BoxShadow(
                                                  color: AppColors.primary
                                                      .withValues(alpha: .3),
                                                  blurRadius: 12,
                                                  spreadRadius: 2,
                                                  offset: const Offset(0, 6),
                                                ),
                                              ]
                                              : null,
                                    ),
                                    child: HugeIcon(
                                      icon: HugeIcons.strokeRoundedAbacus,
                                      size: 32,
                                      color:
                                          controller.isCustom.value
                                              ? AppColors.white
                                              : AppColors.black.withValues(
                                                alpha: .6,
                                              ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'custom'.tr,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontSize: 12,
                                    color:
                                        controller.isCustom.value
                                            ? AppColors.orange
                                            : AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Social media icons
                          ...socialMedia.map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Column(
                                children: [
                                  PremiumTapEffect(
                                    onTap: () {
                                      controller.isCustom.value = false;
                                      controller.selectedSocial.value =
                                          e['name'];
                                      controller.sliceDuration.value =
                                          e['duration'].toDouble();
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                      padding: EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color:
                                            controller.selectedSocial.value ==
                                                    e['name']
                                                ? e['color']
                                                : const Color.fromARGB(
                                                  120,
                                                  235,
                                                  235,
                                                  235,
                                                ),
                                        shape: BoxShape.circle,
                                        boxShadow:
                                            controller.selectedSocial.value ==
                                                    e['name']
                                                ? [
                                                  BoxShadow(
                                                    color: (e['color'] as Color)
                                                        .withValues(alpha: .3),
                                                    blurRadius: 12,
                                                    spreadRadius: 2,
                                                    offset: const Offset(0, 6),
                                                  ),
                                                ]
                                                : null,
                                      ),
                                      child: HugeIcon(
                                        icon: e['icon'],
                                        size: 32,
                                        color:
                                            controller.selectedSocial.value ==
                                                    e['name']
                                                ? AppColors.white
                                                : AppColors.black.withValues(
                                                  alpha: .6,
                                                ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    e['name'],
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontSize: 12,
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
                        ],
                      ),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                    controller
                                                        .sliceDuration
                                                        .value
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
                                                backgroundColor:
                                                    AppColors.white,
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
                                            value:
                                                controller.sliceDuration.value,
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
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color:
                                              socialMedia.firstWhere(
                                                (element) =>
                                                    element['name'] ==
                                                    controller
                                                        .selectedSocial
                                                        .value,
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
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: .4),
                            blurRadius: 24,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedSuperellipseBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
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
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
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
      ),
    );
  }
}

class PremiumTapEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const PremiumTapEffect({super.key, required this.child, required this.onTap});

  @override
  State<PremiumTapEffect> createState() => _PremiumTapEffectState();
}

class _PremiumTapEffectState extends State<PremiumTapEffect>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.15,
    );
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) async {
        await _scaleController.reverse();
        _shakeController.forward(from: 0.0);
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
            animation: _scaleController,
            builder:
                (context, child) => Transform.scale(
                  scale: 1.0 - _scaleController.value,
                  child: child,
                ),
            child: widget.child,
          )
          .animate(controller: _shakeController, autoPlay: false)
          .shake(hz: 4, curve: Curves.easeInOut),
    );
  }
}
