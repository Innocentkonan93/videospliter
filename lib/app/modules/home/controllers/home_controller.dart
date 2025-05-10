import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:video_spliter/app/services/save_segments_service.dart';
import 'package:video_spliter/app/services/video_service.dart';

class HomeController extends GetxController {
  Rx<File?> selectedVideo = Rx<File?>(null);
  RxList<File> videoParts = <File>[].obs;
  RxList<File> selectedVideoParts = <File>[].obs;
  RxList<String> selectedFolders = <String>[].obs;
  PageController pageController = PageController();
  final Map<File, VideoPlayerController> videoControllers = {};
  RxInt currentPage = 0.obs;

  RxDouble sliceDuration = 30.0.obs;

  final canSelectVideo = false.obs;
  final canSelectFolder = false.obs;

  Future<void> pickVideo() async {
    await requestPermissions();
    final result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null && result.files.single.path != null) {
      selectedVideo.value = File(result.files.single.path!);
    }

    update();
  }

  Future<void> splitVideo() async {
    if (selectedVideo.value == null) return;

    videoParts.clear();
    final parts = await VideoService.splitBySS(
      videoFile: selectedVideo.value!,
      sliceDuration: sliceDuration.value,
    );
    videoParts.addAll(parts);
  }

  Future<void> saveSegments() async {
    await SaveSegmentsService.saveSegments(videoParts);
    selectedVideo.value = null;
    videoParts.clear();
    update();
  }

  Future<void> initVideoControllers(List<File> parts) async {
    for (final file in parts) {
      if (!videoControllers.containsKey(file)) {
        final controller = VideoPlayerController.file(file);
        await controller.initialize();
        videoControllers[file] = controller;
      }
    }
    update();
  }

  Future<void> disposeVideoControllers() async {
    for (final controller in videoControllers.values) {
      await controller.dispose();
    }
    videoControllers.clear();
  }

  void selectVideoPart(File part) {
    selectedVideoParts.add(part);
    update();
  }

  void selectFolder(String folder) {
    selectedFolders.add(folder);
    update();
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses =
        await [
          Permission.storage,
          Permission.videos,
          Permission.manageExternalStorage,
        ].request();

    print(statuses);
  }

  void clearAll() {
    selectedVideo.value = null;
    videoParts.clear();
    selectedVideoParts.clear();
    selectedFolders.clear();
    update();
  }
}
