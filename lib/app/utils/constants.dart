import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_spliter/app/modules/settings/views/about_app_view.dart';
import 'package:video_spliter/app/modules/settings/views/feedbacks_view.dart';
import 'package:video_spliter/app/modules/settings/views/how_it_work_view.dart';
import 'package:video_spliter/app/modules/settings/views/contact_us_view.dart';
import 'package:video_spliter/app/services/app_service.dart';
import 'package:video_spliter/app/services/revenuecat_service.dart';
import 'package:video_spliter/app/services/update_service.dart';
import 'package:video_spliter/app/widgets/language_selection_sheet.dart';
import 'package:video_spliter/app/modules/settings/controllers/settings_controller.dart';

const String appName = 'Cutit';
const String folderName = 'Cutit';
const String introductionKey = 'introduction_key';
const String selectedLanguageKey = 'selected_language_key';

// Limites pour les vidéos uploadées
const double maxVideoSizeMb = 1536.0; // 1.5 Go (Pro)
const double maxVideoDurationSec = 3600.0; // 1 Heure (Pro)
const double maxVideoSizeMbFree = 150.0; // 150 Mo (Free)
const double maxVideoDurationSecFree = 600.0; // 10 Minutes (Free)
const double maxVideoSizeMbForCompress = 100.0; // 100 Mo

Future<void> launchUri(Uri parse) async {
  await launchUrl(parse);
}

final List<int> predefinedDurations = [3, 5, 10, 15, 30, 60];

var settingsGroups = [
  {
    'groupName': 'purchases',
    'items': [
      {
        'title': 'restore_purchases',
        'icon': HugeIcons.strokeRoundedArchiveRestore,
        'onTap': () async {
          final revenueCatService = Get.find<RevenueCatService>();
          await revenueCatService.restorePurchases();
        },
      },
    ],
  },
  {
    'groupName': 'general',
    'items': [
      {
        'title': 'language',
        'icon': HugeIcons.strokeRoundedLanguageSkill,
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
        'title': 'update_check',
        'icon': HugeIcons.strokeRoundedDownload04,
        'onTap': () {
          Get.find<UpdateService>().checkForUpdates(showNoUpdateDialog: true);
        },
      },
      {
        'title': 'rate_app',
        'icon': HugeIcons.strokeRoundedStar,
        'onTap': AppService.askForRating,
      },
      {
        'title': 'share_app',
        'icon': HugeIcons.strokeRoundedShare01,
        'onTap': AppService.shareApp,
      },
      {
        'title': 'clean_cache',
        'icon': HugeIcons.strokeRoundedDelete01,
        'onTap': () {
          Get.find<SettingsController>().cleanCache();
        },
      },
    ],
  },
  {
    'groupName': 'support_and_about',
    'items': [
      {
        'title': 'how_it_works',
        'icon': HugeIcons.strokeRoundedHelpCircle,
        'onTap': () {
          Get.to(() => const HowItWorkView());
        },
      },
      {
        'title': 'contact_us',
        'icon': HugeIcons.strokeRoundedMail01,
        'onTap': () {
          Get.to(() => const ContactUsView());
        },
      },
      {
        'title': 'report_issue',
        'icon': HugeIcons.strokeRoundedBug01,
        'onTap': () {
          Get.to(() => const FeedbacksView());
        },
      },
      {
        'title': 'terms_of_use',
        'icon': HugeIcons.strokeRoundedFile01,
        'onTap': () {
          final url = 'https://cutitapp.net/terms';
          launchUri(Uri.parse(url));
        },
      },
      {
        'title': 'privacy_policy',
        'icon': HugeIcons.strokeRoundedSecurityCheck,
        'onTap': () {
          final url = 'https://cutitapp.net/privacy-policy';
          launchUri(Uri.parse(url));
        },
      },
      {
        'title': 'about',
        'icon': HugeIcons.strokeRoundedInformationCircle,
        'onTap': () {
          Get.to(() => const AboutAppView());
        },
      },
    ],
  },
];

var introductions = <Map<String, dynamic>>[
  {
    "title": "intro_title_2".tr,
    "description": "intro_desc_2".tr,
    "image_path": "image0.webp",
  },
  {
    "title": "intro_title_3".tr,
    "description": "intro_desc_3".tr,
    "image_path": "image3.webp",
  },
  {
    "title": "intro_title_export".tr,
    "description": "intro_desc_export".tr,
    "image_path": "image6.webp",
  },
  {
    "title": "intro_title_4".tr,
    "description": "intro_desc_4".tr,
    "image_path": "image4.webp",
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

var socialMedia = <Map<String, dynamic>>[
  {
    'name': 'Facebook',
    'icon': HugeIcons.strokeRoundedFacebook01,
    'duration': 60.0,
    'color': const Color(0xFF1877F2),
  },
  {
    'name': 'Instagram',
    'icon': HugeIcons.strokeRoundedInstagram,
    'duration': 60.0,
    'color': const Color(0xFFE1306C),
  },
  {
    'name': 'Tiktok',
    'icon': HugeIcons.strokeRoundedTiktok,
    'duration': 15.0,
    'color': const Color(0xFF000000),
  },
  {
    'name': 'Whatsapp',
    'icon': HugeIcons.strokeRoundedWhatsapp,
    'duration': 60.0,
    'color': const Color(0xFF25D366),
  },
];
