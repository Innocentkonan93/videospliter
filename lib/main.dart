import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:video_spliter/app/configs/app_theme.dart';
import 'package:video_spliter/app/services/ad_mob_service.dart';
import 'package:video_spliter/firebase_options.dart';

import 'app/routes/app_pages.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: appTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdMobService().init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}
