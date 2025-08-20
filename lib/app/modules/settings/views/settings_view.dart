import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/settings/controllers/settings_controller.dart';
import 'package:video_spliter/app/utils/constants.dart';

class SettingsView extends GetWidget<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    Get.put(SettingsController());
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr), centerTitle: true),
      backgroundColor: AppColors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: settings.length,
        itemBuilder: (context, index) {
          return Padding(
            key: ValueKey(settings[index]['title']),
            padding: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(
                settings[index]['title'] as String,
                style: theme.textTheme.titleMedium,
              ),
              tileColor: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              leading: Icon(
                settings[index]['icon'] as IconData,
                color: AppColors.primary,
              ),
              onTap: settings[index]['onTap'] as VoidCallback,
            ),
          );
        },
      ),
    );
  }
}
