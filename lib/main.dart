import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:video_spliter/app/configs/app_theme.dart';
import 'package:video_spliter/app/configs/caches/cache_helper.dart';
import 'package:video_spliter/app/services/ad_mob_service.dart';
import 'package:video_spliter/app/services/analytics_service.dart';
import 'package:video_spliter/app/services/app_service.dart';
import 'package:video_spliter/app/services/local_notifications_service.dart';
import 'package:video_spliter/app/services/localization.dart';
import 'package:video_spliter/app/services/sharing_service.dart';
import 'package:video_spliter/app/services/revenuecat_service.dart';
import 'package:video_spliter/app/services/firebase_notification_service.dart';
import 'package:video_spliter/app/services/update_service.dart';
import 'package:video_spliter/app/utils/constants.dart';
import 'package:video_spliter/firebase_options.dart';

import 'package:video_spliter/app/services/file_service.dart';
import 'package:video_spliter/app/services/config_service.dart';
import 'app/routes/app_pages.dart';

bool isIntroductionViewed = false;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheHelper.init();

  // Nettoyage asynchrone des fichiers temporaires obsolètes au démarrage
  FileService.cleanTemporaryFiles();

  // Initialiser le service de configuration (Feature Flags)
  // Requis pour savoir si on doit charger les pubs ou les fonctions pro
  await Get.putAsync(() => ConfigService().init());

  // Initialize RevenueCat service for subscriptions
  await Get.putAsync(() => RevenueCatService().init());

  // Initialize Firebase Cloud Messaging notifications
  await Get.putAsync(() => FirebaseNotificationService().init());

  // Initialize Update service
  await Get.putAsync(() => UpdateService().init());

  await LocalNotificationService().initializeNotification();
  await AdMobService().init();

  // Charger la langue sauvegardée depuis le cache
  try {
    final savedLanguage = await CacheHelper.getString(key: selectedLanguageKey);
    if (savedLanguage.isNotEmpty) {
      Get.updateLocale(Locale(savedLanguage));
    } else {
      Get.updateLocale(Get.deviceLocale ?? const Locale('en'));
    }
  } catch (e) {
    // En cas d'erreur, utiliser la langue par défaut du système
    // ignore: avoid_print
    print('Erreur lors du chargement de la langue sauvegardée: $e');
  }

  // Initialiser le service analytics
  await AnalyticsService.initialize();

  // Initialiser le service de partage
  Get.put(SharingService());
  final config = ClarityConfig(
    projectId: "s204qm61cv",
    logLevel: LogLevel.None,
  );

  FlutterNativeSplash.remove();

  runApp(ClarityWidget(app: MyApp(), clarityConfig: config));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateService.to.checkForUpdates();
      AppService().handleRatingRequestOnLaunch();
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Cutit - Découpage de vidéos",
      initialRoute: Routes.INTRODUCTION,
      getPages: AppPages.routes,
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      locale: Get.locale ?? Get.deviceLocale,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('fr'),
        const Locale('es'),
        const Locale('pt'),
        const Locale('ar'),
      ],
      translations: Localization(),
    );
  }
}
