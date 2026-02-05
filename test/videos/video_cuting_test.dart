import 'package:flutter_test/flutter_test.dart';
import 'package:video_spliter/app/utils/video_logic.dart';

void main() {
  group('Video Cutting Logic Tests', () {
    test('generateSplitArgs creates correct FFmpeg arguments', () {
      final args = VideoLogic.generateSplitArgs(
        inputPath: '/path/to/video.mp4',
        outputPath: '/path/to/output.mp4',
        startTime: 0,
        duration: 30,
      );

      // Verify essential arguments
      expect(args.contains('-ss'), true);
      expect(args[args.indexOf('-ss') + 1], '0.000'); // Start time formatted

      expect(args.contains('-t'), true);
      expect(args[args.indexOf('-t') + 1], '30.000'); // Duration formatted

      expect(args.contains('-i'), true);
      expect(args[args.indexOf('-i') + 1], '/path/to/video.mp4');

      expect(args.last, '/path/to/output.mp4');

      // Verify quality parameters are present
      expect(args.contains('-qscale:v'), true);
      expect(args[args.indexOf('-qscale:v') + 1], '5');
    });

    test('generateSplitArgs formats decimals correctly', () {
      final args = VideoLogic.generateSplitArgs(
        inputPath: 'in.mp4',
        outputPath: 'out.mp4',
        startTime: 10.123456,
        duration: 5.6789,
      );

      expect(args[args.indexOf('-ss') + 1], '10.123');
      expect(args[args.indexOf('-t') + 1], '5.679');
    });
  });

  group('Video Limits Logic Tests', () {
    test('shouldCompress returns true when size exceeds threshold', () {
      // 2MB > 1MB -> true
      expect(VideoLogic.shouldCompress(2.0, 1.0), true);
    });

    test('shouldCompress returns false when size is below threshold', () {
      // 0.5MB < 1MB -> false
      expect(VideoLogic.shouldCompress(0.5, 1.0), false);
    });

    test('shouldCompress returns false when size equals threshold', () {
      // 1MB == 1MB -> false (strictly greater check usually, let's verify logic: > )
      // Logic was: fileSizeMb > thresholdMb
      expect(VideoLogic.shouldCompress(1.0, 1.0), false);
    });
  });
}
