import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:video_spliter/app/utils/video_logic.dart';

class ParallelVideoService {
  static Future<List<File>> splitBySSParallelAsync({
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
    final info = probeSession.getMediaInformation();
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

    final List<File?> videoPartsArray = List.filled(totalSegments, null);
    final List<double> segmentProgresses = List.filled(totalSegments, 0.0);

    int activeTasks = 0;
    int currentIndex = 0;
    final int maxConcurrentTasks = 3;
    final completer = Completer<void>();
    bool hasError = false;

    void updateGlobalProgress() {
      if (hasError) return;
      double sum = segmentProgresses.reduce((a, b) => a + b);
      double globalProgress = (sum / totalSegments).clamp(0.0, 1.0);
      onProgress?.call(globalProgress);
    }

    void startNextTask() {
      if (hasError) return;

      if (currentIndex >= totalSegments) {
        if (activeTasks == 0 && !completer.isCompleted) {
          completer.complete();
        }
        return;
      }

      while (activeTasks < maxConcurrentTasks && currentIndex < totalSegments) {
        final taskIndex = currentIndex;
        currentIndex++;
        activeTasks++;

        _runSegmentTask(
              taskIndex: taskIndex,
              videoFile: videoFile,
              tempDir: tempDir,
              fileBase: fileBase,
              sliceDuration: sliceDuration,
              totalDuration: totalDuration,
              isPro: isPro,
              watermarkTempPath: watermarkTempPath,
              watermarkWidth: watermarkWidth,
              watermarkHeight: watermarkHeight,
              onSegmentProgress: (progress) {
                segmentProgresses[taskIndex] = progress;
                updateGlobalProgress();
                onSegmentProgress?.call(taskIndex, progress);
              },
            )
            .then((file) {
              if (hasError) return;
              segmentProgresses[taskIndex] = 1.0;
              updateGlobalProgress();
              videoPartsArray[taskIndex] = file;
              if (file != null) {
                onSegmentComplete?.call(taskIndex, file);
              }
              activeTasks--;
              startNextTask();
              // log(file?.path.toString() ?? 'No path');
            })
            .catchError((e) {
              if (!hasError) {
                hasError = true;
                FFmpegKit.cancel(); // Cancel all remaining tasks globally
                if (!completer.isCompleted) {
                  completer.completeError(e);
                }
              }
            });
      }
    }

    startNextTask();

    // Attendre que tout soit fini ou qu'une erreur survienne
    await completer.future;
    for (var element in videoPartsArray) {
      log(element?.path ?? 'No path');
    }
    // Filtrer les valeurs nulles d'abord pour éviter une erreur de type "Null check operator on null value" au runtime
    final orderedParts = videoPartsArray.whereType<File>().toList();
    orderedParts.sort((a, b) => a.path.compareTo(b.path));
    return orderedParts;
  }

  static Future<File?> _runSegmentTask({
    required int taskIndex,
    required File videoFile,
    required Directory tempDir,
    required String fileBase,
    required double sliceDuration,
    required double totalDuration,
    required bool isPro,
    required String? watermarkTempPath,
    required int? watermarkWidth,
    required int? watermarkHeight,
    required void Function(double) onSegmentProgress,
  }) async {
    final start = taskIndex * sliceDuration;
    final isLast = (start + sliceDuration) > totalDuration;
    final segDur = isLast ? (totalDuration - start) : sliceDuration;

    if (segDur < 1.0) {
      log('Skipping micro-segment: duration $segDur is too short.');
      return null;
    }

    final outPath = p.join(
      tempDir.path,
      '${fileBase}_part_${(taskIndex + 1).toString().padLeft(3, '0')}.mp4',
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

    final segCompleter = Completer<File?>();

    await FFmpegKit.executeWithArgumentsAsync(
      args,
      (session) async {
        final rc = await session.getReturnCode();
        if (ReturnCode.isSuccess(rc)) {
          final file = File(outPath);
          if (await file.exists() && await file.length() > 0) {
            segCompleter.complete(file);
          } else {
            segCompleter.complete(null);
          }
        } else if (ReturnCode.isCancel(rc)) {
          segCompleter.completeError(Exception('Opération annulée'));
        } else {
          final logs = await session.getAllLogsAsString();
          final logsLines = logs?.split('\n') ?? [];
          final lastLogs =
              logsLines.length > 20
                  ? logsLines.sublist(logsLines.length - 20).join('\n')
                  : logs;
          segCompleter.completeError(
            Exception(
              'Erreur FFmpeg sur le segment ${taskIndex + 1}\n$lastLogs',
            ),
          );
        }
      },
      (logMsg) {},
      (stats) {
        final tMs = stats.getTime(); // ms encodées dans ce segment
        final segProgress = (tMs / 1000.0) / (segDur <= 0 ? 1 : segDur);
        onSegmentProgress(segProgress.clamp(0.0, 1.0));
      },
    );

    return segCompleter.future;
  }
}
