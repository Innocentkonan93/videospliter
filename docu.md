# 📚 Documentation Complète de Cutit

## 📱 Présentation Générale

**Cutit** (nom interne: `video_spliter`) est une application mobile cross-platform développée en Flutter qui permet aux utilisateurs de découper automatiquement des vidéos longues en segments courts pour faciliter leur partage sur les réseaux sociaux (TikTok, Instagram, WhatsApp, YouTube Shorts, etc.).

### Informations Générales

- **Nom de l'application**: Cutit
- **Version**: 1.1.4+42
- **Framework**: Flutter SDK 3.7.0+
- **Plateformes supportées**: Android, iOS
- **Architecture**: GetX (gestion d'état et navigation)

---

## 🏗️ Architecture Technique

### Structure du Projet

```
lib/
├── app/
│   ├── configs/                    # Configuration de l'application
│   │   ├── app_colors.dart        # Définition des couleurs
│   │   ├── app_theme.dart         # Configuration du thème Material
│   │   └── caches/
│   │       └── cache_helper.dart  # Helper pour le cache local
│   │
│   ├── modules/                    # Modules fonctionnels (architecture GetX)
│   │   ├── home/                  # Module principal (découpe vidéo)
│   │   │   ├── bindings/
│   │   │   │   └── home_binding.dart
│   │   │   ├── controllers/
│   │   │   │   ├── home_controller.dart      # Contrôleur principal
│   │   │   │   └── sharing_controller.dart   # Gestion du partage
│   │   │   └── views/
│   │   │       ├── home_view.dart            # Vue principale
│   │   │       ├── my_cutouts_view.dart      # Vue des segments sauvegardés
│   │   │       ├── progressing_view.dart     # Vue de progression
│   │   │       ├── result_view.dart          # Vue des résultats
│   │   │       ├── video_player_view.dart    # Lecteur vidéo
│   │   │       └── all_videos_preview..dart  # Prévisualisation
│   │   │
│   │   ├── introduction/          # Module d'introduction
│   │   │   ├── bindings/
│   │   │   ├── controllers/
│   │   │   └── views/
│   │   │
│   │   └── settings/              # Module des paramètres
│   │       ├── bindings/
│   │       ├── controllers/
│   │       └── views/
│   │           ├── settings_view.dart
│   │           ├── about_app_view.dart
│   │           ├── contact_us_view.dart
│   │           ├── feedbacks_view.dart
│   │           ├── how_it_work_view.dart
│   │           └── thank_you_view.dart
│   │
│   ├── routes/                    # Gestion des routes GetX
│   │   ├── app_pages.dart
│   │   └── app_routes.dart
│   │
│   ├── services/                  # Services métier
│   │   ├── ad_mob_service.dart           # Gestion des publicités AdMob
│   │   ├── analytics_service.dart        # Analytics Firebase
│   │   ├── app_service.dart              # Services généraux (notation, partage)
│   │   ├── bot_service.dart              # Service bot
│   │   ├── config_service.dart           # Service de configuration (Remote Config & Feature Flags)
│   │   ├── feature_manager.dart          # Manager d'accès aux fonctionnalités (Pro / Free)
│   │   ├── feedback_service.dart         # Service d'envoi de retours à Firestore
│   │   ├── file_service.dart             # Gestion des fichiers/dossiers
│   │   ├── firebase_notification_service.dart  # Notifications Firebase FCM
│   │   ├── firebase_service.dart         # Service Firebase principal
│   │   ├── local_notifications_service.dart    # Notifications locales
│   │   ├── localization.dart             # Internationalisation (i18n)
│   │   ├── revenuecat_service.dart       # Achats In-App & Abonnements Pro (RevenueCat)
│   │   ├── save_segments_service.dart    # Sauvegarde des segments
│   │   ├── sharing_service.dart          # Réception de vidéos partagées
│   │   ├── update_service.dart           # Service de mise à jour de l'app (Versionarte)
│   │   └── video_service.dart            # Traitement vidéo (FFmpeg, compression)
│   │
│   ├── utils/                     # Utilitaires
│   │   ├── constants.dart        # Constantes de l'application
│   │   ├── methods_utils.dart    # Méthodes utilitaires
│   │   └── responsive.dart       # Responsive design
│   │
│   └── widgets/                   # Widgets réutilisables
│       ├── app_update_dialog.dart        # Fenêtre de mise à jour forcée/facultative
│       ├── custom_video_player_view.dart
│       ├── deletion_dialog.dart
│       ├── export_type_sheet.dart        # Feuille de choix de qualité d'export
│       ├── folder_item.dart
│       ├── folder_name_dialog.dart
│       ├── folder_options.dart
│       ├── language_selection_sheet.dart
│       ├── pre_rating_dialog.dart        # Dialogue avant notation
│       ├── premium_banner.dart           # Bannière publicitaire Premium
│       ├── premium_card.dart
│       ├── premium_success_view.dart     # Écran d'achat Pro réussi
│       └── time_slicing_sheet.dart       # Feuille de découpage (presets sociaux & custom)
│
├── firebase_options.dart          # Configuration Firebase
└── main.dart                      # Point d'entrée de l'application
```

### Pattern Architectural: GetX

L'application utilise **GetX** comme solution complète pour:

- **Gestion d'état**: ReactiveX avec `.obs` et `Rx` types
- **Navigation**: Routes nommées avec `Get.to()`, `Get.back()`, etc.
- **Dépendances**: Injection via `Get.put()`, `Get.find()`, et Bindings
- **Internationalisation**: Traductions intégrées avec `GetX Translations`

---

## 🎯 Fonctionnalités Détaillées

### 1. Découpe Vidéo

#### Méthodes de Découpe

L'application propose principalement la méthode suivante pour la production :

- **`splitBySSAsync()`** - Découpe asynchrone (méthode principale)
  - Découpe asynchrone avec `FFmpegKit.executeAsync()`.
  - Progression fine via callbacks `onStatistics` liée au `HomeController`.
  - Nettoyage automatique : ignore les micro-segments inférieurs à 1 seconde.
  - Crop automatique (`crop='floor(in_w/2)*2:floor(in_h/2)*2'`) pour éviter les dimensions impaires.
  - Codec : MPEG4 pour la vidéo (`-c:v mpeg4`, qualité `-qscale:v 5`), AAC pour l'audio (128k bitrate).
  - Format de sortie : MP4.

#### Filigrane (Watermark) & Export Pro/Gratuit
- **Mode Gratuit (`!isPro`)** :
  - Un filigrane (`assets/logo/watermark.png`) est chargé à partir des assets, converti en bytes bruts (`watermark_temp.raw`) et superposé en bas à gauche de la vidéo via le filtre complexe FFmpeg :
    `[0:v]crop='floor(in_w/2)*2:floor(in_h/2)*2'[base];[1:v]scale=120:-2[wm];[base][wm]overlay=15:H-h-15`.
- **Mode Pro (`isPro`)** :
  - Aucun filigrane n'est appliqué sur les segments exportés.

#### Paramètres de Découpe
Dans `TimeSlicingSheet`, l'utilisateur dispose de deux modes de sélection de durée :
1. **Mode Custom** :
   - Choix de durées prédéfinies : 3, 5, 10, 15, 30, 60 secondes.
   - Curseur de sélection (Slider) pour définir précisément une durée personnalisée entre 1s et 60s.
2. **Presets Réseaux Sociaux (Social Presets)** :
   - Une barre rapide permet de sélectionner les formats officiels :
     - **Facebook** : 60 secondes.
     - **Instagram** : 60 secondes.
     - **Tiktok** : 15 secondes.
     - **Whatsapp** : 60 secondes.

#### Flux de Découpe

```
1. Sélection vidéo (FilePicker ou partage d'intent)
2. Analyse de la taille et de la durée totale (vérification des limites Pro/Free)
3. Choix de la durée (TimeSlicingSheet - custom ou presets réseaux sociaux)
4. Lancement du découpage asynchrone dans ProcessingView
5. Superposition facultative du filigrane si l'utilisateur est gratuit
6. Fin du découpage et redirection vers la grille des segments (ResultView)
7. Option de partage ou de sauvegarde galerie
```

### 2. Gestion des Fichiers et Dossiers

#### Structure de Sauvegarde

L'enregistrement dans la galerie utilise le package **`gal`** pour une compatibilité native et simplifiée sur Android et iOS.

**Android**:
- Dossier temporaire : `{ExternalStorage}/Android/data/com.meetsum.cutIt/files/`
- Dossier permanent dans la galerie : Géré via `Gal.putVideo()`

**iOS**:
- Dossier temporaire : `{ApplicationDocumentsDirectory}/`
- Dossier permanent dans la galerie : Géré via `Gal.putVideo()` après demande de permission `Permission.photos`

#### Opérations sur les Dossiers

- **Création**: Automatique lors de la sauvegarde.
- **Renommage**: Via `FileService.renameFolder()`.
- **Suppression**: Via `FileService.deleteFolders()` avec le widget `DeletionDialog`.
- **Nommage**: `{baseFolderName}-{timestamp}`.

### 3. Partage de Vidéos

#### Réception de Vidéos Partagées

L'application supporte le partage de vidéos depuis d'autres applications :

1. **Via Intent Android / Share Extension iOS**
   - Utilise `flutter_sharing_intent` pour Android.
   - Extension iOS `CutitShareExtension` pour iOS.
   - Stream en temps réel avec `getMediaStream()`.

2. **Gestion des États**
   - Application en mémoire : Stream actif.
   - Application lancée via partage : `getInitialSharing()`.
   - Écoute continue via `SharingService` sur iOS pour intercepter les fichiers temporaires dans le App Group (`group.com.meetsum.cutit`).

#### Partage de Segments

- Partage multiple de fichiers via `share_plus` sous forme de liste de `XFile`.
- Analytics : Suivi des statistiques de partage via `AnalyticsService.videoShared`.
- Publicités : Une publicité interstitielle est déclenchée après l'action de partage (uniquement pour les utilisateurs gratuits).

### 4. Internationalisation (i18n)

#### Langues Supportées

##### Actives
- 🇫🇷 **Français** (`fr`)
- 🇺🇸 **English** (`en`)
- 🇪🇸 **Español** (`es`)
- 🇵🇹 **Português** (`pt`)
- 🇸🇦 **العربية** (`ar`)

##### Planifiées (Commentées dans le code)
- 🇩🇪 **Deutsch** (`de`)
- 🇮🇹 **Italiano** (`it`)
- 🇳🇱 **Nederlands** (`nl`)
- 🇷🇺 **Русский** (`ru`)
- 🇹🇷 **Türkçe** (`tr`)
- 🇨🇳 **中文** (`zh`)

#### Système de Traductions

- Utilise `GetX Translations` avec la classe `Localization`.
- Sauvegarde de la langue sélectionnée dans le cache local `CacheHelper` sous la clé `selected_language_key`.

---

## 🔒 Monétisation et Abonnements Pro (RevenueCat)

L'application intègre un modèle Freemium robuste basé sur **RevenueCat**.

### Entitlement et Produits
- **Entitlement ID** : `Cutit Pro`
- **Produits configurés** :
  - `cutit_monthly` : Abonnement mensuel
  - `cutit_yearly` : Abonnement annuel

### API Keys
- Android : `goog_BEgzcIzQuqrLjGZaSnfLEjSqpNV`
- iOS : `appl_NycGQMwdBmSQQHlkJxhLwBKhxWC`

### Fonctionnalités Premium (Pro)
L'accès Premium débloque les avantages suivants :
1. **Pas de filigrane** : Suppression du logo Cutit en bas des vidéos découpées.
2. **Export HD (1080p Full HD)** : Possibilité d'exporter les vidéos avec `VideoQuality.HighestQuality`.
3. **Sans publicité** : Suppression totale de la bannière AdMob et des publicités interstitielles/App Open.
4. **Limites de taille accrues** :
   - Taille maximale de vidéo : **1.5 Go** (vs 150 Mo pour les utilisateurs gratuits).
   - Durée maximale de vidéo : **1 heure** (vs 10 minutes pour les utilisateurs gratuits).

### Intégration UI / Paywall
- Le paywall RevenueCat est présenté via `RevenueCatUI.presentPaywallIfNeeded` ou `presentPaywall`.
- En cas de succès d'achat, l'utilisateur est redirigé vers le widget `PremiumSuccessView`.
- Une option "Restauration des achats" est disponible dans les paramètres pour restaurer les droits sur un nouvel appareil.

### Alternative pour les utilisateurs gratuits : Export HD via Publicité Récompensée (Rewarded Ad)
Les utilisateurs n'ayant pas d'abonnement Pro actif peuvent temporairement déverrouiller l'export HD (1080p) pour leur découpage en cours en regardant une publicité vidéo récompensée (`AdMobService.showRewardedAd`).

---

## 📢 Publicités (Google AdMob)

Les publicités sont affichées uniquement pour les utilisateurs non Premium.

### Types de Publicités
1. **Bannière (Banner Ad)** : Affichage persistant en haut ou en bas de l'écran d'accueil (`HomeView`). Détruite/disposée dès que l'utilisateur passe Pro.
2. **Interstitielle (Interstitial Ad)** : Affichage plein écran déclenché après sauvegarde en galerie ou partage de segments.
3. **Récompensée (Rewarded Ad)** : Utilisée pour déverrouiller l'export HD gratuitement.
4. **App Open Ad** : Affichée au retour de l'application au premier plan si l'absence dépasse 30 secondes (avec un cooldown de 1 minute).

---

## 📊 Analytics & Retours Utilisateurs (Firebase)

### Firebase Analytics
Le service `AnalyticsService` suit plusieurs événements clés pour optimiser le produit :
- **`video_imported`** : Suivi du fichier vidéo source (taille, durée, source d'importation).
- **`export_started` / `export_success` / `export_failed`** : Suivi de la performance de découpe.
- **`video_shared`** : Enregistrement du nombre de segments partagés.

### Retours Utilisateurs (FeedbackService)
L'application intègre un module de feedback qui enregistre les retours directement dans **Firebase Firestore** (collection `feedbacks`).
- **Types de Feedback** :
  - `manual` : Remonté manuellement par l'utilisateur depuis l'écran `FeedbacksView` pour soumettre des avis ou des rapports de bugs.
  - `automatic` : Remontées automatiques d'erreurs techniques ou d'échecs de découpe.
- **Métadonnées collectées** :
  - Informations de l'appareil (modèle, OS, version SDK via `device_info_plus`).
  - Informations de l'application (version, build via `package_info_plus`).
  - Métadonnées de la vidéo concernée (taille, durée, chemin, etc.).
  - Logs et détails de l'erreur rencontrée.

---

## 🔄 Système de Mises à jour (UpdateService)

L'application intègre un gestionnaire de mise à jour basé sur le package **`versionarte`** lié à **Firebase Remote Config** (clé `app_version`).
- L'application vérifie la présence de mises à jour au démarrage de l'application et au retour au premier plan (`AppLifecycleState.resumed`).
- **Types de mises à jour** :
  - **Mise à jour facultative** : Propose à l'utilisateur de mettre à jour, mais lui permet de continuer à utiliser l'application.
  - **Mise à jour forcée** : Bloque l'accès à l'application avec un écran flouté et affiche la boîte de dialogue `AppUpdateDialog` non fermable, redirigeant vers le store respectif.

---

## 🔧 Services Détaillés

### `ConfigService`
- **Responsabilité** : Chargement et synchronisation de Firebase Remote Config.
- **Variables** : `isProVersionEnabled` (permet d'activer/désactiver globalement les options payantes et les paywalls).

### `RevenueCatService`
- **Responsabilité** : Initialisation du SDK Purchases, écoute des changements d'abonnements, gestion des achats et restaurations.

### `FeatureManager`
- **Responsabilité** : Centralise les règles d'accès au contenu Pro. Utilise de façon combinée le statut réactif de `RevenueCatService` et le feature flag de `ConfigService`.

### `FeedbackService`
- **Responsabilité** : Envoi de documents structurés à Firestore pour centraliser les rapports de bugs et feedbacks utilisateur.

### `UpdateService`
- **Responsabilité** : Vérification asynchrone des versions locales vs distantes via Versionarte.

### `VideoService`
- **Responsabilité** : Traitement de découpage avec FFmpeg, compression vidéo standard ou HD, et encapsulation des fonctions de partage/sauvegarde de fichiers.

---

## 📦 Dépendances Principales (pubspec.yaml)

- **`get: ^4.7.2`** : Gestion d'état et navigation.
- **`ffmpeg_kit_flutter_new: ^4.1.0`** : Traitement vidéo haute performance.
- **`video_player: ^2.11.1`** : Lecteur vidéo natif.
- **`video_compress: ^3.1.4`** : Compression des exports vidéos.
- **`purchases_flutter: ^10.0.1` / `purchases_ui_flutter: ^10.0.1`** : Achats In-App & Paywalls RevenueCat.
- **`google_mobile_ads: ^8.0.0`** : Intégration publicitaire AdMob.
- **`cloud_firestore: ^6.3.0`** : Base de données des retours utilisateur.
- **`versionarte: any`** : Vérification des versions de l'application.
- **`gal: ^2.3.2`** : Sauvegarde efficace dans la galerie.
- **`permission_handler: ^12.0.1`** : Gestion des droits système.
- **`flutter_sharing_intent: ^2.0.4`** : Réception de vidéos partagées.
- **`device_info_plus: ^11.0.0`** / **`package_info_plus: ^8.1.0`** : Collecte d'informations d'environnement.
- **`hugeicons: ^1.1.6`** : Pack d'icônes vectorielles.

---

## 📝 Notes Techniques et Limitations

1. **Plateforme** : Android et iOS uniquement. FFmpeg n'est pas configuré pour le Web ou Desktop dans ce projet.
2. **Gestion Mémoire** : Pour éviter les fuites de mémoire, toutes les instances de `VideoPlayerController` créées pour les segments de prévisualisation dans `HomeController` sont stockées dans une map et systématiquement disposées via `disposeVideoControllers()` lors du nettoyage.
3. **Nettoyage automatique** : Les fragments générés par FFmpeg d'une durée inférieure à 1 seconde sont exclus automatiquement pour éviter les vidéos corrompues ou illisibles.

---

**Documentation générée pour**: Cutit v1.1.4+42
**Dernière mise à jour**: Mai 2026

---
_Développé avec ❤️ en Flutter_
