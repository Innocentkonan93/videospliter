import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
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
          '${tempDir.path}/cut_it_${index.toString().padLeft(3, '0')}.mp4';

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

    // videoParts.sort((a, b) => a.path.compareTo(b.path));
    return videoParts;
  }

  static Future<List<File>> splitBySSAsync({
    required File videoFile,
    required double sliceDuration,
  }) async {
    final HomeController homeController = Get.find<HomeController>();

    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      throw UnsupportedError('FFmpegKit is only supported on Android and iOS.');
    }

    // Dossier de sortie
    final tempDir = await getTemporaryDirectory();

    // Récupérer la durée totale avec FFprobe (async)
    final probeSession = await FFprobeKit.getMediaInformation(videoFile.path);
    final info = probeSession.getMediaInformation(); // <-- await important
    final totalDuration = double.tryParse(info?.getDuration() ?? '0') ?? 0;
    if (totalDuration <= 0) {
      throw Exception('Impossible de déterminer la durée de la vidéo.');
    }

    final totalSegments = (totalDuration / sliceDuration).ceil();
    final fileBase = p.basenameWithoutExtension(videoFile.path);
    final List<File> videoParts = [];

    // Séquence: on lance chaque segment en async et on attend sa fin avec un Completer.
    for (int index = 0; index < totalSegments; index++) {
      final start = index * sliceDuration;
      final isLast = (start + sliceDuration) > totalDuration;
      final segDur = isLast ? (totalDuration - start) : sliceDuration;

      final outPath = p.join(
        tempDir.path,
        '${fileBase}_part_${(index + 1).toString().padLeft(3, '0')}.mp4',
      );

      final args = <String>[
        '-ss', fmt(start),
        '-t', fmt(segDur),
        '-i', videoFile.path,
        // Évite dimensions impaires
        '-vf', "crop='floor(in_w/2)*2:floor(in_h/2)*2'",
        // Vidéo (ton choix mpeg4, qualité élevée)
        '-c:v', 'mpeg4',
        '-qscale:v', '2',
        // Audio
        '-c:a', 'aac',
        '-b:a', '128k',
        // Lecture web/phone plus rapide
        '-movflags', '+faststart',
        // Overwrite
        '-y',
        outPath,
      ];

      // Completer pour ce segment
      final segCompleter = Completer<void>();

      // Lancer l’exécution asynchrone
      final session = await FFmpegKit.executeAsync(
        joinArgs(args),
        // onComplete
        (session) async {
          final rc = await session.getReturnCode();
          if (ReturnCode.isSuccess(rc)) {
            videoParts.add(File(outPath));
            // Fixe la progression à la fin du segment (100% du segment)
            final global = ((index + 1) / totalSegments).clamp(0.0, 1.0);
            homeController.progress.value = global;
            homeController.update();
            segCompleter.complete();
          } else {
            final logs = await session.getAllLogsAsString();
            segCompleter.completeError(
              Exception('Erreur FFmpeg sur le segment ${index + 1}\n$logs'),
            );
          }
        },
        // onLog (optionnel)
        (log) {
          // Tu peux parser log.getMessage() si tu préfères la progression via logs.
        },
        // onStatistics → progression fine du segment courant
        (stats) {
          final tMs = stats.getTime(); // ms encodées dans ce segment
          final segProgress = (tMs / 1000.0) / (segDur <= 0 ? 1 : segDur);
          final global = ((index + segProgress) / totalSegments).clamp(
            0.0,
            1.0,
          );
          homeController.progress.value = global.toDouble();
          homeController.update();
        },
      );

      // Attendre la fin du segment avant de lancer le prochain
      await segCompleter.future;

      // (Facultatif) S'assurer que la session n'est plus en cours
      await session.getState();
    }

    return videoParts;
  }

  /// Formatte un double propre (3 décimales max)
  static String fmt(double v) => v.toStringAsFixed(3);

  /// Concatène proprement les arguments en une commande string.
  /// Quote uniquement si nécessaire (espaces, guillemets).
  static String joinArgs(List<String> args) {
    return args
        .map((a) {
          if (a.contains(' ') || a.contains('"') || a.contains("'")) {
            final escaped = a.replaceAll('"', r'\"');
            return '"$escaped"';
          }
          return a;
        })
        .join(' ');
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
        // print('ad ready');
        adMobService.showInterstitialAd();
      },
    );
  }
}
