import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:ffmpeg_kit_16kb/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_16kb/ffprobe_kit.dart';
import 'package:ffmpeg_kit_16kb/return_code.dart';
// import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
// import 'package:ffmpeg_kit_flutter_new/return_code.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_spliter/app/modules/home/controllers/home_controller.dart';
import 'package:video_spliter/app/services/ad_mob_service.dart';
import 'package:video_spliter/app/services/app_service.dart';
import 'package:video_spliter/app/services/analytics_service.dart';
import 'package:video_spliter/app/utils/methods_utils.dart';
import 'package:video_spliter/app/utils/video_logic.dart';

class VideoService {
  /// Pre-compress a video to improve performance for further processing
  /// Returns the output path of the compressed video
  Future<String?> compressVideo({
    required String inputPath,
    required String outputPath,
  }) async {
    try {
      final info = await VideoCompress.compressVideo(
        inputPath,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );
      // log('info: ${info?.path}');
      // if (info?.filesize != null) {
      //   log('info: ${info!.filesize! / (1024 * 1024)}');
      // } else {
      //   log('info: filesize is null');
      // }
      return info?.path;
    } catch (e) {
      log('Error during video compression: $e');
      return null;
    }
  }

  static Future<List<File>> splitBySSAsync({
    required File videoFile,
    required double sliceDuration,
    required bool isPro,
  }) async {
    final HomeController homeController = Get.find<HomeController>();

    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      throw UnsupportedError('FFmpegKit is only supported on Android and iOS.');
    }

    // Dossier de sortie
    final tempDir = await getTemporaryDirectory();

    String? watermarkTempPath;
    int? watermarkWidth;
    int? watermarkHeight;

    if (!isPro) {
      try {
        final byteData = await DefaultAssetBundle.of(
          Get.context!,
        ).load('assets/logo/watermark.png');

        final codec = await ui.instantiateImageCodec(
          byteData.buffer.asUint8List(),
        );
        final frame = await codec.getNextFrame();
        final image = frame.image;
        watermarkWidth = image.width;
        watermarkHeight = image.height;

        final rawBytes = await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );
        if (rawBytes != null) {
          final file = File(p.join(tempDir.path, 'watermark_temp.raw'));
          await file.writeAsBytes(rawBytes.buffer.asUint8List());
          watermarkTempPath = file.path;
        }
      } catch (e) {
        log('Error loading watermark asset: $e');
      }
    }

    // Récupérer la durée totale avec FFprobe (async)
    final probeSession = await FFprobeKit.getMediaInformation(videoFile.path);
    final info = probeSession.getMediaInformation(); // <-- await important
    final totalDuration = double.tryParse(info?.getDuration() ?? '0') ?? 0;
    if (totalDuration <= 0) {
      throw Exception('Impossible de déterminer la durée de la vidéo.');
    }

    final totalSegments = VideoLogic.calculateSegmentCount(
      totalDuration,
      sliceDuration,
    );
    final fileBase = p.basenameWithoutExtension(videoFile.path);
    final List<File> videoParts = [];

    // Séquence: on lance chaque segment en async et on attend sa fin avec un Completer.
    for (int index = 0; index < totalSegments; index++) {
      final start = index * sliceDuration;
      final isLast = (start + sliceDuration) > totalDuration;
      final segDur = isLast ? (totalDuration - start) : sliceDuration;

      // Nettoyage automatique : ignorer les micro-segments (< 1 seconde)
      if (segDur < 1.0) {
        log('Skipping micro-segment: duration $segDur is too short.');
        // Mettre à jour la progression pour ne pas bloquer l'UI
        final global = ((index + 1) / totalSegments).clamp(0.0, 1.0);
        homeController.progress.value = global;
        homeController.update();
        continue;
      }

      final outPath = p.join(
        tempDir.path,
        '${fileBase}_part_${(index + 1).toString().padLeft(3, '0')}.mp4',
      );

      final args = VideoLogic.generateSplitArgs(
        inputPath: videoFile.path,
        outputPath: outPath,
        startTime: start,
        duration: segDur,
        isPro: isPro,
        watermarkPath: watermarkTempPath,
        watermarkWidth: watermarkWidth,
        watermarkHeight: watermarkHeight,
      );

      // Completer pour ce segment
      final segCompleter = Completer<void>();

      // Lancer l’exécution asynchrone
      final session = await FFmpegKit.executeAsync(
        joinArgs(args),
        // onComplete
        (session) async {
          final rc = await session.getReturnCode();
          if (ReturnCode.isSuccess(rc)) {
            final file = File(outPath);
            // Vérifier que le fichier existe et n'est pas vide
            if (await file.exists() && await file.length() > 0) {
              videoParts.add(file);
            }
            // Fixe la progression à la fin du segment (100% du segment)
            final global = ((index + 1) / totalSegments).clamp(0.0, 1.0);
            homeController.progress.value = global;
            homeController.update();
            segCompleter.complete();
          } else {
            final logs = await session.getAllLogsAsString();
            log(logs.toString());
            final logsLines = logs?.split('\n') ?? [];
            final lastLogs =
                logsLines.length > 20
                    ? logsLines.sublist(logsLines.length - 20).join('\n')
                    : logs;
            segCompleter.completeError(
              Exception('Erreur FFmpeg sur le segment ${index + 1}\n$lastLogs'),
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
    final context = Get.context;
    if (context == null) return;
    final box = context.findRenderObject() as RenderBox?;

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final adMobService = AdMobService();
      final filesToProcess =
          videoParts.where((file) => file.existsSync()).toList();

      if (filesToProcess.isEmpty) {
        Get.back();
        Get.snackbar('error_sharing_videos'.tr, 'no_video_to_share'.tr);
        return;
      }

      List<XFile> filesToShare =
          filesToProcess.map((file) => XFile(file.path)).toList();

      Get.back(); // Ferme le loading avant d'ouvrir le menu natif de partage

      await SharePlus.instance.share(
        ShareParams(
          files: filesToShare,
          sharePositionOrigin:
              box != null ? box.localToGlobal(Offset.zero) & box.size : null,
        ),
      );

      AnalyticsService.videoShared(segmentCount: videoParts.length);
      // Demande de notation après un partage réussi
      AppService().handleRatingRequestAfterShare();
      adMobService.loadInterstitialAd(
        onAdDismissed: () {},
        onAdReady: () {
          adMobService.showInterstitialAd();
        },
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      showSnackBar('${'error_sharing_videos'.tr} $e', isError: true);
      print(e);
    }
  }

  static Future<void> saveVideos(List<File> videoParts) async {
    final context = Get.context;
    if (context == null) return;

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final adMobService = AdMobService();

      if (videoParts.isEmpty) {
        Get.back(); // Close loading
        Get.snackbar('error_saving_videos'.tr, 'no_video_to_save'.tr);
        return;
      }

      for (var video in videoParts) {
        await VideoLogic.saveVideoToGallery(video.path);
      }

      Get.back(); // Close loading
      showSnackBar('export_success'.tr, isError: false);

      // Demande de notation après un export réussi
      AppService().handleRatingRequestAfterShare();

      adMobService.loadInterstitialAd(
        onAdDismissed: () {},
        onAdReady: () {
          adMobService.showInterstitialAd();
        },
      );
    } catch (e) {
      Get.back(); // Close loading
      showSnackBar('${'error_saving_videos'.tr} $e', isError: true);
      print(e);
    }
  }
}
