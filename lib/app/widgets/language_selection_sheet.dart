import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_spliter/app/modules/settings/controllers/settings_controller.dart';
import 'package:video_spliter/app/utils/constants.dart';

class LanguageSelectionSheet extends GetWidget<SettingsController> {
  const LanguageSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (controller) {
        return Container(
          height: 500,
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  children:
                      languages.map((language) {
                        final code = language['code'] as String;
                        final name = language['name'] as String;
                        final flag = language['flag'] as String;
                        final isSelected =
                            controller.selectedLanguage.value == code;

                        return ListTile(
                          leading: Text(
                            flag,
                            style: const TextStyle(fontSize: 24),
                          ),
                          title: Text(name.tr),
                          onTap: () {
                            controller.selectLanguage(code);
                            controller.selectedLanguage.value = code;
                            Get.back();
                          },
                          trailing:
                              isSelected
                                  ? const Icon(Icons.check)
                                  : const SizedBox.shrink(),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
