import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_spliter/app/modules/settings/views/about_app_view.dart';
import 'package:video_spliter/app/modules/settings/views/feedbacks_view.dart';
import 'package:video_spliter/app/modules/settings/views/how_it_work_view.dart';
import 'package:video_spliter/app/modules/settings/views/contact_us_view.dart';
import 'package:video_spliter/app/services/app_service.dart';
import 'package:video_spliter/app/services/revenuecat_service.dart';
import 'package:video_spliter/app/widgets/language_selection_sheet.dart';

const String appName = 'Cutit';
const String folderName = 'Cutit';
const String introductionKey = 'introduction_key';
const String selectedLanguageKey = 'selected_language_key';

// Limites pour les vidéos uploadées
const double maxVideoSizeMb = 1000.0; // 1 Go (Pro)
const double maxVideoDurationSec = 3600.0; // 1 Heure (Pro)
const double maxVideoSizeMbFree = 100.0; // 100 Mo (Free)
const double maxVideoDurationSecFree = 600.0; // 10 Minutes (Free)
const double maxVideoSizeMbForCompress = 100.0; // 100 Mo

Future<void> launchUri(Uri parse) async {
  await launchUrl(parse);
}

final List<int> predefinedDurations = [3, 5, 10, 15, 30, 60];

var settingsGroups = [
  {
    'groupName': 'purchases'.tr,
    'items': [
      {
        'title': 'restore_purchases',
        'icon': Icons.restore,
        'onTap': () async {
          final revenueCatService = Get.find<RevenueCatService>();
          await revenueCatService.restorePurchases();
        },
      },
    ],
  },
  {
    'groupName': 'general'.tr,
    'items': [
      {
        'title': 'language',
        'icon': Icons.language,
        'onTap': () {
          showModalBottomSheet(
            context: Get.context!,
            showDragHandle: true,
            builder: (context) {
              return const LanguageSelectionSheet();
            },
          );
        },
      },
      {
        'title': 'rate_app',
        'icon': Icons.star,
        'onTap': AppService.askForRating,
      },
      {'title': 'share_app', 'icon': Icons.share, 'onTap': AppService.shareApp},
    ],
  },
  {
    'groupName': 'support_and_about'.tr,
    'items': [
      {
        'title': 'how_it_works',
        'icon': Icons.help,
        'onTap': () {
          Get.to(() => const HowItWorkView());
        },
      },
      {
        'title': 'contact_us',
        'icon': Icons.mail,
        'onTap': () {
          Get.to(() => const ContactUsView());
        },
      },
      {
        'title': 'report_issue',
        'icon': Icons.bug_report,
        'onTap': () {
          Get.to(() => const FeedbacksView());
        },
      },
      {
        'title': 'privacy_policy',
        'icon': Icons.privacy_tip,
        'onTap': () {
          final url = 'https://cutitapp.net/privacy-policy';
          launchUri(Uri.parse(url));
        },
      },
      {
        'title': 'about',
        'icon': Icons.info,
        'onTap': () {
          Get.to(() => const AboutAppView());
        },
      },
    ],
  },
];

var introductions = <Map<String, dynamic>>[
  {"title": "", "description": "welcome_cutit".tr, "image_path": "cut.png"},

  {"title": "", "description": "choose_video".tr, "image_path": "upload.png"},

  {"title": "", "description": "define_duration".tr, "image_path": "timer.png"},

  {"title": "", "description": "share_moments".tr, "image_path": "sharing.png"},

  {
    "title": "",
    "description": "allow_notifications".tr,
    "image_path": "bell.png",
  },
];
var aboutApp = "about_cutit".tr;

var languages = [
  {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
  {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
  {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
  {'code': 'pt', 'name': 'Português', 'flag': '🇵🇹'},
  {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
  // {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
  // {'code': 'it', 'name': 'Italiano', 'flag': '🇮🇹'},
  // {'code': 'nl', 'name': 'Nederlands', 'flag': '🇳🇱'},
  // {'code': 'ru', 'name': 'Русский', 'flag': '🇷🇺'},
  // {'code': 'tr', 'name': 'Türkçe', 'flag': '🇹🇷'},
  // {'code': 'zh', 'name': '中文', 'flag': '🇨🇳'},
];
