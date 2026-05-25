import 'dart:io';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:video_spliter/app/services/analytics_service.dart';
import 'package:video_spliter/app/services/feature_manager.dart';
import 'package:video_spliter/app/utils/constants.dart';
import 'package:video_spliter/app/utils/methods_utils.dart';

class SaveSegmentsService {
  static int _splitCounter = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  static Future<void> saveSegments(
    List<File> segments,
    String? baseFolderName,
  ) async {
    final startTime = DateTime.now();
    int? segmentCount;
    double? totalSizeMb;
    final isPro = FeatureManager.isProUser;
    Directory? targetDir;

    try {
      if (segments.isEmpty) {
        throw Exception("no_segment_to_save".tr);
      }

      segmentCount = segments.length;
      totalSizeMb =
          segments.fold<double>(0, (sum, file) => sum + file.lengthSync()) /
          (1024 * 1024);

      // Enregistrer le début de l'export
      AnalyticsService.exportStarted(
        segmentCount: segmentCount,
        isPremium: isPro,
        exportFormat: 'mp4',
      );

      final String cleanBaseName = (baseFolderName == null || baseFolderName.trim().isEmpty)
          ? "Cutit"
          : baseFolderName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_').trim();
      final String folderName = '$cleanBaseName-$_splitCounter';
      _splitCounter++;

      if (Platform.isAndroid) {
        final dir = await getExternalStorageDirectory();
        if (dir == null) {
          throw Exception("error_accessing_external_directory".tr);
        }
        targetDir = Directory(p.join(dir.path, appName, folderName));
      } else if (Platform.isIOS) {
        final appDocDir = await getApplicationDocumentsDirectory();
        targetDir = Directory(p.join(appDocDir.path, appName, folderName));
      } else {
        throw UnsupportedError('platform_not_supported'.tr);
      }

      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }

      for (final file in segments) {
        final fileName = p.basename(file.path);
        final newFile = File(p.join(targetDir.path, fileName));
        await file.copy(newFile.path);
      }

      // Calculer le temps d'export
      final exportTimeSec = DateTime.now().difference(startTime).inSeconds;

      // Enregistrer le succès de l'export
      AnalyticsService.exportSuccess(
        exportTimeSec: exportTimeSec,
        isPremium: isPro,
        segmentCount: segmentCount,
        totalSizeMb: totalSizeMb,
        exportFormat: 'mp4',
      );

      vibrate();
      Get.back();
      // final readablePath = targetDir.path.split("/Android").first;
      showSnackBar("saving_videos".tr);
    } catch (e) {
      // ignore: avoid_print
      print('❌ Erreur lors de la sauvegarde : $e');

      // Nettoyer le dossier cible s'il a été créé pour éviter de laisser des dossiers vides ou corrompus
      if (targetDir != null && await targetDir.exists()) {
        try {
          await targetDir.delete(recursive: true);
        } catch (_) {}
      }

      // Enregistrer l'échec de l'export
      await AnalyticsService.exportFailed(
        reason: e.toString(),
        segmentCount: segmentCount,
        isPremium: isPro,
      );

      showSnackBar('error_saving_videos'.tr, isError: true);
    }
  }
}
