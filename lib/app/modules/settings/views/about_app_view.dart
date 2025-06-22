import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/settings/controllers/settings_controller.dart';
import 'package:video_spliter/app/utils/constants.dart';

class AboutAppView extends GetWidget<SettingsController> {
  const AboutAppView({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = context.theme;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: Text("À propos")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(aboutApp, style: theme.textTheme.titleMedium),
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Version ${controller.version.value}",
              style: theme.textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
