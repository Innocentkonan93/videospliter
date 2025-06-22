import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_spliter/app/modules/settings/views/about_app_view.dart';
import 'package:video_spliter/app/modules/settings/views/feedbacks_view.dart';
import 'package:video_spliter/app/modules/settings/views/how_it_work_view.dart';
import 'package:video_spliter/app/modules/settings/views/contact_us_view.dart';
import 'package:video_spliter/app/services/app_service.dart';

const String appName = 'Cutit';
const String folderName = 'Cutit';
const String introductionKey = 'introduction_key';

var settings = [
  {
    'title': 'Comment ça marche ?',
    'icon': Icons.help,
    'onTap': () {
      Get.to(() => const HowItWorkView());
    },
  },
  {
    'title': 'Contactez-nous',
    'icon': Icons.mail,
    'onTap': () {
      Get.to(() => const ContactUsView());
    },
  },
  {
    'title': 'Signaler un problème',
    'icon': Icons.bug_report,
    'onTap': () {
      Get.to(() => const FeedbacksView());
    },
  },
  {
    'title': 'Note sur l\'application',
    'icon': Icons.star,
    'onTap': AppService.askForRating,
  },
  {
    'title': 'Partager l\'application',
    'icon': Icons.share,
    'onTap': AppService.shareApp,
  },
  {
    'title': 'À propos',
    'icon': Icons.info,
    'onTap': () {
      Get.to(() => const AboutAppView());
    },
  },
];

var introductions = <Map<String, dynamic>>[
  {
    "titile": "",
    "description":
        "Bienvenue sur Cutit, l’outil simple et rapide pour découper vos vidéos longues en formats courts et percutants.\nPas besoin  de créer un compte",
    "image_path": "",
  },

  {
    "titile": "",
    "description":
        "Choisissez facilement une vidéo pour la découpe depuis votre gallérie ",
    "image_path": "upload.png",
  },

  {
    "titile": "",
    "description":
        "Définissez la durée durée souhaitée, et Cutit s’occupe du découpage automatique. Rapide, fluide, efficace.",
    "image_path": "timer.png",
  },

  {
    "titile": "",
    "description":
        "Partagez facilement les meilleurs moments sur vos réseaux préférés : TikTok, Instagram, WhatsApp, YouTube Shorts… tout est prêt, au bon format.",
    "image_path": "sharing.png",
  },

  {
    "titile": "",
    "description":
        "Autorisez les notifications pour vous assurer de ne manquer aucun message",
    "image_path": "bell.png",
  },
];
var aboutApp = """
✂️ À propos de Cutit

Cutit est une application innovante qui transforme vos longues vidéos en courts segments parfaits pour les réseaux sociaux. En quelques clics, découpez automatiquement vos vidéos en segments d'une minute ou moins, idéals pour TikTok, Instagram Reels, YouTube Shorts et plus encore.

Caractéristiques principales :
• Interface simple et intuitive
• Découpage automatique intelligent
• Durée personnalisable (30 secondes par défaut)
• Export rapide et optimisé
• Compatible avec tous les formats populaires

Que vous soyez créateur de contenu ou simple utilisateur, Cutit vous fait gagner un temps précieux en automatisant le découpage de vos vidéos tout en préservant leur qualité.

Commencez dès maintenant à transformer vos longues vidéos en contenus engageants !
""";
