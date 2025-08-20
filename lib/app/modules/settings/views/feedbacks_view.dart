import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/settings/controllers/settings_controller.dart';

class FeedbacksView extends GetWidget<SettingsController> {
  const FeedbacksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text("report_issue".tr),
        elevation: 0,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
      ),
      body: Obx(() {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description text
                  Text(
                    "sorry_problem".tr,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),

                  // Description field
                  TextFormField(
                    controller: controller.bugDescriptionController,
                    decoration: InputDecoration(
                      hintText: "describe_problem".tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    minLines: 5,
                    maxLines: 8,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "describe_problem_validation".tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Screenshots section
                  Text(
                    "screenshots".tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "screenshots_description".tr,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 16),

                  // Image picker and preview
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Visibility(
                      visible: !controller.isPicking.value,
                      replacement: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Image grid
                          if (controller.selectedImagesPath.isNotEmpty)
                            GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                  ),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.selectedImagesPath.length,
                              itemBuilder: (context, index) {
                                final path =
                                    controller.selectedImagesPath[index];
                                return Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: FileImage(File(path)),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 4,
                                      top: 4,
                                      child: GestureDetector(
                                        onTap:
                                            () => controller.selectedImagesPath
                                                .remove(path),
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),

                          const SizedBox(height: 16),

                          // Image picker buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed:
                                    () => controller.pickImage(
                                      ImageSource.camera,
                                    ),
                                icon: const Icon(Icons.camera_alt),
                                label: Text("camera".tr),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  elevation: 0,
                                  foregroundColor: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed:
                                    () => controller.pickImage(
                                      ImageSource.gallery,
                                    ),
                                icon: const Icon(Icons.photo_library),
                                label: Text("gallery".tr),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  elevation: 0,
                                  foregroundColor: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          controller.isSending.value
                              ? null
                              : controller.sendFeedback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          controller.isSending.value
                              ? SizedBox(
                                height: 20,
                                width: 20,
                                child: const CircularProgressIndicator(),
                              )
                              : Text("send_report".tr),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
