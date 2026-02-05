import 'package:flutter_test/flutter_test.dart';
import 'package:video_spliter/app/utils/video_logic.dart';

void main() {
  group('Duration Calculator Tests', () {
    test(
      'calculateSegmentCount returns correct number of segments for exact division',
      () {
        // 60 seconds total, 30 seconds slice -> 2 segments
        expect(VideoLogic.calculateSegmentCount(60, 30), 2);
      },
    );

    test(
      'calculateSegmentCount returns correct number of segments for rounded up division',
      () {
        // 61 seconds total, 30 seconds slice -> 3 segments (30, 30, 1)
        expect(VideoLogic.calculateSegmentCount(61, 30), 3);
      },
    );

    test('calculateSegmentCount returns 0 if slice duration is 0', () {
      expect(VideoLogic.calculateSegmentCount(60, 0), 0);
    });

    test('calculateSegmentCount handles decimals correctly', () {
      // 10.5 seconds, 5 seconds slice -> 3 segments (5, 5, 0.5)
      expect(VideoLogic.calculateSegmentCount(10.5, 5), 3);
    });

    test('calculateSegmentCount returns 1 if video is shorter than slice', () {
      expect(VideoLogic.calculateSegmentCount(10, 30), 1);
    });
  });
}
