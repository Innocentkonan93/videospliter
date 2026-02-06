import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:path/path.dart' as p;

void showSnackBar(String message, {bool? isError = false}) {
  ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
  ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            isError == true ? Icons.error : Icons.check_circle_rounded,
            color: AppColors.white,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Get.theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isError == true ? AppColors.red : AppColors.green,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 10),
      elevation: 0,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

void vibrate() async {
  // HapticFeedback.lightImpact(); // ou Vibration.vibrate(duration: 50);
  HapticFeedback.mediumImpact(); // moyen
  // HapticFeedback.heavyImpact(); // fort
  // HapticFeedback.selectionClick(); // clic type sélection
}

Future<String> normalizePickedVideo(String pickedPath) async {
  final tempDir = await getTemporaryDirectory();

  // sécurité : créer le dossier
  if (!await tempDir.exists()) {
    await tempDir.create(recursive: true);
  }

  final extension = pickedPath.split('.').last;
  final normalizedPath =
      '${tempDir.path}/input_${DateTime.now().millisecondsSinceEpoch}.$extension';

  final sourceFile = File(pickedPath);

  if (!await sourceFile.exists()) {
    throw Exception('Source video does not exist');
  }

  final copiedFile = await sourceFile.copy(normalizedPath);

  // 🔍 debug critique
  debugPrint('Normalized exists: ${await copiedFile.exists()}');
  debugPrint('Normalized path: ${copiedFile.path}');

  return copiedFile.path;
}

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  if (duration.inHours > 0) {
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  } else {
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
