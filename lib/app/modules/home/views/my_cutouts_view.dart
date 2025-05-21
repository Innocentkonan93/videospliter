import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:video_spliter/app/configs/app_colors.dart';
import 'package:video_spliter/app/modules/home/controllers/home_controller.dart';
import 'package:video_spliter/app/modules/home/views/result_view.dart';
import 'package:video_spliter/app/utils/constants.dart';

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

      final List<Directory> folders =
          baseDir.listSync().whereType<Directory>().toList();

      setState(() {
        splitFolders = folders;
      });
    } catch (e) {
      print('❌ Erreur lors du chargement des dossiers : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

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
          body: Padding(
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

                        DateTime? createdAt;
                        try {
                          createdAt = folder.statSync().modified;
                        } catch (_) {
                          createdAt = null;
                        }

                        return GestureDetector(
                          onTap: () async {
                            try {
                              final List<FileSystemEntity> entities =
                                  folder.listSync();

                              final parts =
                                  entities
                                      .whereType<File>()
                                      .where(
                                        (file) => file.path
                                            .toLowerCase()
                                            .endsWith('.mp4'),
                                      )
                                      .toList();

                              if (parts.isEmpty) {
                                Get.snackbar(
                                  'Aucun fichier',
                                  'Ce dossier ne contient aucun fichier vidéo',
                                );
                                return;
                              }

                              Get.to(
                                () => ResultView(parts: parts, isSaved: true),
                              );
                            } catch (e) {
                              Get.snackbar(
                                'Erreur',
                                'Impossible d’ouvrir ce dossier : $e',
                              );
                            }
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
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                createdAt != null
                                    ? createdAt.toString()
                                    : 'Date inconnue',
                              ),
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
