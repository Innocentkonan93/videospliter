import 'dart:io';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:video_spliter/app/utils/constants.dart';
import 'package:video_spliter/app/utils/methods_utils.dart';

class SaveSegmentsService {
  static int _splitCounter = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  static Future<void> saveSegments(
    List<File> segments,
    String? baseFolderName,
  ) async {
    try {
      if (segments.isEmpty) {
        throw Exception("no_segment_to_save".tr);
      }

      final String folderName = '$baseFolderName-$_splitCounter';
      _splitCounter++;

      Directory? targetDir;

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
      vibrate();
      Get.back();
      // final readablePath = targetDir.path.split("/Android").first;
      showSnackBar("saving_videos".tr);
    } catch (e) {
      print('❌ Erreur lors de la sauvegarde : $e');
      showSnackBar('error_saving_videos'.tr, isError: true);
    }
  }
}
