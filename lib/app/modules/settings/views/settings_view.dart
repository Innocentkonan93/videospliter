import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/settings/controllers/settings_controller.dart';
import 'package:video_spliter/app/utils/constants.dart';
import 'package:video_spliter/app/services/feature_manager.dart';
import 'package:video_spliter/app/widgets/premium_card.dart';

class SettingsView extends GetWidget<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    // settings.addAll(settings);
    final theme = context.theme;
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr), centerTitle: true),
      backgroundColor: AppColors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
            opacity: .1,
          ),
        ),
        child: SizedBox.expand(
          child: GetBuilder<SettingsController>(
            init: controller,
            builder: (controller) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Premium Card
                    PremiumCard(),
                    // Settings List
                    Obx(() {
                      final filteredGroups =
                          settingsGroups.where((group) {
                            if (group['groupName'] == 'purchases') {
                              return FeatureManager.isProVersionAvailable;
                            }
                            return true;
                          }).toList();

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredGroups.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, groupIndex) {
                          final group = filteredGroups[groupIndex];
                          final groupKey = group['groupName'] as String;
                          final items =
                              group['items'] as List<Map<String, dynamic>>;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4.0,
                                ),
                                child: Text(
                                  groupKey.tr,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 24),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.03,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: items.length,
                                  // separatorBuilder:
                                  //     (context, index) => const Divider(
                                  //       height: .1,
                                  //       thickness: .3,
                                  //       indent: 56,
                                  //       endIndent: 16,
                                  //     ),
                                  itemBuilder: (context, itemIndex) {
                                    final item = items[itemIndex];
                                    final title = item['title'] as String;
                                    final dynamic icon = item['icon'];
                                    final onTap = item['onTap'] as VoidCallback;

                                    return ListTile(
                                      title: Text(
                                        title.tr,
                                        style: theme.textTheme.titleMedium,
                                      ),
                                      leading: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.background,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child:
                                            icon is IconData
                                                ? Icon(
                                                  icon,
                                                  color: AppColors.primary,
                                                  size: 22,
                                                )
                                                : HugeIcon(
                                                  icon: icon,
                                                  color: AppColors.primary,
                                                  size: 22,
                                                ),
                                      ),
                                      trailing: const HugeIcon(
                                        icon:
                                            HugeIcons.strokeRoundedArrowRight01,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      onTap: onTap,
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Obx(() => Text(
                            "${'version'.tr} ${controller.version.value}",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.grey,
                            ),
                          )),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
