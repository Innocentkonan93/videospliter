import 'package:get/get.dart';

class Localization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      // App name and general
      'app_name': 'Cutit',
      'folder_name': 'Cutit',

      // Introduction screens
      'skip': 'Skip',
      'later': 'Later',
      'welcome_cutit':
          'Welcome to Cutit\nThe simple and fast tool to cut your long videos into short and impactful formats.\nNo need to create an account',
      'choose_video': 'Easily choose a video to cut from your gallery',
      'define_duration':
          'Define the desired duration, and Cutit takes care of automatic cutting. Fast, smooth, efficient.',
      'share_moments':
          'Easily share the best moments on your favorite networks: TikTok, Instagram, WhatsApp, YouTube Shorts... everything is ready, in the right format.',
      'allow_notifications':
          'Allow notifications to ensure you don\'t miss any message',
      'permission_denied_to_receive_notifications':
          'Permission denied to receive notifications',
      'allow': 'Allow',
      'intro_title_1': 'No account. Zero setup.',
      'intro_desc_1':
          'Open the app, select your video, and start splitting immediately. Your privacy is 100% respected.',
      'intro_title_2': '1-Click Auto-Splitting.',
      'intro_desc_2':
          'Choose your social network presets or set a custom duration. The app handles the rest in seconds.',
      'intro_title_3': 'Save & Share Instantly',
      'intro_desc_3':
          'Save clips directly to your gallery or share them in one click to all your social platforms.',
      'intro_title_4': 'Stay Notified',
      'intro_desc_4':
          'Enable notifications to know exactly when your video is fully processed, even in the background.',

      // Home screen
      'cut_share_save': 'Cut, share and save your videos in a few clicks',
      'load_video': 'Load a video',
      'select_video': 'Select a video',
      'cut_video': 'Cut video',
      'my_cutouts': 'My cutouts',
      'no_cutouts_found': 'No cutouts found.',

      // Processing screen
      'cutting_in_progress': '✂️ Cutting in progress... don\'t leave the app.',
      'no_manual_cutting': '🔪 No more need to manually cut your videos.',
      'share_easily': '📱 Share long videos more easily in several parts.',
      'transform_video':
          '🎯 Transform a video into several statuses in one click.',
      'ideal_for_stories':
          '📸 Ideal for stories, WhatsApp statuses and your YouTube shorts.',
      'videos_become_simple': '🚀 Your long videos become simple to publish.',
      'create_automatically':
          '⏱️ Automatically create 10, 30, 60 second excerpts.',
      'use_cutit_like_pro': '🎬 Use cutit to cut your videos like a pro',
      'cut_done_title': 'Cutting done 💯',
      'cut_done_body': 'You can share or save it',
      'cut_done_notification': 'Cutting done, you can share or save it',
      'error_cutting':
          '❌ Unable to cut this video\n👉 Ensure the video is stored on your phone\n🔁 Try again with a shorter video',

      // Result screen
      'clips_selected': 'clips selected',
      'clip_selected': 'clip selected',
      'select': 'Select',
      'cutting_results': 'Cutting results',
      'preview': 'Preview',
      'segment': 'Part',
      'segments_timeline': 'Segments Timeline',
      'share': 'Share',
      'save': 'Save',
      'no_video_selected':
          'No video selected. Please select at least one video',
      'duration': 'Duration',
      'size': 'Size',

      // Settings
      'settings': 'Settings',
      'purchases': 'Purchases',
      'restore_purchases': 'Restore Purchases',
      'no_active_subscription': 'No active subscription found to restore.',
      'purchases_restored': 'Purchases restored successfully.',
      'general': 'General',
      'support_and_about': 'Support & About',
      'how_it_works': 'How it works?',
      'contact_us': 'Contact us',
      'report_issue': 'Report an issue',
      'rate_app': 'Rate the app',
      'share_app': 'Share the app',
      'about': 'About',
      'language': 'Language',
      'privacy_policy': 'Privacy policy',
      'terms_of_use': 'Terms of use',

      // How it works
      'welcome_cutit_title': 'Welcome to Cutit!',
      'step1_title': '1. Select a video',
      'step1_desc':
          'Choose a video from your gallery or share it directly from another app.',
      'step2_title': '2. Adjust duration',
      'step2_desc':
          'Set the desired duration for each segment (30 seconds by default).',
      'step3_title': '3. Cut automatically',
      'step3_desc':
          'The app automatically cuts your video into segments of the chosen duration.',
      'step4_title': '4. Select and save',
      'step4_desc':
          'Choose the segments to keep and save them in your gallery.',
      'step5_title': '5. Share on social networks',
      'step5_desc':
          'Share your segments on TikTok, Instagram, WhatsApp and more.',
      'step_tip':
          'You can also share a video directly from your gallery to Cutit to cut it instantly!',
      'tip': '💡Tip !',
      // Contact us
      'question_problem': 'A question? A problem?',
      'contact_description':
          'Don\'t hesitate to contact us, we will respond as soon as possible.',
      'send_email': 'Send an email',

      // About app
      'about_cutit':
          '✂️ About Cutit\n\nCutit is an innovative app that transforms your long videos into perfect short segments for social networks. In a few clicks, automatically cut your videos into segments of one minute or less, ideal for TikTok, Instagram Reels, YouTube Shorts and more.\n\nMain features:\n• Simple and intuitive interface\n• Smart automatic cutting\n• Customizable duration (30 seconds by default)\n• Fast and optimized export\n• Compatible with all popular formats\n\nWhether you\'re a content creator or a simple user, Cutit saves you precious time by automating the cutting of your videos while preserving their quality.\n\nStart now to transform your long videos into engaging content!',
      'version': 'Version',

      // Feedback
      'sorry_problem':
          'We\'re sorry you\'re experiencing a problem. Describe what happened and we\'ll do our best to help you.',
      'describe_problem': 'Describe the problem in detail...',
      'describe_problem_validation': 'Please describe the problem encountered',
      'screenshots': 'Screenshots',
      'camera': 'Camera',
      'gallery': 'Gallery',
      'send_report': 'Send report',
      'screenshots_title': 'Screenshots',
      'screenshots_description':
          'Add screenshots to help us better understand the problem',

      // Share app
      'share_app_title': 'Cutit',
      'share_app_text':
          'Hey ! I just discovered Cutit, a great app that automatically cuts long videos into perfect short segments for stories and statuses! No more hassle, it\'s magic ✨ Try it here: ',

      // Thank you
      'thank_you_report': 'Thank you for your report!',
      'appreciate_help': 'We appreciate your help in improving the app.',

      // Folder operations
      'rename_folder': 'Rename folder',
      'save_folder': 'Save folder',
      'new_folder': 'New folder',
      'delete_folder': 'Delete folder',
      'delete_folder_confirm':
          'Are you sure you want to delete the folder? \nThis action is irreversible.',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'ok': 'Ok',
      'error_loading_video': '❌ Error loading video, please try again',
      'import_video': 'Importing video...',

      // Time slicing
      'define_duration_excerpts': 'Define the duration of each video excerpt',
      'duration_defined': 'Duration defined: ',
      'social_preset': 'Social Preset',
      'custom': 'Custom',
      'choose_format': 'Choose a format',
      'cut': 'Cut',

      // Notifications
      'notification_title': 'Cutit',
      'notification_body': 'Your video has been cut successfully!',

      // General
      'hello': 'Hello',

      // Saving
      'saving_videos': 'Videos saved successfully',
      'error_saving_videos': 'Error while saving videos',
      'no_segment_to_save': 'No segment to save',
      'error_accessing_external_directory':
          'Impossible d\'accéder au répertoire externe',
      'platform_not_supported': 'Platform not supported',

      // Sharing
      'error_sharing_videos': 'Error while sharing videos',
      'no_video_to_share': 'No video to share',
      'export': 'Export',
      'export_failed': 'Export failed',
      'export_success': 'Export successful',
      // Premium
      'premium_title': 'Unlock Cutit Pro ✨',
      'premium_subtitle': 'No ads • HD export • No size limit',
      'cutit_pro_active': 'Cutit Pro Active',
      'enjoy_pro_features': 'You have full access to all features',
      // Export modal
      'export_type': 'Export Type',
      'choose_export_quality': 'Choose your export quality.',
      'export_standard': 'Standard Export (Free)',
      'export_standard_desc': 'Standard quality with ads. Might take longer.',
      'export_pro': 'Pro Export (Premium) 🚀',
      'export_pro_desc': 'Ultra fast, highest quality, no ads.',
      // Rating
      'enjoying_app_title': 'Are you satisfied?',
      'enjoying_app_body':
          'We hope you liked the result! If so, would you mind rating us?',
      'yes_i_love_it': 'Yes, I love it!',
      'not_really': 'Not really',

      // Export HD Dialog
      'export_hd_title': 'HD Export',
      'export_hd_desc':
          'Watch a short video ad to unlock HD export, or upgrade to Pro for unlimited access.',
      'go_pro': 'Go Pro',
      'unlock': 'Unlock',
      'error': 'Error',
      'ad_load_error': 'Unable to load the video ad. Please try again later.',
      'update_mandatory_title': 'Update required',
      'update_optional_title': 'Update available',
      'update_button': 'Update now',
      'update_check': 'Update check',
      'app_up_to_date': 'Your app is up to date!',
      'update_check_error': 'Failed to check for updates. Please try again.',
      'remove_ads_watermark': 'Remove ads & watermark',
      'unlock_pro_features_now': 'Unlock Pro features now',
      'pro_success_cta':
          'Unlock ultra-fast export, HD quality, and remove watermarks/ads forever!',
      'congratulations': 'Congratulations!',
      'premium_unlocked_desc':
          'You have unlocked Cutit Pro. Enjoy an ad-free experience without time or size limits!',
      'continue_label': 'Continue',
      'support_cutit': 'Support Cutit',
      'hello_support': 'Hello Support Team,\n\n',
      'details': 'Details',
      'no_video_to_save': 'No video to save',
      'info': 'Info',
      'already_pro': 'You are already a Pro user!',
      'only_mobile': 'This feature is only available on mobile devices.',
      'limit_exceeded_title': 'Limit Exceeded',
      'size_limit_exceeded_desc': 'This video is @size MB, which exceeds the free limit of @limit MB.\n\nUpgrade to Pro to cut videos up to 1.5 GB!',
      'duration_limit_exceeded_desc': 'This video is @duration long, which exceeds the free limit of @limit minutes.\n\nUpgrade to Pro to cut videos up to 1 hour!',
      'upgrade_to_pro': 'Upgrade to Pro',
    },
    'fr': {
      // App name and general
      'app_name': 'Cutit',
      'folder_name': 'Cutit',
      'update_check': 'Mise à jour',
      'app_up_to_date': 'Votre application est à jour !',
      'update_check_error':
          'Impossible de vérifier les mises à jour. Veuillez réessayer.',

      // Introduction screens
      'skip': 'Passer',
      'later': 'Plus tard',
      'welcome_cutit':
          'Bienvenue sur Cutit, l\'outil simple et rapide pour découper vos vidéos longues en formats courts et percutants.\nPas besoin de créer un compte',
      'choose_video':
          'Choisissez facilement une vidéo pour la découpe depuis votre galerie',
      'define_duration':
          'Définissez la durée souhaitée, et Cutit s\'occupe du découpage automatique. Rapide, fluide, efficace.',
      'share_moments':
          'Partagez facilement les meilleurs moments sur vos réseaux préférés : TikTok, Instagram, WhatsApp, YouTube Shorts… tout est prêt, au bon format.',
      'allow_notifications':
          'Autorisez les notifications pour vous assurer de ne manquer aucun message',
      'permission_denied_to_receive_notifications':
          'Autorisation refusée pour recevoir les notifications',
      'allow': 'Autoriser',
      'intro_title_1': 'Pas de compte. Zéro config.',
      'intro_desc_1':
          'Ouvrez l\'app, sélectionnez votre vidéo et commencez à découper immédiatement. Votre vie privée est 100% respectée.',
      'intro_title_2': 'Découpe automatique en 1 clic.',
      'intro_desc_2':
          'Choisissez vos presets ou définissez une durée personnalisée. L\'application s\'occupe de tout en quelques secondes.',
      'intro_title_3': 'Enregistrez & Partagez',
      'intro_desc_3':
          'Enregistrez vos clips directement dans votre galerie ou partagez-les en un clic sur tous vos réseaux.',
      'intro_title_4': 'Restez Informé',
      'intro_desc_4':
          'Autorisez les notifications pour savoir exactement quand votre export est terminé, même en arrière-plan.',

      // Home screen
      'cut_share_save':
          'Découpez, partagez et enregistrez vos vidéos en quelques clics',
      'load_video': 'Charger une vidéo',
      'select_video': 'Sélectionner une vidéo',
      'cut_video': 'Découper la vidéo',
      'my_cutouts': 'Mes découpages',
      'no_cutouts_found': 'Aucun découpage trouvé.',

      // Processing screen
      'cutting_in_progress':
          '✂️ Découpage en cours… ne quitte pas l\'application.',
      'no_manual_cutting': '🔪 Plus besoin de couper manuellement tes vidéos.',
      'share_easily':
          '📱 Partage plus facilement des longues vidéos en plusieurs parties.',
      'transform_video':
          '🎯 Transforme une vidéo en plusieurs statuts en un clic.',
      'ideal_for_stories':
          '📸 Idéal pour les stories, les statuts WhatsApp et tes shorts YouTube.',
      'videos_become_simple':
          '🚀 Tes longues vidéos deviennent simples à publier.',
      'create_automatically':
          '⏱️ Crée automatiquement des extraits de 10, 30, 60 secondes.',
      'use_cutit_like_pro':
          '🎬 Utilise cutit pour découper tes vidéos comme un pro',

      // Result screen
      'clips_selected': 'clips sélectionnés',
      'clip_selected': 'clip sélectionné',
      'select': 'Sélectionner',
      'cutting_results': 'Résultats du découpage',
      'preview': 'Aperçu',
      'segment': 'Partie',
      'segments_timeline': 'Timeline des segments',
      'share': 'Partager',
      'save': 'Enregistrer',
      'cut_done_title': 'Découpage terminée 💯',
      'cut_done_body': 'Vous pouvez le partager ou l\'enregistrer',
      'cut_done_notification':
          'Découpage terminé, vous pouvez le partager ou l\'enregistrer',
      'no_video_selected':
          'Aucune vidéo sélectionnée. Veuillez sélectionner au moins une vidéo',
      'error_cutting':
          '❌ Impossible de découper cette vidéo\n👉 Assure-toi que la vidéo est stockée sur ton téléphone\n🔁 Réessaie avec une vidéo plus courte',
      'duration': 'Durée',
      'size': 'Taille',
      // Settings
      'settings': 'Paramètres',
      'purchases': 'Achats',
      'restore_purchases': 'Restaurer les achats',
      'no_active_subscription': 'Aucun abonnement actif trouvé à restaurer.',
      'purchases_restored': 'Achats restaurés avec succès.',
      'general': 'Général',
      'support_and_about': 'Support & À propos',
      'how_it_works': 'Comment ça marche ?',
      'contact_us': 'Contactez-nous',
      'report_issue': 'Signaler un problème',
      'rate_app': 'Noter l\'application',
      'share_app': 'Partager l\'application',
      'about': 'À propos',
      'language': 'Langue',
      'privacy_policy': 'Confidentialité',
      'terms_of_use': 'Conditions d\'utilisation',

      // How it works
      'welcome_cutit_title': 'Bienvenue sur Cutit !',
      'step1_title': '1. Sélectionnez une vidéo',
      'step1_desc':
          'Choisissez une vidéo depuis votre galerie ou partagez-la directement depuis une autre application.',
      'step2_title': '2. Ajustez la durée',
      'step2_desc':
          'Définissez la durée souhaitée pour chaque segment (par défaut 30 secondes).',
      'step3_title': '3. Découpez automatiquement',
      'step3_desc':
          'L\'application découpe automatiquement votre vidéo en segments de la durée choisie.',
      'step4_title': '4. Sélectionnez et sauvegardez',
      'step4_desc':
          'Choisissez les segments à conserver et enregistrez-les dans votre galerie.',
      'step5_title': '5. Partagez sur les réseaux sociaux',
      'step5_desc':
          'Partagez vos segments sur TikTok, Instagram, WhatsApp et plus encore.',
      'step_tip':
          'Vous pouvez également partager directement une vidéo depuis votre gallérie vers Cutit pour la découper instantanément !',
      'tip': '💡Astuce !',
      // Contact us
      'question_problem': 'Une question ? Un problème ?',
      'contact_description':
          'N\'hésitez pas à nous contacter, nous vous répondrons dans les plus brefs délais.',
      'send_email': 'Envoyer un email',

      // About app
      'about_cutit':
          '✂️ À propos de Cutit\n\nCutit est une application innovante qui transforme vos longues vidéos en courts segments parfaits pour les réseaux sociaux. En quelques clics, découpez automatiquement vos vidéos en segments d\'une minute ou moins, idéals pour TikTok, Instagram Reels, YouTube Shorts et plus encore.\n\nCaractéristiques principales :\n• Interface simple et intuitive\n• Découpage automatique intelligent\n• Durée personnalisable (30 secondes par défaut)\n• Export rapide et optimisé\n• Compatible avec tous les formats populaires\n\nQue vous soyez créateur de contenu ou simple utilisateur, Cutit vous fait gagner un temps précieux en automatisant le découpage de vos vidéos tout en préservant leur qualité.\n\nCommencez dès maintenant à transformer vos longues vidéos en contenus engageants !',
      'version': 'Version',

      // Feedback
      'sorry_problem':
          'Nous sommes désolés que vous rencontriez un problème. Décrivez-nous ce qui s\'est passé et nous ferons de notre mieux pour vous aider.',
      'describe_problem': 'Décrivez le problème en détail...',
      'describe_problem_validation': 'Veuillez décrire le problème rencontré',
      'screenshots': 'Captures d\'écran',
      'camera': 'Appareil photo',
      'gallery': 'Galerie',
      'send_report': 'Envoyer le rapport',
      'screenshots_title': 'Captures d\'écran',
      'screenshots_description':
          'Ajoutez des captures d\'écran pour nous aider à mieux comprendre le problème',

      // Share app
      'share_app_title': 'Cutit',
      'share_app_text':
          'Hey ! Je viens de découvrir Cutit, une app géniale qui découpe automatiquement les longues vidéos en petits segments parfaits pour les stories et les statuts ! Plus besoin de galérer, c\'est magique ✨ Teste-la ici : ',

      // Thank you
      'thank_you_report': 'Merci pour votre rapport !',
      'appreciate_help':
          'Nous apprécions votre aide pour améliorer l\'application.',

      // Folder operations
      'rename_folder': 'Renommer',
      'save_folder': 'Enregistrer le dossier',
      'new_folder': 'Nouveau dossier',
      'delete_folder': 'Supprimer',
      'delete_folder_confirm':
          'Êtes-vous sûr de vouloir supprimer le dossier ? \nCette action est irréversible.',
      'cancel': 'Annuler',
      'delete': 'Supprimer',
      'ok': 'Ok',
      'error_loading_video': '❌ Erreur lors du chargement des dossiers',
      'import_video': 'Importation de la vidéo...',

      // Time slicing
      'define_duration_excerpts': 'Définir la durée de chaque extrait vidéo',
      'duration_defined': 'Durée définie : ',
      'social_preset': 'Réseau social',
      'custom': 'Personnalisé',
      'choose_format': 'Choisir un format',
      'cut': 'Découper',

      // Notifications
      'notification_title': 'Cutit',
      'notification_body': 'Votre vidéo a été découpée avec succès !',

      // General
      'hello': 'Bonjour',

      // Saving
      'saving_videos': 'Vidéos enregistrées avec succè',
      'error_saving_videos': 'Erreur lors de l\'enregistrement des vidéos',
      'no_segment_to_save': 'Aucun segment à enregistrer',
      'error_accessing_external_directory':
          'Impossible d\'accéder au répertoire externe',
      'platform_not_supported': 'Plateforme non supportée',
      'export': 'Exporter',
      'export_failed': 'Export échoué',
      'export_success': 'Export réussi',

      // Sharing
      'error_sharing_videos': 'Erreur lors du partage des vidéos',
      'no_video_to_share': 'Aucune vidéo à partager',
      //
      'premium_title': 'Débloquez Cutit Pro ✨',
      'premium_subtitle': 'Zéro pub • Export HD • Sans limite',
      'cutit_pro_active': 'Cutit Pro Actif',
      'enjoy_pro_features': 'Vous avez accès à toutes les fonctionnalités',
      // Export modal
      'export_type': 'Type d\'exportation',
      'choose_export_quality': 'Choisissez votre qualité d\'export.',
      'export_standard': 'Export Standard (Gratuit)',
      'export_standard_desc': 'Qualité normale avec publicités.',
      'export_pro': 'Export Pro (Premium) 🚀',
      'export_pro_desc': 'Ultra rapide, haute qualité, sans publicité.',
      // Rating
      'enjoying_app_title': 'Êtes-vous satisfait ?',
      'enjoying_app_body':
          'Nous espérons que le résultat vous plaît ! Si c\'est le cas, voulez-vous nous noter ?',
      'yes_i_love_it': 'Oui, j\'adore !',
      'not_really': 'Pas vraiment',

      // Export HD Dialog
      'export_hd_title': 'Export HD',
      'export_hd_desc':
          'Regardez une courte vidéo publicitaire pour débloquer l\'export en HD, ou passez à la version Pro pour un accès illimité.',
      'go_pro': 'Passer Pro',
      'unlock': 'Débloquer',
      'error': 'Erreur',
      'ad_load_error':
          'Impossible de charger la vidéo publicitaire. Veuillez réessayer plus tard.',
      'update_mandatory_title': 'Mise à jour obligatoire',
      'update_optional_title': 'Mise à jour disponible',
      'update_button': 'Mettre à jour maintenant',
      'remove_ads_watermark': 'Retirer les pubs & le filigrane',
      'unlock_pro_features_now': 'Débloquer les fonctionnalités Pro maintenant',
      'pro_success_cta':
          "Débloquez l'export ultra-rapide en HD, et supprimez le filigrane/pubs à tout jamais !",
      'congratulations': 'Félicitations !',
      'premium_unlocked_desc':
          "Vous avez débloqué Cutit Pro. Profitez d'une expérience sans publicité et sans limite de temps et taille !",
      'continue_label': 'Continuer',
      'support_cutit': 'Support Cutit',
      'hello_support': "Bonjour l'équipe Support,\n\n",
      'details': 'Détails',
      'no_video_to_save': 'Aucune vidéo à sauvegarder',
      'info': 'Info',
      'already_pro': 'Vous êtes déjà un utilisateur Pro !',
      'only_mobile':
          'Cette fonctionnalité est uniquement disponible sur les appareils mobiles.',
      'limit_exceeded_title': 'Limite dépassée',
      'size_limit_exceeded_desc': 'Cette vidéo fait @size Mo, ce qui dépasse la limite gratuite de @limit Mo.\n\nPassez à la version Pro pour couper des vidéos allant jusqu\'à 1.5 Go !',
      'duration_limit_exceeded_desc': 'Cette vidéo dure @duration, ce qui dépasse la limite gratuite de @limit minutes.\n\nPassez à la version Pro pour couper des vidéos allant jusqu\'à 1 heure !',
      'upgrade_to_pro': 'Passer Pro',
    },
    'es': {
      // App name and general
      'app_name': 'Cutit',
      'folder_name': 'Cutit',

      // Introduction screens
      'skip': 'Omitir',
      'later': 'Más tarde',
      'welcome_cutit':
          'Bienvenido a Cutit\n, la herramienta simple y rápida para cortar tus videos largos en formatos cortos e impactantes.\nNo es necesario crear una cuenta',
      'choose_video': 'Elige fácilmente un video para cortar desde tu galería',
      'define_duration':
          'Define la duración deseada, y Cutit se encarga del corte automático. Rápido, fluido, eficiente.',
      'share_moments':
          'Comparte fácilmente los mejores momentos en tus redes favoritas: TikTok, Instagram, WhatsApp, YouTube Shorts... todo está listo, en el formato correcto.',
      'allow_notifications':
          'Permite las notificaciones para asegurarte de no perder ningún mensaje',
      'permission_denied_to_receive_notifications':
          'Permiso denegado para recibir notificaciones',
      'allow': 'Permitir',
      'intro_title_1': 'Sin cuenta. Cero configuración.',
      'intro_desc_1':
          'Abre la aplicación, selecciona tu video y comienza a cortar de inmediato. Tu privacidad está 100% respetada.',
      'intro_title_2': 'Corte automático en 1 clic.',
      'intro_desc_2':
          'Elige tus presets o define una duración personalizada. La aplicación se encarga de todo en segundos.',
      'intro_title_3': 'Guarda y comparte al instante',
      'intro_desc_3':
          'Guarda clips directamente en tu galería o compártelos con un clic en todas tus redes sociales.',
      'intro_title_4': 'Mantente notificado',
      'intro_desc_4':
          'Activa las notificaciones para saber exactamente cuándo se ha procesado tu video, incluso en segundo plano.',

      // Home screen
      'cut_share_save': 'Corta, comparte y guarda tus videos en unos clics',
      'load_video': 'Cargar un video',
      'select_video': 'Seleccionar un video',
      'cut_video': 'Cortar video',
      'my_cutouts': 'Mis cortes',
      'no_cutouts_found': 'No se encontraron cortes.',

      // Processing screen
      'cutting_in_progress':
          '✂️ Cortando en progreso... no salgas de la aplicación.',
      'no_manual_cutting': '🔪 Ya no necesitas cortar manualmente tus videos.',
      'share_easily':
          '📱 Comparte videos largos más fácilmente en varias partes.',
      'transform_video':
          '🎯 Transforma un video en varios estados con un clic.',
      'ideal_for_stories':
          '📸 Ideal para historias, estados de WhatsApp y tus YouTube shorts.',
      'videos_become_simple':
          '🚀 Tus videos largos se vuelven simples de publicar.',
      'create_automatically':
          '⏱️ Crea automáticamente extractos de 10, 30, 60 segundos.',
      'use_cutit_like_pro':
          '🎬 Usa cutit para cortar tus videos como un profesional',
      'cut_done_title': 'Corte completado 💯',
      'cut_done_body': 'Puedes compartirlo o guardarlo',
      'cut_done_notification':
          'Corte completado, puedes compartirlo o guardarlo',
      'error_cutting': 'Error al cortar, por favor inténtalo de nuevo',

      // Result screen
      'clips_selected': 'clips seleccionados',
      'clip_selected': 'clip seleccionado',
      'select': 'Seleccionar',
      'cutting_results': 'Resultados del corte',
      'preview': 'Vista previa',
      'segment': 'Parte',
      'segments_timeline': 'Línea de tiempo de segmentos',
      'share': 'Compartir',
      'save': 'Guardar',
      'no_video_selected':
          'No hay video seleccionado. Por favor selecciona al menos un video',
      'duration': 'Duración',
      'size': 'Tamaño',

      // Settings
      'settings': 'Configuración',
      'purchases': 'Compras',
      'restore_purchases': 'Restaurar compras',
      'no_active_subscription':
          'No se encontró ninguna suscripción activa para restaurar.',
      'purchases_restored': 'Compras restauradas con éxito.',
      'general': 'General',
      'support_and_about': 'Soporte y Acerca de',
      'how_it_works': '¿Cómo funciona?',
      'contact_us': 'Contáctanos',
      'report_issue': 'Reportar un problema',
      'rate_app': 'Calificar la aplicación',
      'share_app': 'Compartir la aplicación',
      'about': 'Acerca de',
      'language': 'Idioma',
      'privacy_policy': 'Política de privacidad',
      'terms_of_use': 'Condiciones de uso',

      // How it works
      'welcome_cutit_title': '¡Bienvenido a Cutit!',
      'step1_title': '1. Selecciona un video',
      'step1_desc':
          'Elige un video de tu galería o compártelo directamente desde otra aplicación.',
      'step2_title': '2. Ajusta la duración',
      'step2_desc':
          'Establece la duración deseada para cada segmento (30 segundos por defecto).',
      'step3_title': '3. Corta automáticamente',
      'step3_desc':
          'La aplicación corta automáticamente tu video en segmentos de la duración elegida.',
      'step4_title': '4. Selecciona y guarda',
      'step4_desc':
          'Elige los segmentos que deseas conservar y guárdalos en tu galería.',
      'step5_title': '5. Comparte en redes sociales',
      'step5_desc':
          'Comparte tus segmentos en TikTok, Instagram, WhatsApp y más.',
      'step_tip':
          '¡También puedes compartir un video directamente desde tu galería a Cutit para cortarlo instantáneamente!',
      'tip': '💡¡Consejo!',
      // Contact us
      'question_problem': '¿Una pregunta? ¿Un problema?',
      'contact_description':
          'No dudes en contactarnos, te responderemos lo antes posible.',
      'send_email': 'Enviar un correo electrónico',

      // About app
      'about_cutit':
          '✂️ Acerca de Cutit\n\nCutit es una aplicación innovadora que transforma tus videos largos en segmentos cortos perfectos para redes sociales. En unos clics, corta automáticamente tus videos en segmentos de un minuto o menos, ideales para TikTok, Instagram Reels, YouTube Shorts y más.\n\nCaracterísticas principales:\n• Interfaz simple e intuitiva\n• Corte automático inteligente\n• Duración personalizable (30 segundos por defecto)\n• Exportación rápida y optimizada\n• Compatible con todos los formatos populares\n\nYa seas creador de contenido o un usuario simple, Cutit te ahorra un tiempo valioso automatizando el corte de tus videos mientras preserva su calidad.\n\n¡Comienza ahora a transformar tus videos largos en contenido atractivo!',
      'version': 'Versión',

      // Feedback
      'sorry_problem':
          'Lamentamos que estés experimentando un problema. Describe lo que sucedió y haremos nuestro mejor esfuerzo para ayudarte.',
      'describe_problem': 'Describe el problema en detalle...',
      'describe_problem_validation':
          'Por favor describe el problema encontrado',
      'screenshots': 'Capturas de pantalla',
      'camera': 'Cámara',
      'gallery': 'Galería',
      'send_report': 'Enviar reporte',
      'screenshots_title': 'Capturas de pantalla',
      'screenshots_description':
          'Añade capturas de pantalla para ayudarnos a entender mejor el problema',

      // Share app
      'share_app_title': 'Cutit',
      'share_app_text':
          '¡Hey! Acabo de descubrir Cutit, una aplicación genial que corta automáticamente videos largos en pequeños segmentos perfectos para historias y estados. ¡Ya no necesitas complicarte, es mágico ✨ Pruébala aquí: ',

      // Thank you
      'thank_you_report': '¡Gracias por tu reporte!',
      'appreciate_help': 'Apreciamos tu ayuda para mejorar la aplicación.',

      // Folder operations
      'rename_folder': 'Renombrar carpeta',
      'save_folder': 'Guardar carpeta',
      'new_folder': 'Nueva carpeta',
      'delete_folder': 'Eliminar carpeta',
      'delete_folder_confirm':
          '¿Estás seguro de que quieres eliminar la carpeta? \nEsta acción es irreversible.',
      'cancel': 'Cancelar',
      'delete': 'Eliminar',
      'ok': 'Ok',
      'error_loading_video':
          '❌ Error al cargar el video, por favor inténtalo de nuevo',
      'import_video': 'Importando video...',

      // Time slicing
      'define_duration_excerpts':
          'Define la duración de cada extracto de video',
      'duration_defined': 'Duración definida: ',
      'social_preset': 'Red social',
      'custom': 'Personalizado',
      'choose_format': 'Elegir un formato',
      'cut': 'Cortar',

      // Notifications
      'notification_title': 'Cutit',
      'notification_body': '¡Tu video ha sido cortado exitosamente!',

      // General
      'hello': 'Hola',

      // Saving
      'saving_videos': 'Videos guardados exitosamente',
      'error_saving_videos': 'Error al guardar los videos',
      'no_segment_to_save': 'No hay segmento para guardar',
      'error_accessing_external_directory':
          'No se puede acceder al directorio externo',
      'platform_not_supported': 'Plataforma no soportada',
      'export': 'Exportar',
      'export_failed': 'Exportación fallida',
      'export_success': 'Exportación exitosa',

      // Sharing
      'error_sharing_videos': 'Error al compartir los videos',
      'no_video_to_share': 'No hay video para compartir',
      //
      'premium_title': 'Desbloquea Cutit Pro ✨',
      'premium_subtitle': 'Sin anuncios • Exportación HD • Sin límite',
      'cutit_pro_active': 'Cutit Pro Activo',
      'enjoy_pro_features': 'Tienes acceso a todas las funciones',
      // Export modal
      'export_type': 'Tipo de exportación',
      'choose_export_quality': 'Elige la calidad de tu exportación.',
      'export_standard': 'Exportación Estándar (Gratis)',
      'export_standard_desc': 'Calidad normal, contiene anuncios.',
      'export_pro': 'Exportación Pro (Premium) 🚀',
      'export_pro_desc': 'Ultrarápido, alta calidad, sin anuncios.',
      // Rating
      'enjoying_app_title': '¿Estás satisfecho?',
      'enjoying_app_body':
          '¡Esperamos que te guste el resultado! Si es así, ¿te importaría calificarnos?',
      'yes_i_love_it': '¡Sí, me encanta!',
      'not_really': 'No realmente',

      // Export HD Dialog
      'export_hd_title': 'Exportación HD',
      'export_hd_desc':
          'Mira un breve anuncio de video para desbloquear la exportación en HD, o actualiza a Pro para acceso ilimitado.',
      'go_pro': 'Hazte Pro',
      'unlock': 'Desbloquear',
      'error': 'Error',
      'ad_load_error':
          'No se pudo cargar el anuncio de video. Por favor, inténtalo de nuevo más tarde.',
      'remove_ads_watermark': 'Quitar anuncios y marca de agua',
      'unlock_pro_features_now': 'Desbloquear funciones Pro ahora',
      'pro_success_cta':
          '¡Desbloquea exportación ultra rápida en HD y elimina marcas de agua/anuncios para siempre!',
      'congratulations': '¡Felicitaciones!',
      'premium_unlocked_desc':
          'Has desbloqueado Cutit Pro. ¡Disfruta de una experiencia sin anuncios y sin límites de tiempo o tamaño!',
      'continue_label': 'Continuar',
      'support_cutit': 'Soporte Cutit',
      'hello_support': 'Hola equipo de soporte,\n\n',
      'details': 'Detalles',
      'no_video_to_save': 'No hay video para guardar',
      'info': 'Información',
      'already_pro': '¡Ya eres un usuario Pro!',
      'only_mobile':
          'Esta función solo está disponible en dispositivos móviles.',
      'update_mandatory_title': 'Actualización obligatoria',
      'update_optional_title': 'Actualización disponible',
      'update_button': 'Actualizar ahora',
      'update_check': 'Buscar actualizaciones',
      'app_up_to_date': '¡Tu aplicación está actualizada!',
      'update_check_error':
          'Error al buscar actualizaciones. Por favor, inténtalo de nuevo.',
      'limit_exceeded_title': 'Límite excedido',
      'size_limit_exceeded_desc': 'Este video tiene @size MB, lo que supera el límite gratuito de @limit MB.\n\n¡Actualiza a Pro para cortar videos de hasta 1.5 GB!',
      'duration_limit_exceeded_desc': 'Este video dura @duration, lo que supera el límite gratuito de @limit minutos.\n\n¡Actualiza a Pro para cortar videos de hasta 1 hora!',
      'upgrade_to_pro': 'Hacerse Pro',
    },
    'pt': {
      // App name and general
      'app_name': 'Cutit',
      'folder_name': 'Cutit',

      // Introduction screens
      'skip': 'Pular',
      'welcome_cutit':
          'Bem-vindo ao Cutit\n, a ferramenta simples e rápida para cortar seus vídeos longos em formatos curtos e impactantes.\nNão é necessário criar uma conta',
      'choose_video': 'Escolha facilmente um vídeo para cortar da sua galeria',
      'define_duration':
          'Defina a duração desejada, e o Cutit cuida do corte automático. Rápido, suave, eficiente.',
      'share_moments':
          'Compartilhe facilmente os melhores momentos nas suas redes favoritas: TikTok, Instagram, WhatsApp, YouTube Shorts... tudo pronto, no formato certo.',
      'allow_notifications':
          'Permita notificações para garantir que você não perca nenhuma mensagem',
      'permission_denied_to_receive_notifications':
          'Permissão negada para receber notificações',
      'allow': 'Permitir',
      'intro_title_1': 'Sem conta. Zero configuração.',
      'intro_desc_1':
          'Abra o aplicativo, selecione seu vídeo e comece a cortar imediatamente. Sua privacidade é 100% respeitada.',
      'intro_title_2': 'Corte automático em 1 clique.',
      'intro_desc_2':
          'Escolha seus presets ou defina uma duração personalizada. O aplicativo cuida de tudo em segundos.',
      'intro_title_3': 'Salve e compartilhe instantaneamente',
      'intro_desc_3':
          'Salve clipes diretamente na sua galeria ou compartilhe-os com um clique em todas as suas redes sociais.',
      'intro_title_4': 'Mantenha-se notificado',
      'intro_desc_4':
          'Ative as notificações para saber exatamente quando seu vídeo foi totalmente processado, mesmo em segundo plano.',

      // Home screen
      'cut_share_save':
          'Corte, compartilhe e salve seus vídeos em alguns cliques',
      'load_video': 'Carregar um vídeo',
      'select_video': 'Selecionar um vídeo',
      'cut_video': 'Cortar vídeo',
      'my_cutouts': 'Meus cortes',
      'no_cutouts_found': 'Nenhum corte encontrado.',

      // Processing screen
      'cutting_in_progress': '✂️ Corte em progresso... não saia do aplicativo.',
      'no_manual_cutting':
          '🔪 Não há mais necessidade de cortar manualmente seus vídeos.',
      'share_easily':
          '📱 Compartilhe vídeos longos mais facilmente em várias partes.',
      'transform_video':
          '🎯 Transforme um vídeo em vários status com um clique.',
      'ideal_for_stories':
          '📸 Ideal para stories, status do WhatsApp e seus YouTube shorts.',
      'videos_become_simple':
          '🚀 Seus vídeos longos se tornam simples de publicar.',
      'create_automatically':
          '⏱️ Crie automaticamente trechos de 10, 30, 60 segundos.',
      'use_cutit_like_pro':
          '🎬 Use cutit para cortar seus vídeos como um profissional',
      'cut_done_title': 'Corte concluído 💯',
      'cut_done_body': 'Você pode compartilhar ou salvar',
      'cut_done_notification':
          'Corte concluído, você pode compartilhar ou salvar',
      'error_cutting': 'Erro ao cortar, por favor tente novamente',

      // Result screen
      'clips_selected': 'clipes selecionados',
      'clip_selected': 'clipe selecionado',
      'select': 'Selecionar',
      'cutting_results': 'Resultados do corte',
      'preview': 'Visualização',
      'segment': 'Parte',
      'segments_timeline': 'Linha de tempo dos segmentos',
      'share': 'Compartilhar',
      'save': 'Salvar',
      'no_video_selected':
          'Nenhum vídeo selecionado. Por favor selecione pelo menos um vídeo',
      'duration': 'Duração',
      'size': 'Tamanho',

      // Settings
      'settings': 'Configurações',
      'purchases': 'Compras',
      'restore_purchases': 'Restaurar compras',
      'no_active_subscription':
          'Nenhuma assinatura ativa encontrada para restaurar.',
      'purchases_restored': 'Compras restauradas com sucesso.',
      'general': 'Geral',
      'support_and_about': 'Suporte e Sobre',
      'how_it_works': 'Como funciona?',
      'contact_us': 'Entre em contato',
      'report_issue': 'Reportar um problema',
      'rate_app': 'Avaliar o aplicativo',
      'share_app': 'Compartilhar o aplicativo',
      'about': 'Sobre',
      'language': 'Idioma',
      'privacy_policy': 'Política de privacidade',
      'terms_of_use': 'Termos de uso',

      // How it works
      'welcome_cutit_title': 'Bem-vindo ao Cutit!',
      'step1_title': '1. Selecione um vídeo',
      'step1_desc':
          'Escolha um vídeo da sua galeria ou compartilhe-o diretamente de outro aplicativo.',
      'step2_title': '2. Ajuste a duração',
      'step2_desc':
          'Defina a duração desejada para cada segmento (30 segundos por padrão).',
      'step3_title': '3. Corte automaticamente',
      'step3_desc':
          'O aplicativo corta automaticamente seu vídeo em segmentos da duração escolhida.',
      'step4_title': '4. Selecione e salve',
      'step4_desc':
          'Escolha os segmentos para manter e salve-os na sua galeria.',
      'step5_title': '5. Compartilhe nas redes sociais',
      'step5_desc':
          'Compartilhe seus segmentos no TikTok, Instagram, WhatsApp e mais.',
      'step_tip':
          'Você também pode compartilhar um vídeo diretamente da sua galeria para o Cutit para cortá-lo instantaneamente!',
      'tip': '💡Dica!',
      // Contact us
      'question_problem': 'Uma pergunta? Um problema?',
      'contact_description':
          'Não hesite em nos contatar, responderemos o mais rápido possível.',
      'send_email': 'Enviar um e-mail',

      // About app
      'about_cutit':
          '✂️ Sobre o Cutit\n\nCutit é um aplicativo inovador que transforma seus vídeos longos em segmentos curtos perfeitos para redes sociais. Em alguns cliques, corte automaticamente seus vídeos em segmentos de um minuto ou menos, ideais para TikTok, Instagram Reels, YouTube Shorts e mais.\n\nCaracterísticas principais:\n• Interface simples e intuitiva\n• Corte automático inteligente\n• Duração personalizável (30 segundos por padrão)\n• Exportação rápida e otimizada\n• Compatível com todos os formatos populares\n\nSeja você um criador de conteúdo ou um usuário simples, o Cutit economiza seu tempo precioso automatizando o corte de seus vídeos preservando sua qualidade.\n\nComece agora a transformar seus vídeos longos em conteúdo envolvente!',
      'version': 'Versão',

      // Feedback
      'sorry_problem':
          'Lamentamos que você esteja enfrentando um problema. Descreva o que aconteceu e faremos o nosso melhor para ajudá-lo.',
      'describe_problem': 'Descreva o problema em detalhes...',
      'describe_problem_validation': 'Por favor descreva o problema encontrado',
      'screenshots': 'Capturas de tela',
      'camera': 'Câmera',
      'gallery': 'Galeria',
      'send_report': 'Enviar relatório',
      'screenshots_title': 'Capturas de tela',
      'screenshots_description':
          'Adicione capturas de tela para nos ajudar a entender melhor o problema',

      // Share app
      'share_app_title': 'Cutit',
      'share_app_text':
          'Ei! Acabei de descobrir o Cutit, um aplicativo incrível que corta automaticamente vídeos longos em pequenos segmentos perfeitos para stories e status! Não precisa mais se preocupar, é mágico ✨ Teste aqui: ',

      // Thank you
      'thank_you_report': 'Obrigado pelo seu relatório!',
      'appreciate_help': 'Agradecemos sua ajuda para melhorar o aplicativo.',

      // Folder operations
      'rename_folder': 'Renomear pasta',
      'save_folder': 'Salvar pasta',
      'new_folder': 'Nova pasta',
      'delete_folder': 'Excluir pasta',
      'delete_folder_confirm':
          'Tem certeza de que deseja excluir a pasta? \nEsta ação é irreversível.',
      'cancel': 'Cancelar',
      'delete': 'Excluir',
      'ok': 'Ok',
      'error_loading_video':
          '❌ Erro ao carregar o vídeo, por favor tente novamente',
      'import_video': 'Importando vídeo...',

      // Time slicing
      'define_duration_excerpts': 'Defina a duração de cada trecho de vídeo',
      'duration_defined': 'Duração definida: ',
      'social_preset': 'Rede social',
      'custom': 'Personalizado',
      'choose_format': 'Escolher um formato',
      'cut': 'Cortar',

      // Notifications
      'notification_title': 'Cutit',
      'notification_body': 'Seu vídeo foi cortado com sucesso!',

      // General
      'hello': 'Olá',

      // Saving
      'saving_videos': 'Vídeos salvos com sucesso',
      'error_saving_videos': 'Erro ao salvar os vídeos',
      'no_segment_to_save': 'Nenhum segmento para salvar',
      'error_accessing_external_directory':
          'Não é possível acessar o diretório externo',
      'platform_not_supported': 'Plataforma não suportada',
      'export': 'Exportar',
      'export_failed': 'Export falhou',
      'export_success': 'Export bem-sucedido',

      // Sharing
      'error_sharing_videos': 'Erro ao compartilhar os vídeos',
      'no_video_to_share': 'Nenhum vídeo para compartilhar',
      //
      'premium_title': 'Desbloquear Cutit Pro ✨',
      'premium_subtitle': 'Sem anúncios • Exportação HD • Sem limite',
      'cutit_pro_active': 'Cutit Pro Ativo',
      'enjoy_pro_features': 'Você tem acesso a todas as funcionalidades',
      // Export modal
      'export_type': 'Tipo de exportação',
      'choose_export_quality': 'Escolha a qualidade da sua exportação.',
      'export_standard': 'Exportação Padrão (Gratuito)',
      'export_standard_desc': 'Qualidade normal, contém anúncios.',
      'export_pro': 'Exportação Pro (Premium) 🚀',
      'export_pro_desc': 'Ultra rápido, alta qualidade, sem anúncios.',
      // Rating
      'enjoying_app_title': 'Você está satisfeito?',
      'enjoying_app_body':
          'Esperamos que você tenha gostado do resultado! Se sim, você se importaria de nos avaliar?',
      'yes_i_love_it': 'Sim, eu adoro!',
      'not_really': 'Não muito',

      // Export HD Dialog
      'export_hd_title': 'Exportação HD',
      'export_hd_desc':
          'Assista a um curto anúncio em vídeo para desbloquear a exportação em HD, ou atualize para Pro para acesso ilimitado.',
      'go_pro': 'Seja Pro',
      'unlock': 'Desbloquear',
      'error': 'Erro',
      'ad_load_error':
          'Não foi possível carregar o anúncio em vídeo. Por favor, tente novamente mais tarde.',
      'remove_ads_watermark': 'Remover anúncios e marca d\'água',
      'unlock_pro_features_now': 'Desbloquear recursos Pro agora',
      'pro_success_cta':
          "Desbloqueie exportação ultra rápida em HD e remova marcas d'água/anúncios para sempre!",
      'congratulations': 'Parabéns!',
      'premium_unlocked_desc':
          'Você desbloqueou o Cutit Pro. Desfrute de uma experiência sem anúncios e sem limites de tempo ou tamanho!',
      'continue_label': 'Continuar',
      'support_cutit': 'Suporte Cutit',
      'hello_support': 'Olá equipe de suporte,\n\n',
      'details': 'Detalhes',
      'no_video_to_save': 'Nenhum vídeo para salvar',
      'info': 'Informação',
      'already_pro': 'Você já é um usuário Pro!',
      'only_mobile':
          'Esta função está disponível apenas em dispositivos móveis.',
      'update_mandatory_title': 'Atualização obrigatória',
      'update_optional_title': 'Atualização disponível',
      'update_button': 'Atualizar agora',
      'update_check': 'Verificar atualizações',
      'app_up_to_date': 'Seu aplicativo está atualizado!',
      'update_check_error':
          'Falha ao verificar atualizações. Por favor, tente novamente.',
      'later': 'Mais tarde',
      'limit_exceeded_title': 'Limite excedido',
      'size_limit_exceeded_desc': 'Este vídeo tem @size MB, o que supera o limite gratuito de @limit MB.\n\nAtualize para o Pro para cortar vídeos de até 1.5 GB!',
      'duration_limit_exceeded_desc': 'Este vídeo tem @duration de duração, o que supera o limite gratuito de @limit minutos.\n\nAtualize para o Pro para cortar vídeos de até 1 hora!',
      'upgrade_to_pro': 'Atualizar para o Pro',
    },
    'ar': {
      // App name and general
      'app_name': 'Cutit',
      'folder_name': 'Cutit',

      // Introduction screens
      'skip': 'تخطي',
      'later': 'لاحقًا',
      'welcome_cutit':
          'مرحباً بك في Cutit\n, الأداة البسيطة والسريعة لقص مقاطع الفيديو الطويلة إلى تنسيقات قصيرة ومؤثرة.\nلا حاجة لإنشاء حساب',
      'choose_video': 'اختر بسهولة فيديو للقص من معرض الصور الخاص بك',
      'define_duration':
          'حدد المدة المطلوبة، ويتولى Cutit القص التلقائي. سريع، سلس، فعال.',
      'share_moments':
          'شارك بسهولة أفضل اللحظات على شبكاتك المفضلة: TikTok، Instagram، WhatsApp، YouTube Shorts... كل شيء جاهز، بالتنسيق الصحيح.',
      'allow_notifications': 'اسمح بالإشعارات لضمان عدم تفويت أي رسالة',
      'permission_denied_to_receive_notifications':
          'تم رفض الإذن بتلقي الإشعارات',
      'allow': 'السماح',
      'intro_title_1': 'بدون حساب. صفر إعداد.',
      'intro_desc_1':
          'افتح التطبيق، اختر مقطع الفيديو الخاص بك، وابدأ بالقص على الفور. خصوصيتك محترمة بنسبة 100%.',
      'intro_title_2': 'تقسيم تلقائي بنقرة واحدة.',
      'intro_desc_2':
          'اختر إعدادات الشبكة الاجتماعية مسبقاً أو حدد مدة مخصصة. يتكفل التطبيق بالباقي في ثوانٍ.',
      'intro_title_3': 'احفظ وشارك على الفور',
      'intro_desc_3':
          'احفظ المقاطع مباشرة في معرض الصور الخاص بك أو شاركها بنقرة واحدة على جميع منصات التواصل الاجتماعي الخاصة بك.',
      'intro_title_4': 'ابق على اطلاع',
      'intro_desc_4':
          'اسمح بالإشعارات لمعرفة متى يتم معالجة الفيديو الخاص بك بالكامل، حتى في الخلفية.',

      // Home screen
      'cut_share_save': 'اقطع وشارك واحفظ مقاطع الفيديو الخاصة بك في بضع نقرات',
      'load_video': 'تحميل فيديو',
      'select_video': 'اختر فيديو',
      'cut_video': 'قص الفيديو',
      'my_cutouts': 'قصاتي',
      'no_cutouts_found': 'لم يتم العثور على قصات.',

      // Processing screen
      'cutting_in_progress': '✂️ القص قيد التنفيذ... لا تغادر التطبيق.',
      'no_manual_cutting': '🔪 لا حاجة بعد الآن لقص مقاطع الفيديو يدوياً.',
      'share_easily': '📱 شارك مقاطع الفيديو الطويلة بسهولة أكبر في عدة أجزاء.',
      'transform_video': '🎯 حوّل فيديو إلى عدة حالات بنقرة واحدة.',
      'ideal_for_stories':
          '📸 مثالي للقصص وحالات WhatsApp ومقاطع YouTube القصيرة الخاصة بك.',
      'videos_become_simple':
          '🚀 مقاطع الفيديو الطويلة الخاصة بك تصبح بسيطة للنشر.',
      'create_automatically':
          '⏱️ أنشئ تلقائياً مقتطفات مدتها 10، 30، 60 ثانية.',
      'use_cutit_like_pro':
          '🎬 استخدم Cutit لقص مقاطع الفيديو الخاصة بك مثل محترف',
      'cut_done_title': 'تم القص 💯',
      'cut_done_body': 'يمكنك مشاركته أو حفظه',
      'cut_done_notification': 'تم القص، يمكنك مشاركته أو حفظه',
      'error_cutting': 'حدث خطأ أثناء القص، يرجى المحاولة مرة أخرى',

      // Result screen
      'clips_selected': 'مقاطع محددة',
      'clip_selected': 'مقطع محدد',
      'select': 'تحديد',
      'cutting_results': 'نتائج القص',
      'preview': 'معاينة',
      'segment': 'جزء',
      'segments_timeline': 'المخطط الزمني للمقاطع',
      'share': 'مشاركة',
      'save': 'حفظ',
      'no_video_selected':
          'لم يتم تحديد أي فيديو. يرجى تحديد فيديو واحد على الأقل',
      'duration': 'المدة',
      'size': 'الحجم',

      // Settings
      'settings': 'الإعدادات',
      'purchases': 'المشتريات',
      'restore_purchases': 'استعادة المشتريات',
      'no_active_subscription': 'لم يتم العثور على اشتراك نشط لاستعادته.',
      'purchases_restored': 'تم استعادة المشتريات بنجاح.',
      'general': 'عام',
      'support_and_about': 'الدعم وحول',
      'how_it_works': 'كيف يعمل؟',
      'contact_us': 'اتصل بنا',
      'report_issue': 'الإبلاغ عن مشكلة',
      'rate_app': 'قيّم التطبيق',
      'share_app': 'مشاركة التطبيق',
      'about': 'حول',
      'language': 'اللغة',
      'privacy_policy': 'سياسة الخصوصية',
      'terms_of_use': 'شروط الاستخدام',

      // How it works
      'welcome_cutit_title': 'مرحباً بك في Cutit!',
      'step1_title': '1. اختر فيديو',
      'step1_desc':
          'اختر فيديو من معرض الصور الخاص بك أو شاركه مباشرة من تطبيق آخر.',
      'step2_title': '2. اضبط المدة',
      'step2_desc': 'حدد المدة المطلوبة لكل مقطع (30 ثانية افتراضياً).',
      'step3_title': '3. اقطع تلقائياً',
      'step3_desc':
          'يقطع التطبيق تلقائياً مقطع الفيديو الخاص بك إلى مقاطع بالمدّة المختارة.',
      'step4_title': '4. اختر واحفظ',
      'step4_desc':
          'اختر المقاطع التي تريد الاحتفاظ بها واحفظها في معرض الصور الخاص بك.',
      'step5_title': '5. شارك على الشبكات الاجتماعية',
      'step5_desc': 'شارك مقاطعك على TikTok و Instagram و WhatsApp والمزيد.',
      'step_tip':
          'يمكنك أيضاً مشاركة فيديو مباشرة من معرض الصور الخاص بك إلى Cutit لقصه على الفور!',
      'tip': '💡 نصيحة!',
      // Contact us
      'question_problem': 'سؤال؟ مشكلة؟',
      'contact_description': 'لا تتردد في الاتصال بنا، سنرد في أقرب وقت ممكن.',
      'send_email': 'إرسال بريد إلكتروني',

      // About app
      'about_cutit':
          '✂️ حول Cutit\n\nCutit هو تطبيق مبتكر يحوّل مقاطع الفيديو الطويلة الخاصة بك إلى مقاطع قصيرة مثالية للشبكات الاجتماعية. في بضع نقرات، اقطع تلقائياً مقاطع الفيديو الخاصة بك إلى مقاطع مدتها دقيقة أو أقل، مثالية لـ TikTok و Instagram Reels و YouTube Shorts والمزيد.\n\nالميزات الرئيسية:\n• واجهة بسيطة وبديهية\n• قص تلقائي ذكي\n• مدة قابلة للتخصيص (30 ثانية افتراضياً)\n• تصدير سريع ومحسّن\n• متوافق مع جميع التنسيقات الشائعة\n\nسواء كنت منشئ محتوى أو مستخدم عادي، يوفر لك Cutit وقتاً ثميناً من خلال أتمتة قص مقاطع الفيديو الخاصة بك مع الحفاظ على جودتها.\n\nابدأ الآن لتحويل مقاطع الفيديو الطويلة الخاصة بك إلى محتوى جذاب!',
      'version': 'الإصدار',

      // Feedback
      'sorry_problem':
          'نأسف لأنك تواجه مشكلة. صف ما حدث وسنبذل قصارى جهدنا لمساعدتك.',
      'describe_problem': 'صِف المشكلة بالتفصيل...',
      'describe_problem_validation': 'يرجى وصف المشكلة التي واجهتها',
      'screenshots': 'لقطات الشاشة',
      'camera': 'الكاميرا',
      'gallery': 'المعرض',
      'send_report': 'إرسال التقرير',
      'screenshots_title': 'لقطات الشاشة',
      'screenshots_description':
          'أضف لقطات الشاشة لمساعدتنا على فهم المشكلة بشكل أفضل',

      // Share app
      'share_app_title': 'Cutit',
      'share_app_text':
          'مرحباً! لقد اكتشفت للتو Cutit، تطبيق رائع يقص تلقائياً مقاطع الفيديو الطويلة إلى مقاطع صغيرة مثالية للقصص والحالات! لم تعد هناك حاجة للمعاناة، إنه سحري ✨ جرّبه هنا: ',

      // Thank you
      'thank_you_report': 'شكراً لتقريرك!',
      'appreciate_help': 'نقدّر مساعدتك في تحسين التطبيق.',

      // Folder operations
      'rename_folder': 'إعادة تسمية المجلد',
      'save_folder': 'حفظ المجلد',
      'new_folder': 'مجلد جديد',
      'delete_folder': 'حذف المجلد',
      'delete_folder_confirm':
          'هل أنت متأكد من أنك تريد حذف المجلد؟ \nهذا الإجراء لا يمكن التراجع عنه.',
      'cancel': 'إلغاء',
      'delete': 'حذف',
      'ok': 'موافق',
      'error_loading_video': '❌ خطأ في تحميل الفيديو، يرجى المحاولة مرة أخرى',
      'import_video': 'جاري استيراد الفيديو...',

      // Time slicing
      'define_duration_excerpts': 'حدد مدة كل مقتطف فيديو',
      'duration_defined': 'المدة المحددة: ',
      'social_preset': 'شبكة اجتماعية',
      'cut': 'قص',

      // Notifications
      'notification_title': 'Cutit',
      'notification_body': 'تم قص مقطع الفيديو الخاص بك بنجاح!',

      // General
      'hello': 'مرحباً',

      // Saving
      'saving_videos': 'تم حفظ مقاطع الفيديو بنجاح',
      'error_saving_videos': 'خطأ في حفظ مقاطع الفيديو',
      'no_segment_to_save': 'لا يوجد مقطع للحفظ',
      'error_accessing_external_directory': 'تعذر الوصول إلى الدليل الخارجي',
      'platform_not_supported': 'المنصة غير مدعومة',

      'export': 'تصدير',
      'export_failed': 'فشل التصدير',
      'export_success': 'تم التصدير بنجاح',

      // Sharing
      'error_sharing_videos': 'خطأ في مشاركة مقاطع الفيديو',
      'no_video_to_share': 'لا يوجد فيديو للمشاركة',
      //
      'premium_title': 'افتح Cutit Pro ✨',
      'premium_subtitle': 'بدون إعلانات • تصدير HD • بدون حد',
      'cutit_pro_active': 'Cutit Pro نشط',
      'enjoy_pro_features': 'لديك وصول كامل إلى جميع الميزات',
      // Export modal
      'export_type': 'نوع التصدير',
      'choose_export_quality': 'اختر جودة التصدير.',
      'export_standard': 'تصدير قياسي (مجاني)',
      'export_standard_desc': 'جودة عادية، يحتوي على إعلانات.',
      'export_pro': 'تصدير برو (ممتاز) 🚀',
      'export_pro_desc': 'فائق السرعة، جودة عالية، بدون إعلانات.',
      // Rating
      'enjoying_app_title': 'هل أنت راضٍ؟',
      'enjoying_app_body':
          'نأمل أن تكون النتيجة قد أعجبتك! إذا كان الأمر كذلك، هل تمانع في تقييمنا؟',
      'yes_i_love_it': 'نعم، أحبه!',
      'not_really': 'ليس حقاً',

      // Export HD Dialog
      'export_hd_title': 'تصدير HD',
      'export_hd_desc':
          'شاهد إعلان فيديو قصير لفتح تصدير HD ، أو قم بالترقية إلى Pro للحصول على وصول غير محدود.',
      'go_pro': 'الترقية إلى Pro',
      'unlock': 'فتح',
      'error': 'خطأ',
      'ad_load_error':
          'تعذر تحميل إعلان الفيديو. يرجى المحاولة مرة أخرى لاحقًا.',
      'remove_ads_watermark': 'إزالة الإعلانات والعلامة المائية',
      'unlock_pro_features_now': 'افتح ميزات Pro الآن',
      'pro_success_cta':
          'افتح التصدير فائق السرعة وجودة HD وأزل العلامات المائية/الإعلانات إلى الأبد!',
      'congratulations': 'تهانينا!',
      'premium_unlocked_desc':
          'لقد قمت بفتح Cutit Pro. استمتع بتجربة خالية من الإعلانات وبدون حدود للوقت أو الحجم!',
      'continue_label': 'متابعة',
      'support_cutit': 'دعم Cutit',
      'hello_support': 'مرحباً فريق الدعم،\n\n',
      'details': 'تفاصيل',
      'no_video_to_save': 'لا يوجد فيديو لحفظه',
      'info': 'معلومات',
      'already_pro': 'أنت بالفعل مستخدم Pro!',
      'only_mobile': 'هذه الميزة متاحة فقط على الأجهزة المحمولة.',
      'update_mandatory_title': 'تحديث إجباري',
      'update_optional_title': 'يتوفر تحديث جديد',
      'update_button': 'تحديث الآن',
      'update_check': 'التحقق من وجود تحديثات',
      'app_up_to_date': 'تطبيقك محدث بالكامل!',
      'update_check_error':
          'فشل التحقق من وجود تحديثات. يرجى المحاولة مرة أخرى.',
      'choose_format': 'اختر التنسيق',
      'custom': 'مخصص',
      'limit_exceeded_title': 'تم تجاوز الحد',
      'size_limit_exceeded_desc': 'هذا الفيديو بحجم @size ميجابايت، وهو ما يتجاوز الحد المجاني البالغ @limit ميجابايت.\n\nقم بالترقية إلى Pro لقص مقاطع فيديو تصل إلى 1.5 جيجابايت!',
      'duration_limit_exceeded_desc': 'هذا الفيديو مدته @duration، وهو ما يتجاوز الحد المجاني البالغ @limit دقائق.\n\nقم بالترقية إلى Pro لقص مقاطع فيديو تصل إلى ساعة واحدة!',
      'upgrade_to_pro': 'الترقية إلى Pro',
    },
  };
}
