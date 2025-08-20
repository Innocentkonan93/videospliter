import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_spliter/app/modules/settings/views/about_app_view.dart';
import 'package:video_spliter/app/modules/settings/views/feedbacks_view.dart';
import 'package:video_spliter/app/modules/settings/views/how_it_work_view.dart';
import 'package:video_spliter/app/modules/settings/views/contact_us_view.dart';
import 'package:video_spliter/app/services/app_service.dart';
import 'package:video_spliter/app/widgets/language_selection_sheet.dart';

const String appName = 'Cutit';
const String folderName = 'Cutit';
const String introductionKey = 'introduction_key';

Future<void> launchUri(Uri parse) async {
  await launchUrl(parse);
}

var settings = [
  {
    'title': 'how_it_works'.tr,
    'icon': Icons.help,
    'onTap': () {
      Get.to(() => const HowItWorkView());
    },
  },
  {
    'title': 'contact_us'.tr,
    'icon': Icons.mail,
    'onTap': () {
      Get.to(() => const ContactUsView());
    },
  },
  {
    'title': 'report_issue'.tr,
    'icon': Icons.bug_report,
    'onTap': () {
      Get.to(() => const FeedbacksView());
    },
  },
  {
    'title': 'rate_app'.tr,
    'icon': Icons.star,
    'onTap': AppService.askForRating,
  },
  {'title': 'share_app'.tr, 'icon': Icons.share, 'onTap': AppService.shareApp},
  {
    'title': 'language'.tr,
    'icon': Icons.language,
    'onTap': () {
      showModalBottomSheet(
        context: Get.context!,
        builder: (context) {
          return const LanguageSelectionSheet();
        },
      );
    },
  },
  {
    'title': 'privacy_policy'.tr,
    'icon': Icons.privacy_tip,
    'onTap': () {
      final url = 'https://cutitapp.net/privacy-policy';
      launchUri(Uri.parse(url));
    },
  },
  {
    'title': 'about'.tr,
    'icon': Icons.info,
    'onTap': () {
      Get.to(() => const AboutAppView());
    },
  },
];

var introductions = <Map<String, dynamic>>[
  {"title": "", "description": "welcome_cutit".tr, "image_path": ""},

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
