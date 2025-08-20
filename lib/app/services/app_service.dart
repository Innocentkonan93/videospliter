import 'dart:io';

import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';

class AppService {
  static Future<void> shareApp() async {
    final appStoreLink =
        'https://apps.apple.com/us/app/cutit-découpage-de-vidéos/id6747193487';
    final playStoreLink =
        'https://play.google.com/store/apps/details?id=com.meetsum.cutIt';

    final url = Platform.isAndroid ? playStoreLink : appStoreLink;
    await SharePlus.instance.share(
      ShareParams(title: 'share_app_title'.tr, text: 'share_app_text'.tr + url),
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
