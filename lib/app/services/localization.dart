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
      'welcome_cutit':
          'Welcome to Cutit, the simple and fast tool to cut your long videos into short and impactful formats.\nNo need to create an account',
      'choose_video': 'Easily choose a video to cut from your gallery',
      'define_duration':
          'Define the desired duration, and Cutit takes care of automatic cutting. Fast, smooth, efficient.',
      'share_moments':
          'Easily share the best moments on your favorite networks: TikTok, Instagram, WhatsApp, YouTube Shorts... everything is ready, in the right format.',
      'allow_notifications':
          'Allow notifications to ensure you don\'t miss any message',
      'allow': 'Allow',

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
      'error_cutting': 'Error while cutting, please try again',

      // Result screen
      'clips_selected': 'clips selected',
      'clip_selected': 'clip selected',
      'select': 'Select',
      'cutting_results': 'Cutting results',
      'share': 'Share',
      'save': 'Save',
      'no_video_selected':
          'No video selected. Please select at least one video',
      'duration': 'Duration',
      'size': 'Size',

      // Settings
      'settings': 'Settings',
      'how_it_works': 'How it works?',
      'contact_us': 'Contact us',
      'report_issue': 'Report an issue',
      'rate_app': 'Rate the app',
      'share_app': 'Share the app',
      'about': 'About',
      'language': 'Language',
      'privacy_policy': 'Privacy policy',

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

      // Time slicing
      'define_duration_excerpts': 'Define the duration of each video excerpt',
      'duration_defined': 'Duration defined: ',
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
    },
    'fr': {
      // App name and general
      'app_name': 'Cutit',
      'folder_name': 'Cutit',

      // Introduction screens
      'skip': 'Passer',
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
      'allow': 'Autoriser',

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
      'share': 'Partager',
      'save': 'Enregistrer',
      'cut_done_title': 'Découpage terminée 💯',
      'cut_done_body': 'Vous pouvez le partager ou l\'enregistrer',
      'cut_done_notification':
          'Découpage terminé, vous pouvez le partager ou l\'enregistrer',
      'no_video_selected':
          'Aucune vidéo sélectionnée. Veuillez sélectionner au moins une vidéo',
      'error_cutting': 'Erreur lors du découpage, veuillez réessayer',
      'duration': 'Durée',
      'size': 'Taille',
      // Settings
      'settings': 'Paramètres',
      'how_it_works': 'Comment ça marche ?',
      'contact_us': 'Contactez-nous',
      'report_issue': 'Signaler un problème',
      'rate_app': 'Note sur l\'application',
      'share_app': 'Partager l\'application',
      'about': 'À propos',
      'language': 'Langue',
      'privacy_policy': 'Confidentialité',

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

      // Time slicing
      'define_duration_excerpts': 'Définir la durée de chaque extrait vidéo',
      'duration_defined': 'Durée définie : ',
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

      // Sharing
      'error_sharing_videos': 'Erreur lors du partage des vidéos',
      'no_video_to_share': 'Aucune vidéo à partager',
    },
  };
}
