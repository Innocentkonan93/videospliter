import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_spliter/app/modules/settings/controllers/settings_controller.dart';

class LanguageSelectionSheet extends GetWidget<SettingsController> {
  const LanguageSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (controller) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'language'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Text(
                        '🇫🇷',
                        style: TextStyle(fontSize: 24),
                      ),
                      title: const Text('Français'),
                      onTap: () {
                        controller.selectLanguage('fr');
                        Get.back();
                      },
                      trailing:
                          controller.isFrench.value == true
                              ? const Icon(Icons.check)
                              : const SizedBox.shrink(),
                    ),
                    ListTile(
                      leading: const Text(
                        '🇺🇸',
                        style: TextStyle(fontSize: 24),
                      ),
                      title: const Text('English'),
                      onTap: () {
                        controller.selectLanguage('en');
                        Get.back();
                      },
                      trailing:
                          controller.isFrench.value == false
                              ? const Icon(Icons.check)
                              : const SizedBox.shrink(),
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
