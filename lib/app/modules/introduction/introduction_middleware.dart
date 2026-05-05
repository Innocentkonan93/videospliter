import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_spliter/app/configs/caches/cache_helper.dart';
import 'package:video_spliter/app/routes/app_pages.dart';
import 'package:video_spliter/app/utils/constants.dart';

class IntroductionMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Vérification directe dans SharedPreferences déjà initialisé dans main.dart
    final bool isViewed =
        CacheHelper.sharedPreferences.getBool(introductionKey) ?? false;

    if (isViewed) {
      return const RouteSettings(name: Routes.HOME);
    }
    return null;
  }
}
