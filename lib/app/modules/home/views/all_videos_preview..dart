import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_spliter/app/modules/home/views/video_player_view.dart';

class AllVideosPreview extends StatelessWidget {
  const AllVideosPreview({super.key, required this.parts});
  final List<File> parts;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: parts.length,
      itemBuilder: (context, index) {
        return VideoPreviewView(videoFile: parts[index]);
      },
    );
  }
}
