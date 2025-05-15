import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileService {
  static Future<void> deleteFolders(List<String> folderNames) async {
    for (final folderName in folderNames) {
      try {
        Directory folder;

        if (Platform.isAndroid) {
          folder = Directory('/storage/emulated/0/Download/$folderName');
        } else if (Platform.isIOS) {
          final appDocDir = await getApplicationDocumentsDirectory();
          folder = Directory('${appDocDir.path}/$folderName');
        } else {
          throw UnsupportedError('Plateforme non supportée');
        }

        if (await folder.exists()) {
          await folder.delete(recursive: true);
        }
      } catch (e) {
        print('Erreur lors de la suppression de $folderName : $e');
      }
    }
  }
}
