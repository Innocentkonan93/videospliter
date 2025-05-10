import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:flutter/foundation.dart';

import 'package:path_provider/path_provider.dart';

class VideoService {
  static Future<List<File>> splitVideo(
    File videoFile,
    double sliceDuration,
  ) async {
    // ✅ Ne pas exécuter sur des plateformes non supportées
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      throw UnsupportedError('FFmpegKit is only supported on Android and iOS.');
    }

    try {
      // Dossier temporaire
      final directory = await getTemporaryDirectory();
      final String outputPath = directory.path;
      final String outputPattern = '$outputPath/video_part_%03d.mp4';

      final command =
          '-i "${videoFile.path}" -c copy -map 0 -segment_time $sliceDuration -f segment "$outputPattern"';

      // Exécution de la commande FFmpeg
      final session = await FFmpegKit.execute(command);

      final returnCode = await session.getReturnCode();
      if (returnCode?.isValueSuccess() != true) {
        final logs = await session.getAllLogsAsString();
        throw Exception("FFmpeg failed. Logs:\n$logs");
      }

      // Récupération des segments
      final List<FileSystemEntity> files = directory.listSync();
      final List<File> videoParts =
          files
              .where(
                (file) =>
                    file.path.contains('video_part_') &&
                    file.path.endsWith('.mp4'),
              )
              .map((file) => File(file.path))
              .toList();

      return videoParts;
    } catch (e) {
      print('Erreur pendant la découpe vidéo: $e');
      rethrow;
    }
  }

  static Future<List<File>> splitBySS({
    required File videoFile,
    required double sliceDuration,
  }) async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      throw UnsupportedError('FFmpegKit is only supported on Android and iOS.');
    }

    final videoParts = <File>[];
    final tempDir = await getTemporaryDirectory();

    // 🔍 Étape 1 : obtenir la durée totale
    final mediaInfoSession = await FFprobeKit.getMediaInformation(
      videoFile.path,
    );
    final info = mediaInfoSession.getMediaInformation();
    final totalDuration = double.tryParse(info?.getDuration() ?? '0') ?? 0;

    int index = 0;
    double start = 0;

    while (start < totalDuration) {
      final output =
          '${tempDir.path}/video_part_${index.toString().padLeft(3, '0')}.mp4';

      final command = [
        '-ss',
        '$start',
        '-t',
        '$sliceDuration',
        '-i',
        videoFile.path,
        '-c:v',
        'mpeg4',
        '-b:v',
        '1M',
        '-c:a',
        'aac',
        '-strict',
        'experimental',
        '-y',
        output,
      ].join(' ');

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();
      if (returnCode?.isValueSuccess() == true) {
        videoParts.add(File(output));
      } else {
        final logs = await session.getAllLogsAsString();
        throw Exception("Erreur FFmpeg sur le segment $index\n$logs");
      }

      start += sliceDuration;
      index++;
    }

    return videoParts;
  }
}
