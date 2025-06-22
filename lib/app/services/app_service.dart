import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';

class AppService {
  static Future<void> shareApp() async {
    await SharePlus.instance.share(
      ShareParams(
        title: 'Découpe tes vidéos comme un pro ! 🎬✨',
        text:
            '🚀 Hey ! Je viens de découvrir Cutit, une app géniale qui découpe automatiquement les longues vidéos en petits segments parfaits pour les stories et les statuts ! Plus besoin de galérer, c\'est magique ✨ Teste-la ici : https://play.google.com/store/apps/details?id=com.cutit.app',
      ),
    );
  }

  static Future<void> askForRating() async {
    try {
      final inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      } else {
        // Fallback vers le store
        inAppReview.openStoreListing();
      }
    } catch (e) {
      print(e);
    }
  }
}
