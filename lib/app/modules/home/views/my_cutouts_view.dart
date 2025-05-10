import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/controllers/home_controller.dart';
import 'package:video_spliter/app/modules/home/views/result_view.dart';
import 'package:video_spliter/app/services/file_service.dart';

class MyCutoutsView extends StatefulWidget {
  const MyCutoutsView({super.key});

  @override
  State<MyCutoutsView> createState() => _MyCutoutsViewState();
}

class _MyCutoutsViewState extends State<MyCutoutsView> {
  List<Directory> splitFolders = [];

  @override
  void initState() {
    super.initState();
    _loadCutoutFolders();
  }

  Future<void> _loadCutoutFolders() async {
    Directory baseDir;

    if (Platform.isAndroid) {
      baseDir = Directory('/storage/emulated/0/Download/VideoSpliter');
    } else if (Platform.isIOS) {
      final appDocDir = await getApplicationDocumentsDirectory();
      baseDir = Directory(p.join(appDocDir.path, 'VideoSpliter'));
    } else {
      return; // plateforme non supportée
    }

    if (!await baseDir.exists()) return;

    final List<Directory> folders =
        baseDir.listSync().whereType<Directory>().toList();

    setState(() {
      splitFolders = folders;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Mes découpages'),
            actions: [
              if (controller.selectedFolders.isNotEmpty)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    switch (value) {
                      case 'delete_all':
                        FileService.deleteFolders(controller.selectedFolders);
                        break;
                      case 'refresh':
                        _loadCutoutFolders();
                        break;
                    }
                  },
                  itemBuilder:
                      (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'delete_all',
                          child: Text('Tout supprimer'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'refresh',
                          child: Text('Actualiser'),
                        ),
                      ],
                ),
            ],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                controller.pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                controller.selectedFolders.value = [];
                controller.canSelectFolder.value = false;
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                splitFolders.isEmpty
                    ? const Center(child: Text('Aucun découpage trouvé.'))
                    : GridView.builder(
                      itemCount: splitFolders.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // ou 3
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
                            if (controller.canSelectFolder.value) {
                              controller.selectFolder(folderName);
                              controller.update();
                            } else {
                              // 🔁 Lire les fichiers mp4 dans le dossier
                              final List<FileSystemEntity> entities =
                                  folder.listSync();
                              final parts =
                                  entities
                                      .whereType<File>()
                                      .where(
                                        (file) => file.path.endsWith('.mp4'),
                                      )
                                      .map((f) => File(f.path))
                                      .toList();

                              if (parts.isEmpty) {
                                Get.snackbar(
                                  'Aucun fichier',
                                  'Ce dossier est vide',
                                );
                                return;
                              }

                              // 🧭 Naviguer vers la vue de résultat avec les fichiers
                              Get.to(
                                () => ResultView(parts: parts, isSaved: true),
                              );
                            }
                          },
                          onLongPress: () {
                            controller.canSelectFolder.value = true;
                            controller.update();
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: SizedBox.expand(
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.asset(
                                        'assets/images/folder.png',
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        bottom: 30,
                                        left: 30,
                                        child: Text(
                                          folderName,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: AppColors.white,
                                              ),
                                        ),
                                      ),
                                      if (controller.canSelectFolder.value)
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(
                                            controller.selectedFolders.contains(
                                                  folderName,
                                                )
                                                ? Icons.check_circle
                                                : Icons.circle_outlined,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(createdAt.toString()),
                            ],
                          ),
                        );
                      },
                    ),
          ),
        );
      },
    );
  }
}
