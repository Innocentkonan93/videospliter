class VideoLogic {
  /// Calcule le nombre de segments nécessaires pour une durée totale et une durée de découpe données.
  static int calculateSegmentCount(double totalDuration, double sliceDuration) {
    if (sliceDuration <= 0) return 0;
    return (totalDuration / sliceDuration).ceil();
  }

  /// Détermine si une vidéo doit être compressée en fonction de sa taille (en Mo) et d'une limite.
  static bool shouldCompress(double fileSizeMb, double thresholdMb) {
    return fileSizeMb > thresholdMb;
  }

  /// Génère la liste des arguments pour la commande FFmpeg de découpage.
  static List<String> generateSplitArgs({
    required String inputPath,
    required String outputPath,
    required double startTime,
    required double duration,
  }) {
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
