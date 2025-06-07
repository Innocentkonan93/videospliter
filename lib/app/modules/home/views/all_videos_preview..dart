import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_spliter/app/modules/home/views/video_player_view.dart';

class AllVideosPreview extends StatefulWidget {
  const AllVideosPreview({
    super.key,
    required this.parts,
    required this.currentIndex,
  });
  final List<File> parts;
  final int currentIndex;

  @override
  State<AllVideosPreview> createState() => _AllVideosPreviewState();
}

class _AllVideosPreviewState extends State<AllVideosPreview> {
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemCount: widget.parts.length,
      itemBuilder: (context, index) {
        return VideoPreviewView(videoFile: widget.parts[index]);
      },
    );
  }
}
