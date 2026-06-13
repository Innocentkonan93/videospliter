// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/controllers/home_controller.dart';
import 'package:video_spliter/app/utils/constants.dart';
import 'package:video_spliter/app/utils/responsive.dart';
import 'package:video_spliter/app/widgets/folder_item.dart';
import 'package:video_spliter/app/widgets/folder_options.dart';

class MyCutoutsView extends StatefulWidget {
  const MyCutoutsView({super.key});

  @override
  State<MyCutoutsView> createState() => _MyCutoutsViewState();
}

class _MyCutoutsViewState extends State<MyCutoutsView> {
  List<Directory> splitFolders = [];
  Map<String, int> folderItemCounts = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCutoutFolders();
  }

  Future<void> _loadCutoutFolders() async {
    print('🔍 _loadCutoutFolders');
    setState(() {
      isLoading = true;
    });

    try {
      Directory? baseDir;
      if (Platform.isAndroid) {
        final dir = await getExternalStorageDirectory();
        if (dir == null) return;
        baseDir = Directory(p.join(dir.path, appName));
      } else if (Platform.isIOS) {
        final appDocDir = await getApplicationDocumentsDirectory();
        baseDir = Directory(p.join(appDocDir.path, appName));
      } else {
        return;
      }
      if (!await baseDir.exists()) return;

      final List<Directory> validFolders = [];
      final Map<String, int> counts = {};
      await for (var entity in baseDir.list(recursive: false)) {
        if (entity is Directory) {
          final List<FileSystemEntity> files = await entity.list().toList();
          final mp4Files =
              files
                  .where(
                    (e) => e is File && e.path.toLowerCase().endsWith('.mp4'),
                  )
                  .toList();
          if (mp4Files.isNotEmpty) {
            validFolders.add(entity);
            counts[entity.path] = mp4Files.length;
          }
        }
      }

      validFolders.sort(
        (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
      );
      setState(() {
        splitFolders = validFolders;
        folderItemCounts = counts;
      });
    } catch (e) {
      print('${'error_loading_video'.tr}: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            title: Text('my_cutouts'.tr),
            leading: IconButton(
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                color: AppColors.black,
              ),
              onPressed: () {
                controller.pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                controller.clearAll();
              },
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.webp'),
                fit: BoxFit.cover,
                opacity: .2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  splitFolders.isEmpty
                      ? Center(child: Text('no_cutouts_found'.tr))
                      : GridView.builder(
                        itemCount: splitFolders.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 1.1,
                        ),
                        itemBuilder: (context, index) {
                          final folder = splitFolders[index];
                          final folderName = p.basename(folder.path);
                          final createdAt = folder.statSync().modified;
                          final itemCount = folderItemCounts[folder.path] ?? 0;
                          return FolderItem(
                            folder: folder,
                            folderName: folderName,
                            createdAt: createdAt,
                            itemCount: itemCount,
                          );
                        },
                      ),
            ),
          ),
          extendBody: true,
          bottomSheet: FolderOptions(
            onDone: () {
              print('🔍 onDone');
              _loadCutoutFolders();
              setState(() {});
            },
          ),
        );
      },
    );
  }
}
