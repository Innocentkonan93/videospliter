import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:video_spliter/app/services/ad_mob_service.dart';
import 'package:video_spliter/app/services/save_segments_service.dart';
import 'package:video_spliter/app/services/video_service.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  Rx<File?> selectedVideo = Rx<File?>(null);
  RxList<File> videoParts = <File>[].obs;
  RxList<File> selectedVideoParts = <File>[].obs;
  // RxList<String> selectedFolders = <String>[].obs;
  PageController pageController = PageController();
  final Map<File, VideoPlayerController> videoControllers = {};
  RxInt currentPage = 0.obs;

  RxDouble sliceDuration = 30.0.obs;

  final canSelectVideo = false.obs;
  // final canSelectFolder = false.obs;

  final AdMobService adMobService = AdMobService();
  BannerAd? banner;
  final successfulCuts = 0.obs;
  DateTime? _pausedTime;
  final _interstitialRecentlyShown = false.obs;

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
    adMobService.loadInterstitialAd(
      onAdDismissed: () {
        update();
      },
    );
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

  void onSplitDone() {
    successfulCuts.value++;
    if (successfulCuts.value % 3 == 0) {
      adMobService.loadRewardedAd(
        onEarnedReward: () {
          successfulCuts.value = 0;
        },
      );
    }
  }

  // void selectFolder(String folder) {
  //   selectedFolders.add(folder);
  //   update();
  // }

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
    canSelectVideo.value = false;
    selectedVideo.value = null;
    videoParts.clear();
    selectedVideoParts.clear();
    // selectedFolders.clear();
    update();
  }

  @override
  void onInit() {
    banner = adMobService.loadBannerAd();
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  @override
  void onClose() {
    banner?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _pausedTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      final now = DateTime.now();
      final timeAway =
          _pausedTime != null ? now.difference(_pausedTime!).inSeconds : 0;

      if (timeAway > 30 && !_interstitialRecentlyShown.value) {
        _interstitialRecentlyShown.value = true;

        adMobService.loadInterstitialAd(
          onAdDismissed: () {
            Future.delayed(const Duration(minutes: 3), () {
              _interstitialRecentlyShown.value = false;
            });
          },
        );
      }
    }
  }
}
