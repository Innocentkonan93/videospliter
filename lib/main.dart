import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:video_spliter/app/configs/app_theme.dart';
import 'package:video_spliter/app/configs/caches/cache_helper.dart';
import 'package:video_spliter/app/services/ad_mob_service.dart';
import 'package:video_spliter/app/services/local_notifications_service.dart';
import 'package:video_spliter/app/services/localization.dart';
import 'package:video_spliter/app/services/sharing_service.dart';
import 'package:video_spliter/firebase_options.dart';

import 'app/routes/app_pages.dart';

bool isIntroductionViewed = false;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Cutit - Découpage de vidéos",
      initialRoute: Routes.INTRODUCTION,
      getPages: AppPages.routes,
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      // locale: const Locale('fr'),
      locale: Get.deviceLocale,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en'), const Locale('fr')],
      translations: Localization(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService().initializeNotification();
  await AdMobService().init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheHelper.init();

  // Initialiser le service de partage
  Get.put(SharingService());

  final config = ClarityConfig(
    projectId: "s204qm61cv",
    logLevel: LogLevel.None,
  );

  runApp(ClarityWidget(app: MyApp(), clarityConfig: config));
}
