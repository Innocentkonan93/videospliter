import 'dart:developer';
import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_spliter/app/modules/home/controllers/home_controller.dart';
import 'package:video_spliter/app/services/ad_mob_service.dart';
import 'package:video_spliter/app/utils/methods_utils.dart';

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
      final String outputPattern = '$outputPath/cut_it_%03d.mp4';

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
                    file.path.contains('cut_it_') && file.path.endsWith('.mp4'),
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
    HomeController homeController = Get.find<HomeController>();
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      throw UnsupportedError('FFmpegKit is only supported on Android and iOS.');
    }

    final videoParts = <File>[];
    final tempDir = await getTemporaryDirectory();

    final mediaInfoSession = await FFprobeKit.getMediaInformation(
      videoFile.path,
    );
    final info = mediaInfoSession.getMediaInformation();
    final totalDuration = double.tryParse(info?.getDuration() ?? '0') ?? 0;

    int index = 0;
    double start = 0;
    final totalSegments = (totalDuration / sliceDuration).ceil();

    while (start < totalDuration) {
      final output =
          '${tempDir.path}/cut_it_${DateTime.now().millisecondsSinceEpoch}_$index.mp4';

      // final command = [
      //   '-ss',
      //   '$start',
      //   '-t',
      //   '$sliceDuration',
      //   '-i',
      //   '"${videoFile.path}"',
      //   '-vf',
      //   "crop='floor(in_w/2)*2:floor(in_h/2)*2'",
      //   '-c:v',
      //   'mpeg4',
      //   '-b:v',
      //   '1M',
      //   '-c:a',
      //   'aac',
      //   '-strict',
      //   'experimental',
      //   '-y',
      //   '"$output"',
      // ].join(' ');

      final command = [
        '-ss',
        '$start',
        '-t',
        '$sliceDuration',
        '-i',
        '"${videoFile.path}"',
        '-vf',
        "crop='floor(in_w/2)*2:floor(in_h/2)*2'",
        '-c:v',
        'mpeg4',
        '-qscale:v',
        '2', // ✅ qualité élevée
        '-c:a',
        'aac',
        '-b:a',
        '128k',
        '-y',
        '"$output"',
      ].join(' ');

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();
      if (returnCode?.isValueSuccess() == true) {
        videoParts.add(File(output));
      } else {
        final logs = await session.getAllLogsAsString();
        log(logs ?? 'Erreur FFmpeg sur le segment $index');
        showSnackBar(
          "Erreur FFmpeg sur le segment $index\n$logs",
          isError: true,
        );
        throw Exception("Erreur FFmpeg sur le segment $index\n$logs");
      }

      index++;
      start += sliceDuration;
      homeController.progress.value = index / totalSegments; // 👈 progression
      homeController.update();
    }

    return videoParts;
  }

  static Future<void> shareVideos(List<File> videoParts) async {
    final adMobService = AdMobService();
    final filesToShare =
        videoParts
            .where((file) => file.existsSync())
            .map((file) => XFile(file.path))
            .toList();

    if (filesToShare.isEmpty) {
      Get.snackbar('Erreur', 'Aucune vidéo à partager.');
      return;
    }
    await SharePlus.instance.share(ShareParams(files: filesToShare));
    adMobService.loadInterstitialAd(
      onAdDismissed: () {},
      onAdReady: () {
        print('ad ready');
        adMobService.showInterstitialAd();
      },
    );
  }
}
