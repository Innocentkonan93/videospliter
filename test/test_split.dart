import 'package:flutter/material.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("--- START FFMEPG TEST ---");
  try {
    final session = await FFmpegKit.execute('-version');
    final returnCode = await session.getReturnCode();
    final output = await session.getOutput();
    print("Return code: $returnCode");
    print("Output: $output");
  } catch (e, stack) {
    print("Error during FFmpeg execution: $e");
    print(stack);
  }
  print("--- END FFMEPG TEST ---");
}
