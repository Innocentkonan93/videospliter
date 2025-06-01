import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:video_spliter/app/utils/methods_utils.dart';
import 'package:video_spliter/app/services/ad_mob_service.dart';
import 'package:video_spliter/app/services/save_segments_service.dart';
import 'package:video_spliter/app/services/video_service.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  late StreamSubscription _intentDataStreamSubscription;
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
  RxDouble progress = 0.0.obs;
  final _interstitialRecentlyShown = false.obs;

  final isBannerLoaded = false.obs;

  Future<void> pickVideo() async {
    try {
      await requestPermissions();
      final result = await FilePicker.platform.pickFiles(type: FileType.video);

      if (result != null && result.files.single.path != null) {
        selectedVideo.value = File(result.files.single.path!);
      }

      update();
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  Future<List<File>?> splitVideo() async {
    if (selectedVideo.value == null) return null;

    videoParts.clear();
    final parts = await VideoService.splitBySS(
      videoFile: selectedVideo.value!,
      sliceDuration: sliceDuration.value,
    );
    videoParts.addAll(parts);
    return parts;
  }

  Future<void> saveSegments() async {
    await SaveSegmentsService.saveSegments(videoParts);
    selectedVideo.value = null;
    clearAll();
    adMobService.loadInterstitialAd(
      onAdDismissed: () {
        update();
      },
      onAdReady: () {
        adMobService.showInterstitialAd();
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
    if (selectedVideoParts.contains(part)) {
      selectedVideoParts.remove(part);
    } else {
      selectedVideoParts.add(part);
    }
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
    log(successfulCuts.value.toString());
    update();
  }

  // void selectFolder(String folder) {
  //   selectedFolders.add(folder);
  //   update();
  // }

  Future<void> requestPermissions() async {
    List<Permission> permissions = [];

    if (Platform.isAndroid) {
      permissions.add(Permission.storage);
    } else if (Platform.isIOS) {
      permissions.add(Permission.photos);
    }

    final statuses = await permissions.request();
    print(statuses);
  }

  void clearAll() {
    canSelectVideo.value = false;
    selectedVideo.value = null;
    videoParts.clear();
    selectedVideoParts.clear();
    progress.value = 0.0;
    // selectedFolders.clear();
    update();
  }

  @override
  void onInit() {
    loadBannerAd();
    initSharingListener();
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  void loadBannerAd() {
    banner = adMobService.loadBannerAd();
    isBannerLoaded.value = true;
    update();
  }

  void initSharingListener() {
    log("listening");
    // Cas 1 : App déjà en mémoire
    _intentDataStreamSubscription = FlutterSharingIntent.instance
        .getMediaStream()
        .listen(
          (List<SharedFile> files) {
            if (files.isNotEmpty) {
              handleSharedVideo(files.first);
            }
          },
          onError: (err) {
            print("Erreur de partage (stream) : $err");
          },
        );

    // Cas 2 : App lancée via partage
    FlutterSharingIntent.instance.getInitialSharing().then((
      List<SharedFile> files,
    ) {
      if (files.isNotEmpty) {
        handleSharedVideo(files.first);
      }
    });
  }

  void handleSharedVideo(SharedFile file) {
    try {
      print("📥 Vidéo reçue : ${file.value}");
      if (file.value != null) {
        selectedVideo.value = File(file.value!);
      }
      update();
      // Tu peux maintenant rediriger vers une page ou lancer le découpage automatiquement
    } catch (e) {
      print(e);
    }
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
