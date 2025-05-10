import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:video_spliter/app/utils/methods_utils.dart';

class SaveSegmentsService {
  static int _splitCounter = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  static Future<void> saveSegments(List<File> segments) async {
    if (segments.isEmpty) {
      throw Exception("Aucun segment à enregistrer.");
    }

    final String folderName = 'VideoSpliter/Split$_splitCounter';
    _splitCounter++;

    // Créer le dossier de destination
    Directory? targetDir;

    if (Platform.isAndroid) {
      // Android : on écrit dans /storage/emulated/0/Download/...
      targetDir = Directory('/storage/emulated/0/Download/$folderName');
    } else if (Platform.isIOS) {
      // iOS : dossier Documents de l'application
      final appDocDir = await getApplicationDocumentsDirectory();
      targetDir = Directory('${appDocDir.path}/$folderName');
    }

    if (targetDir != null && !targetDir.existsSync()) {
      await targetDir.create(recursive: true);
    }

    for (final file in segments) {
      final fileName = p.basename(file.path);
      final newFile = File('${targetDir!.path}/$fileName');
      await file.copy(newFile.path);
    }

    Get.back();
    showSnackBar(
      'Vidéos enregistrées dans ${Platform.isAndroid ? 'Download/$folderName' : folderName}',
    );
  }
}
