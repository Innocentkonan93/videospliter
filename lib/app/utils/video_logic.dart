import 'package:gal/gal.dart';

class VideoLogic {
  /// Sauvegarde une vidéo dans la galerie.
  /// Retourne true si succès, false sinon.
  static Future<bool> saveVideoToGallery(String videoPath) async {
    try {
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        await Gal.requestAccess();
      }
      await Gal.putVideo(videoPath);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Calcule le nombre de segments nécessaires pour une durée totale et une durée de découpe données.
  static int calculateSegmentCount(double totalDuration, double sliceDuration) {
    if (sliceDuration <= 0) return 0;
    return (totalDuration / sliceDuration).ceil();
  }

  /// Détermine si une vidéo doit être compressée en fonction de sa taille (en Mo) et d'une limite.
  static bool shouldCompress(double fileSizeMb, double thresholdMb) {
    return fileSizeMb > thresholdMb;
  }

  /// Vérifie si la taille de la vidéo est dans la limite acceptée
  static bool isFileSizeValid(double fileSizeMb, double limitMb) {
    return fileSizeMb <= limitMb;
  }

  /// Vérifie si la durée de la vidéo est dans la limite acceptée
  static bool isDurationValid(double durationSec, double limitSec) {
    return durationSec <= limitSec;
  }

  /// Génère la liste des arguments pour la commande FFmpeg de découpage.
  static List<String> generateSplitArgs({
    required String inputPath,
    required String outputPath,
    required double startTime,
    required double duration,
    required bool isPro,
    String? watermarkPath,
    int? watermarkWidth,
    int? watermarkHeight,
  }) {
    if (isPro == false &&
        watermarkPath != null &&
        watermarkWidth != null &&
        watermarkHeight != null) {
      return [
        '-ss',
        startTime.toStringAsFixed(3),
        '-t',
        duration.toStringAsFixed(3),
        '-i',
        inputPath,
        '-f',
        'rawvideo',
        '-pix_fmt',
        'rgba',
        '-s',
        '${watermarkWidth}x$watermarkHeight',
        '-i',
        watermarkPath,
        '-filter_complex',
        // crop the input, scale the watermark to reasonable size (e.g. 50px width), overlay in bottom left corner (15px margin)
        "[0:v]crop='floor(in_w/2)*2:floor(in_h/2)*2'[base];"
            "[1:v]scale=50:-2[wm];"
            "[base][wm]overlay=15:H-h-15",
        '-pix_fmt',
        'yuv420p',
        '-c:v',
        'mpeg4',
        '-qscale:v',
        '5',
        '-c:a',
        'aac',
        '-b:a',
        '128k',
        '-movflags',
        '+faststart',
        '-y',
        outputPath,
      ];
    } else {
      return [
        '-ss',
        startTime.toStringAsFixed(3),
        '-t',
        duration.toStringAsFixed(3),
        '-i',
        inputPath,
        '-vf',
        "crop='floor(in_w/2)*2:floor(in_h/2)*2'",
        '-c:v',
        'mpeg4',
        '-qscale:v',
        '5',
        '-c:a',
        'aac',
        '-b:a',
        '128k',
        '-movflags',
        '+faststart',
        '-y',
        outputPath,
      ];
    }
  }
}
