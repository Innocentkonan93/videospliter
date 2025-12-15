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
    'es': {
      // App name and general
      'app_name': 'Cutit',
      'folder_name': 'Cutit',

      // Introduction screens
      'skip': 'Omitir',
      'welcome_cutit':
          'Bienvenido a Cutit, la herramienta simple y rápida para cortar tus videos largos en formatos cortos e impactantes.\nNo es necesario crear una cuenta',
      'choose_video': 'Elige fácilmente un video para cortar desde tu galería',
      'define_duration':
          'Define la duración deseada, y Cutit se encarga del corte automático. Rápido, fluido, eficiente.',
      'share_moments':
          'Comparte fácilmente los mejores momentos en tus redes favoritas: TikTok, Instagram, WhatsApp, YouTube Shorts... todo está listo, en el formato correcto.',
      'allow_notifications':
          'Permite las notificaciones para asegurarte de no perder ningún mensaje',
      'allow': 'Permitir',

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
      'share': 'Compartir',
      'save': 'Guardar',
      'no_video_selected':
          'No hay video seleccionado. Por favor selecciona al menos un video',
      'duration': 'Duración',
      'size': 'Tamaño',

      // Settings
      'settings': 'Configuración',
      'how_it_works': '¿Cómo funciona?',
      'contact_us': 'Contáctanos',
      'report_issue': 'Reportar un problema',
      'rate_app': 'Calificar la aplicación',
      'share_app': 'Compartir la aplicación',
      'about': 'Acerca de',
      'language': 'Idioma',
      'privacy_policy': 'Política de privacidad',

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

      // Time slicing
      'define_duration_excerpts':
          'Define la duración de cada extracto de video',
      'duration_defined': 'Duración definida: ',
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

      // Sharing
      'error_sharing_videos': 'Error al compartir los videos',
      'no_video_to_share': 'No hay video para compartir',
    },
    'pt': {
      // App name and general
      'app_name': 'Cutit',
      'folder_name': 'Cutit',

      // Introduction screens
      'skip': 'Pular',
      'welcome_cutit':
          'Bem-vindo ao Cutit, a ferramenta simples e rápida para cortar seus vídeos longos em formatos curtos e impactantes.\nNão é necessário criar uma conta',
      'choose_video': 'Escolha facilmente um vídeo para cortar da sua galeria',
      'define_duration':
          'Defina a duração desejada, e o Cutit cuida do corte automático. Rápido, suave, eficiente.',
      'share_moments':
          'Compartilhe facilmente os melhores momentos nas suas redes favoritas: TikTok, Instagram, WhatsApp, YouTube Shorts... tudo pronto, no formato certo.',
      'allow_notifications':
          'Permita notificações para garantir que você não perca nenhuma mensagem',
      'allow': 'Permitir',

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
      'share': 'Compartilhar',
      'save': 'Salvar',
      'no_video_selected':
          'Nenhum vídeo selecionado. Por favor selecione pelo menos um vídeo',
      'duration': 'Duração',
      'size': 'Tamanho',

      // Settings
      'settings': 'Configurações',
      'how_it_works': 'Como funciona?',
      'contact_us': 'Entre em contato',
      'report_issue': 'Reportar um problema',
      'rate_app': 'Avaliar o aplicativo',
      'share_app': 'Compartilhar o aplicativo',
      'about': 'Sobre',
      'language': 'Idioma',
      'privacy_policy': 'Política de privacidade',

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

      // Time slicing
      'define_duration_excerpts': 'Defina a duração de cada trecho de vídeo',
      'duration_defined': 'Duração definida: ',
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

      // Sharing
      'error_sharing_videos': 'Erro ao compartilhar os vídeos',
      'no_video_to_share': 'Nenhum vídeo para compartilhar',
    },
    'ar': {
      // App name and general
      'app_name': 'Cutit',
      'folder_name': 'Cutit',

      // Introduction screens
      'skip': 'تخطي',
      'welcome_cutit':
          'مرحباً بك في Cutit، الأداة البسيطة والسريعة لقص مقاطع الفيديو الطويلة إلى تنسيقات قصيرة ومؤثرة.\nلا حاجة لإنشاء حساب',
      'choose_video': 'اختر بسهولة فيديو للقص من معرض الصور الخاص بك',
      'define_duration':
          'حدد المدة المطلوبة، ويتولى Cutit القص التلقائي. سريع، سلس، فعال.',
      'share_moments':
          'شارك بسهولة أفضل اللحظات على شبكاتك المفضلة: TikTok، Instagram، WhatsApp، YouTube Shorts... كل شيء جاهز، بالتنسيق الصحيح.',
      'allow_notifications': 'اسمح بالإشعارات لضمان عدم تفويت أي رسالة',
      'allow': 'السماح',

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
      'share': 'مشاركة',
      'save': 'حفظ',
      'no_video_selected':
          'لم يتم تحديد أي فيديو. يرجى تحديد فيديو واحد على الأقل',
      'duration': 'المدة',
      'size': 'الحجم',

      // Settings
      'settings': 'الإعدادات',
      'how_it_works': 'كيف يعمل؟',
      'contact_us': 'اتصل بنا',
      'report_issue': 'الإبلاغ عن مشكلة',
      'rate_app': 'قيّم التطبيق',
      'share_app': 'مشاركة التطبيق',
      'about': 'حول',
      'language': 'اللغة',
      'privacy_policy': 'سياسة الخصوصية',

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

      // Time slicing
      'define_duration_excerpts': 'حدد مدة كل مقتطف فيديو',
      'duration_defined': 'المدة المحددة: ',
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

      // Sharing
      'error_sharing_videos': 'خطأ في مشاركة مقاطع الفيديو',
      'no_video_to_share': 'لا يوجد فيديو للمشاركة',
    },
  };
}
