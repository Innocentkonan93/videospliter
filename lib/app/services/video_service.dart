// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/services/ad_mob_service.dart';
import 'package:video_spliter/app/services/app_service.dart';
import 'package:video_spliter/app/services/analytics_service.dart';
import 'package:video_spliter/app/utils/methods_utils.dart';
import 'package:video_spliter/app/utils/video_logic.dart';
import 'package:video_spliter/app/widgets/export_type_sheet.dart';
import 'package:lottie/lottie.dart';

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
    void Function(double)? onProgress,
    void Function(int count)? onSegmentsCalculated,
    void Function(int index, double progress)? onSegmentProgress,
    void Function(int index, File file)? onSegmentComplete,
  }) async {
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

    final totalSegments = VideoLogic.calculateSegmentCount(
      totalDuration,
      sliceDuration,
    );
    onSegmentsCalculated?.call(totalSegments);
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
        onProgress?.call(global);
        onSegmentProgress?.call(index, 1.0);
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
      );

      // Completer pour ce segment
      final segCompleter = Completer<void>();

      // Lancer l’exécution asynchrone
      final session = await FFmpegKit.executeWithArgumentsAsync(
        args,
        // onComplete
        (session) async {
          final rc = await session.getReturnCode();
          if (ReturnCode.isSuccess(rc)) {
            final file = File(outPath);
            // Vérifier que le fichier existe et n'est pas vide
            if (await file.exists() && await file.length() > 0) {
              videoParts.add(file);
              onSegmentComplete?.call(index, file);
            }
            // Fixe la progression à la fin du segment (100% du segment)
            final global = ((index + 1) / totalSegments).clamp(0.0, 1.0);
            onProgress?.call(global);
            onSegmentProgress?.call(index, 1.0);
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
          onProgress?.call(global.toDouble());
          onSegmentProgress?.call(index, segProgress.clamp(0.0, 1.0));
        },
      );

      // Attendre la fin du segment avant de lancer le prochain
      await segCompleter.future;

      // (Facultatif) S'assurer que la session n'est plus en cours
      await session.getState();
    }

    return videoParts;
  }

  static Future<void> shareVideos(List<File> videoParts) async {
    final context = Get.context;
    if (context == null) return;
    final box = context.findRenderObject() as RenderBox?;

    Get.snackbar(
      'processing'.tr,
      'please_wait'.tr,
      // showProgressIndicator: true,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.white,
      colorText: AppColors.black,
      isDismissible: false,
      duration: const Duration(days: 1),
      icon: Lottie.asset(
        'assets/animations/loading.json',
        width: 40,
        height: 40,
      ),
    );

    try {
      final adMobService = AdMobService();
      final filesToProcess =
          videoParts.where((file) => file.existsSync()).toList();

      if (filesToProcess.isEmpty) {
        if (Get.isSnackbarOpen) Get.closeAllSnackbars();
        Get.snackbar('error_sharing_videos'.tr, 'no_video_to_share'.tr);
        return;
      }

      List<XFile> filesToShare =
          filesToProcess.map((file) => XFile(file.path)).toList();

      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars(); // Ferme le loading avant d'ouvrir le menu natif de partage
      }

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
      adMobService.showInterstitialAd(onAdClosed: () {});
    } catch (e) {
      if (Get.isSnackbarOpen) Get.closeAllSnackbars();
      showSnackBar('${'error_sharing_videos'.tr} $e', isError: true);
      // print(e);
    }
  }

  static Future<void> saveVideos(List<File> videoParts) async {
    final context = Get.context;
    if (context == null) return;

    final exportType = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      builder: (context) => const ExportTypeSheet(),
    );

    if (exportType == null) return; // Action annulée par l'utilisateur

    Get.snackbar(
      'processing'.tr,
      'please_wait'.tr,
      // showProgressIndicator: true,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.white,
      colorText: AppColors.black,
      isDismissible: false,
      duration: const Duration(days: 1),
      icon: Lottie.asset(
        'assets/animations/loading.json',
        width: 40,
        height: 40,
      ),
    );

    try {
      final adMobService = AdMobService();

      if (videoParts.isEmpty) {
        if (Get.isSnackbarOpen) Get.closeAllSnackbars(); // Close loading
        Get.snackbar('error_saving_videos'.tr, 'no_video_to_save'.tr);
        return;
      }

      // Si export Standard (exportType == false), on compresse les vidéos pour réduire la qualité
      for (var video in videoParts) {
        String finalPathToSave = video.path;

        try {
          final info = await VideoCompress.compressVideo(
            video.path,
            quality:
                exportType
                    ? VideoQuality.HighestQuality
                    : VideoQuality.MediumQuality,
            deleteOrigin: false,
            includeAudio: true,
          );
          if (info != null && info.path != null) {
            finalPathToSave = info.path!;
          }
        } catch (e) {
          log('Compression error: $e');
          // Si erreur, on sauvegarde quand même l'original
        }

        await VideoLogic.saveVideoToGallery(finalPathToSave);
      }

      if (Get.isSnackbarOpen) Get.closeAllSnackbars(); // Close loading
      showSnackBar('export_success'.tr, isError: false);

      // Demande de notation après un export réussi
      AppService().handleRatingRequestAfterShare();

      adMobService.showInterstitialAd(onAdClosed: () {});
    } catch (e) {
      if (Get.isSnackbarOpen) Get.closeAllSnackbars(); // Close loading
      showSnackBar('${'error_saving_videos'.tr} $e', isError: true);
      print(e);
    }
  }

  // static Future<void> exportVideos(List<File> videoParts) async {
  //   final context = Get.context;
  //   if (context == null) return;

  //   Get.dialog(
  //     const Center(child: CircularProgressIndicator()),
  //     barrierDismissible: false,
  //   );

  //   try {
  //     final adMobService = AdMobService();

  //     if (videoParts.isEmpty) {
  //       Get.back(); // Close loading
  //       Get.snackbar('error_saving_videos'.tr, 'no_video_to_save'.tr);
  //       return;
  //     }

  //     for (var video in videoParts) {
  //       await VideoLogic.saveVideoToGallery(video.path);
  //     }

  //     Get.back(); // Close loading
  //     showSnackBar('export_success'.tr, isError: false);

  //     // Demande de notation après un export réussi
  //     AppService().handleRatingRequestAfterShare();

  //     adMobService.showInterstitialAd(
  //       onAdClosed: () {},
  //     );
  //   } catch (e) {
  //     Get.back(); // Close loading
  //     showSnackBar('${'error_saving_videos'.tr} $e', isError: true);
  //     print(e);
  //   }
  // }
}
