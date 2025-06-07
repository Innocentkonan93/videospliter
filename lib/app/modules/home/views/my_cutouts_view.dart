import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/controllers/home_controller.dart';
import 'package:video_spliter/app/modules/home/views/result_view.dart';
import 'package:video_spliter/app/services/file_service.dart';
import 'package:video_spliter/app/utils/constants.dart';
// import 'package:video_spliter/app/utils/constants.dart';

class MyCutoutsView extends StatefulWidget {
  const MyCutoutsView({super.key});

  @override
  State<MyCutoutsView> createState() => _MyCutoutsViewState();
}

class _MyCutoutsViewState extends State<MyCutoutsView> {
  List<Directory> splitFolders = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCutoutFolders();
  }

  Future<void> _loadCutoutFolders() async {
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
        return; // plateforme non supportée
      }

      if (!await baseDir.exists()) return;

      final List<Directory> validFolders = [];

      await for (var entity in baseDir.list(recursive: false)) {
        if (entity is Directory) {
          final List<FileSystemEntity> files = await entity.list().toList();
          final hasMp4 = files.any(
            (e) => e is File && e.path.toLowerCase().endsWith('.mp4'),
          );

          if (hasMp4) {
            validFolders.add(entity);
          }
        }
      }

      validFolders.sort(
        (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
      );

      setState(() {
        splitFolders = validFolders;
      });
    } catch (e) {
      print('❌ Erreur lors du chargement des dossiers : $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // _loadCutoutFolders();
    final theme = context.theme;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            title: const Text('Mes découpages'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
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
                image: AssetImage('assets/images/bg.png'),
                fit: BoxFit.cover,
                opacity: .2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  splitFolders.isEmpty
                      ? const Center(child: Text('Aucun découpage trouvé.'))
                      : GridView.builder(
                        itemCount: splitFolders.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: 1,
                            ),
                        itemBuilder: (context, index) {
                          final folder = splitFolders[index];
                          final folderName = p.basename(folder.path);
                          final createdAt = folder.statSync().modified;
                          return GestureDetector(
                            onTap: () async {
                              final List<File> parts = [];
                              try {
                                await for (var entity in folder.list(
                                  recursive: false,
                                  followLinks: false,
                                )) {
                                  if (entity is File &&
                                      entity.path.endsWith('.mp4')) {
                                    parts.add(entity);
                                  }
                                }

                                if (parts.isEmpty) {
                                  Get.snackbar(
                                    'Aucun fichier',
                                    'Ce dossier est vide',
                                  );
                                  return;
                                }

                                Get.to(
                                  () => ResultView(parts: parts, isSaved: true),
                                );
                              } catch (e) {
                                log(
                                  "Erreur lors de la lecture du dossier : $e",
                                );
                                Get.snackbar(
                                  'Erreur',
                                  'Impossible de lire le dossier',
                                );
                              }
                            },
                            child: Container(
                              decoration:
                                  controller.selectedFolder.value == folderName
                                      ? BoxDecoration(
                                        color: AppColors.grey.withValues(
                                          alpha: .2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      )
                                      : null,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: SizedBox.expand(
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    'assets/images/folder.png',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 30,
                                            left: 20,
                                            child: Text(
                                              DateFormat(
                                                'dd.MM.yyyy',
                                              ).format(createdAt),
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color: AppColors.white
                                                        .withValues(alpha: .25),
                                                  ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            left: 10,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    folderName.split('-').first,
                                                    style: theme
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    // showModalBottomSheet(
                                                    //   context: context,
                                                    //   showDragHandle: true,
                                                    //   builder: (context) {
                                                    //     return FolderOptionsSheet(
                                                    //       onDone: () {
                                                    //         _loadCutoutFolders();
                                                    //       },
                                                    //       folderName: folderName,
                                                    //     );
                                                    //   },
                                                    // );

                                                    controller
                                                        .showFolderOptions(
                                                          folderName,
                                                        );
                                                  },
                                                  child: Icon(
                                                    CupertinoIcons
                                                        .ellipsis_circle,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ),
          extendBody: true,
          bottomSheet: Obx(() {
            final folderName = controller.selectedFolder.value;
            return controller.selectedFolder.value.isNotEmpty
                ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            controller.selectedFolder.value = "";
                            await controller.renameFolder(folderName);
                            controller.selectedFolder.value = "";
                            _loadCutoutFolders();
                            controller.update();
                          },
                          icon: Icon(CupertinoIcons.pencil),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.black,
                            foregroundColor: AppColors.white,
                          ),
                          label: Text("Renommer"),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () async {
                            controller.selectedFolder.value = "";
                            await FileService.deleteFolders([folderName]);
                            controller.selectedFolder.value = "";
                            _loadCutoutFolders();
                            controller.update();
                          },
                          icon: Icon(CupertinoIcons.trash),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                            foregroundColor: AppColors.white,
                          ),
                          label: Text("Supprimer"),
                        ),
                      ],
                    ),
                  ),
                ).animate().slideY(duration: 100.ms, begin: 1.0, end: 0.0)
                : SizedBox();
          }),
        );
      },
    );
  }
}

class FolderOptionsSheet extends GetView<HomeController> {
  const FolderOptionsSheet({super.key, this.onDone, required this.folderName});

  final VoidCallback? onDone;
  final String folderName;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(CupertinoIcons.pencil),
              title: Text('Renommer', style: theme.textTheme.bodyMedium),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: AppColors.black),
              ),
              onTap: () async {
                Get.back();
                await controller.renameFolder(folderName);
                onDone?.call();
              },
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(CupertinoIcons.trash, color: AppColors.white),
              tileColor: AppColors.red,
              title: Text(
                'Supprimer',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () async {
                await FileService.deleteFolders([folderName]);
                onDone?.call();
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
