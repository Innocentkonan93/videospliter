// ignore_for_file: avoid_print

import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:video_spliter/app/utils/constants.dart';
import 'package:video_spliter/app/utils/methods_utils.dart';

class FileService {
  static Future<void> deleteFolders(List<String> folderNames) async {
    print('🔥 Suppression des dossiers : $folderNames');
    for (final folderName in folderNames) {
      try {
        Directory? targetDir;

        if (Platform.isAndroid) {
          final dir = await getExternalStorageDirectory();
          if (dir == null) {
            throw Exception("Impossible d'accéder au répertoire externe.");
          }
          targetDir = Directory(p.join(dir.path, appName, folderName));
        } else if (Platform.isIOS) {
          final appDocDir = await getApplicationDocumentsDirectory();
          targetDir = Directory(p.join(appDocDir.path, appName, folderName));
        } else {
          throw UnsupportedError('Plateforme non supportée');
        }
        if (await targetDir.exists()) {
          await targetDir.delete(recursive: true);
          print('✅ Supprimé : ${targetDir.path}');
          showSnackBar('Dossier supprimé avec succès');
        } else {
          print('⚠️ Dossier non trouvé : ${targetDir.path}');
        }
      } catch (e) {
        print('❌ Erreur lors de la suppression de $folderName : $e');
      }
    }
  }

  static Future<void> renameFolder(String folderName, String newName) async {
    try {
      Directory? targetDir;

      if (Platform.isAndroid) {
        final dir = await getExternalStorageDirectory();
        if (dir == null) {
          throw Exception("Impossible d'accéder au répertoire externe.");
        }
        targetDir = Directory(p.join(dir.path, appName, folderName));
      } else if (Platform.isIOS) {
        final appDocDir = await getApplicationDocumentsDirectory();
        targetDir = Directory(p.join(appDocDir.path, appName, folderName));
      } else {
        throw UnsupportedError('Plateforme non supportée');
      }

      if (await targetDir.exists()) {
        final newDir = Directory(p.join(targetDir.parent.path, newName));
        await targetDir.rename(newDir.path);
        print('✅ Dossier renommé : ${newDir.path}');
        showSnackBar('Dossier renommé avec succès');
      } else {
        print('⚠️ Dossier non trouvé : ${targetDir.path}');
      }
    } catch (e) {
      print('❌ Erreur lors du renommage de $folderName : $e');
    }
  }

  static Future<void> cleanTemporaryFiles() async {
    print('🧹 Lancement du nettoyage des fichiers temporaires...');
    try {
      final tempDir = await getTemporaryDirectory();
      if (await tempDir.exists()) {
        final now = DateTime.now();
        final threshold = now.subtract(const Duration(hours: 24));
        int deletedCount = 0;

        await for (final entity in tempDir.list(recursive: true, followLinks: false)) {
          if (entity is File) {
            try {
              final lastModified = await entity.lastModified();
              if (lastModified.isBefore(threshold)) {
                await entity.delete();
                deletedCount++;
              }
            } catch (e) {
              // On ignore et continue pour les autres fichiers
              print('⚠️ Impossible de supprimer le fichier temporaire ${entity.path} : $e');
            }
          }
        }
        print('✅ Nettoyage des fichiers temporaires terminé. Fichiers supprimés : $deletedCount');
      } else {
        print('⚠️ Dossier temporaire non trouvé.');
      }
    } catch (e) {
      print('❌ Erreur lors du nettoyage des fichiers temporaires : $e');
    }
  }
}

