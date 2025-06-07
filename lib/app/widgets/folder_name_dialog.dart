import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_spliter/app/configs/app_colors.dart';

class FolderNameDialog extends StatelessWidget {
  const FolderNameDialog({super.key, this.folderName});
  final String? folderName;

  @override
  Widget build(BuildContext context) {
    final name = TextEditingController();
    if (folderName != null) {
      name.text = folderName!;
    }
    return AlertDialog(
      title: Text(folderName != null ? 'Renommer le dossier' : 'Enregistrer le dossier'),
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.zero,

      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(hintText: 'Nouveau dossier'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: AppColors.white,
                    ),
                    child: const Text('Annuler'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(result: name.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                    ),
                    child: const Text('Ok'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
