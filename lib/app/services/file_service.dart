import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileService {
  static Future<void> deleteFolders(List<String> folderNames) async {
    for (final folderName in folderNames) {
      try {
        Directory? baseDir;

        if (Platform.isAndroid) {
          final dir = await getExternalStorageDirectory();
          if (dir == null) continue;
          baseDir = Directory(p.join(dir.path, folderName));
        } else if (Platform.isIOS) {
          final appDocDir = await getApplicationDocumentsDirectory();
          baseDir = Directory(p.join(appDocDir.path, folderName));
        } else {
          throw UnsupportedError('Plateforme non supportée');
        }

        if (await baseDir.exists()) {
          await baseDir.delete(recursive: true);
          print('✅ Supprimé : ${baseDir.path}');
        } else {
          print('⚠️ Dossier non trouvé : ${baseDir.path}');
        }
      } catch (e) {
        print('❌ Erreur lors de la suppression de $folderName : $e');
      }
    }
  }
}
