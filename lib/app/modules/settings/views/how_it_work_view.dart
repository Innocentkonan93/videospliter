import 'package:flutter/material.dart';
import 'package:video_spliter/app/configs/app_colors.dart';

class HowItWorkView extends StatelessWidget {
  const HowItWorkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Comment ça marche ?"),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bienvenue sur Cutit !",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildStep(
              "1. Sélectionnez une vidéo",
              "Choisissez une vidéo depuis votre galerie ou partagez-la directement depuis une autre application.",
              Icons.video_library,
            ),
            _buildStep(
              "2. Ajustez la durée",
              "Définissez la durée souhaitée pour chaque segment (par défaut 30 secondes).",
              Icons.timer,
            ),
            _buildStep(
              "3. Découpez automatiquement",
              "L'application découpe automatiquement votre vidéo en segments de la durée choisie.",
              Icons.cut,
            ),
            _buildStep(
              "4. Sélectionnez et sauvegardez",
              "Choisissez les segments à conserver et enregistrez-les dans votre galerie.",
              Icons.save,
            ),
            // social sharing
            _buildStep(
              "5. Partagez sur les réseaux sociaux",
              "Publiez facilement vos segments en stories, statuts ou posts sur vos réseaux sociaux préférés.",
              Icons.share,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Astuce !",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Vous pouvez également partager directement une vidéo depuis une autre application vers Cutit pour la découper instantanément !",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
