import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:video_spliter/app/configs/app_theme.dart';

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
    );
  }
}

void main() async {
  runApp(MyApp());
}
