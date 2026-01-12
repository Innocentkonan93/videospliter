# 📚 Documentation Complète de Cutit

## 📱 Présentation Générale

**Cutit** (nom interne: `video_spliter`) est une application mobile cross-platform développée en Flutter qui permet aux utilisateurs de découper automatiquement des vidéos longues en segments courts pour faciliter leur partage sur les réseaux sociaux (TikTok, Instagram, WhatsApp, YouTube Shorts, etc.).

### Informations Générales

- **Nom de l'application**: Cutit
- **Version**: 1.0.3+30
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
│   │   ├── bot_service.dart              # Service bot (si applicable)
│   │   ├── file_service.dart             # Gestion des fichiers/dossiers
│   │   ├── firebase_notification_service.dart  # Notifications Firebase
│   │   ├── firebase_service.dart         # Service Firebase principal
│   │   ├── local_notifications_service.dart    # Notifications locales
│   │   ├── localization.dart             # Internationalisation (i18n)
│   │   ├── save_segments_service.dart    # Sauvegarde des segments
│   │   ├── sharing_service.dart          # Réception de vidéos partagées
│   │   └── video_service.dart            # Traitement vidéo (FFmpeg)
│   │
│   ├── utils/                     # Utilitaires
│   │   ├── constants.dart        # Constantes de l'application
│   │   ├── methods_utils.dart    # Méthodes utilitaires
│   │   └── responsive.dart       # Responsive design
│   │
│   └── widgets/                   # Widgets réutilisables
│       ├── custom_video_player_view.dart
│       ├── deletion_dialog.dart
│       ├── folder_item.dart
│       ├── folder_name_dialog.dart
│       ├── folder_options.dart
│       ├── language_selection_sheet.dart
│       ├── premium_card.dart
│       └── time_slicing_sheet.dart
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

L'application propose **trois méthodes** de découpage vidéo:

1. **`splitVideo()`** - Méthode basique (non utilisée en production)

   - Utilise `-c copy` pour une copie rapide sans ré-encodage
   - Moins fiable pour certaines vidéos

2. **`splitBySS()`** - Découpe synchrone séquentielle

   - Découpe séquentielle segment par segment
   - Utilise `-ss` (seek start) et `-t` (duration)
   - Ré-encodage avec codec MPEG4 et qualité élevée (`-qscale:v 2`)
   - Gère la progression via le contrôleur

3. **`splitBySSAsync()`** - Découpe asynchrone (méthode principale)
   - Découpe asynchrone avec `FFmpegKit.executeAsync()`
   - Progression fine via callbacks `onStatistics`
   - Utilise `-movflags +faststart` pour lecture rapide
   - Crop automatique pour éviter dimensions impaires
   - Codec: MPEG4 pour vidéo, AAC pour audio (128k)

#### Paramètres de Découpe

- **Durées prédéfinies**: 3, 5, 10, 15, 30, 60 secondes (configurable)
- **Durée par défaut**: 30 secondes
- **Qualité vidéo**: `-qscale:v 2` (haute qualité, 1-31 échelle)
- **Audio**: AAC 128k bitrate
- **Format de sortie**: MP4

#### Flux de Découpe

```
1. Sélection vidéo (FilePicker ou partage)
2. Analyse de la durée totale (FFprobe)
3. Calcul du nombre de segments
4. Découpe asynchrone avec progression
5. Génération des fichiers temporaires
6. Affichage des résultats
7. Sélection et sauvegarde/partage
```

### 2. Gestion des Fichiers et Dossiers

#### Structure de Sauvegarde

**Android**:

- Chemin: `/storage/emulated/0/Android/data/com.meetsum.cutIt/files/Cutit/{folderName}/`
- Utilise `getExternalStorageDirectory()`

**iOS**:

- Chemin: `{ApplicationDocumentsDirectory}/Cutit/{folderName}/`
- Utilise `getApplicationDocumentsDirectory()`

#### Opérations sur les Dossiers

- **Création**: Automatique lors de la sauvegarde
- **Renommage**: Via `FileService.renameFolder()`
- **Suppression**: Via `FileService.deleteFolders()` avec confirmation
- **Nommage**: `{baseFolderName}-{timestamp}` (ex: `MyVideos-1698765432`)

### 3. Partage de Vidéos

#### Réception de Vidéos Partagées

L'application supporte la réception de vidéos depuis d'autres applications:

1. **Via Intent Android / Share Extension iOS**

   - Utilise `flutter_sharing_intent` pour Android
   - Extension iOS `CutitShareExtension` pour iOS
   - Stream en temps réel avec `getMediaStream()`

2. **Gestion des États**
   - Application en mémoire: Stream actif
   - Application lancée via partage: `getInitialSharing()`

#### Partage de Segments

- Partage multiple de fichiers via `share_plus`
- Format: Liste de `XFile`
- Analytics: Suivi du nombre de segments partagés
- Publicité: Affichage d'une publicité interstitielle après partage

### 4. Internationalisation (i18n)

#### Langues Supportées

- 🇫🇷 **Français** (`fr`)
- 🇺🇸 **English** (`en`)
- 🇪🇸 **Español** (`es`)
- 🇵🇹 **Português** (`pt`)
- 🇸🇦 **العربية** (`ar`)

#### Système de Traductions

- Utilise `GetX Translations` avec classe `Localization`
- Plus de 100 clés de traduction
- Sauvegarde de la langue sélectionnée dans le cache
- Changement de langue en temps réel

#### Clés de Traduction Principales

- Écrans d'introduction
- Messages d'erreur et de succès
- Paramètres et options
- Guides et instructions
- Formulaires de contact

### 5. Système de Notations (In-App Review)

#### Stratégie de Notation

L'application utilise une stratégie intelligente pour demander des notations:

**Conditions d'Affichage**:

- Seuil de lancements: 5 lancements minimum (optionnel selon le contexte)
- Durée minimale d'installation: 7 jours (optionnel selon le contexte)
- Cooldown entre demandes: 30 jours

**Moment d'Affichage**:

1. **Au lancement**: Après 5 lancements et 7 jours d'utilisation
2. **Après découpage**: Ignore les seuils pour prompt rapide
3. **Après partage**: Ignore les seuils pour prompt rapide
4. **Manuel**: Via les paramètres

**Gestion**:

- Désactivation permanente après réponse de l'utilisateur
- Utilise `InAppReview` pour affichage natif
- Fallback vers page de l'App Store/Play Store si indisponible

### 6. Publicités (AdMob)

#### Types de Publicités

1. **Bannière (Banner Ad)**

   - Affichage permanent en bas de l'écran principal
   - Taille adaptative
   - Rechargement automatique

2. **Interstitielle (Interstitial Ad)**

   - Affichage après sauvegarde de segments
   - Affichage après partage de vidéos
   - Affichage après retour en avant-plan (>30 secondes)

3. **Récompensée (Rewarded Ad)**
   - Affichage tous les 5 découpages réussis
   - Réinitialisation du compteur après visionnage

#### Stratégie d'Affichage

- **Après actions positives**: Sauvegarde, partage
- **Gestion du cycle de vie**: Publicité après retour en avant-plan
- **Cooldown**: 3 minutes entre interstitielles
- **Analytics**: Suivi des impressions et interactions

### 7. Analytics (Firebase Analytics)

#### Événements Suivis

1. **Import de Vidéo**

   - Durée de la vidéo (secondes)
   - Taille du fichier (MB)
   - Source (file_picker, share, etc.)

2. **Export/Sauvegarde**

   - Nombre de segments
   - Temps d'export (secondes)
   - Taille totale (MB)
   - Format d'export
   - Statut (succès/échec)

3. **Partage**

   - Nombre de segments partagés

4. **Erreurs**
   - Raison de l'échec
   - Contexte de l'erreur

### 8. Notifications

#### Types de Notifications

1. **Notifications Locales**

   - Notification après découpage terminé
   - Utilise `flutter_local_notifications`

2. **Notifications Firebase (Push)**
   - Notifications à distance
   - Gestion des tokens FCM
   - Intégration avec Firebase Cloud Messaging

### 9. Permissions

#### Permissions Requises

**Android**:

- `Permission.storage` - Accès au stockage

**iOS**:

- `Permission.photos` - Accès à la photothèque

#### Gestion

- Demande automatique avant sélection de fichier
- Vérification du statut
- Messages d'erreur si refusé

---

## 🔧 Services Détaillés

### VideoService

**Responsabilité**: Traitement vidéo avec FFmpeg

**Méthodes principales**:

- `splitVideo()` - Découpe basique
- `splitBySS()` - Découpe synchrone
- `splitBySSAsync()` - Découpe asynchrone (production)
- `shareVideos()` - Partage de segments

**Dépendances**:

- `ffmpeg_kit_flutter_new` - FFmpeg
- `path_provider` - Dossiers temporaires

### HomeController

**Responsabilité**: Orchestration principale de l'application

**Propriétés observables**:

- `selectedVideo` - Vidéo sélectionnée
- `videoParts` - Segments générés
- `selectedVideoParts` - Segments sélectionnés
- `progress` - Progression du découpage (0.0 - 1.0)
- `sliceDuration` - Durée des segments
- `currentPage` - Page actuelle

**Méthodes principales**:

- `pickVideo()` - Sélection de vidéo
- `splitVideoIsolate()` - Lancement du découpage
- `saveSegments()` - Sauvegarde des segments
- `initSharingListener()` - Écoute des partages
- `initVideoControllers()` - Gestion des lecteurs vidéo

**Cycle de vie**:

- `onInit()` - Initialisation (publicités, listeners)
- `onClose()` - Nettoyage (dispose controllers)
- `didChangeAppLifecycleState()` - Gestion avant-plan/arrière-plan

### SaveSegmentsService

**Responsabilité**: Sauvegarde des segments sur le disque

**Fonctionnalités**:

- Création de dossiers avec nom personnalisé
- Copie des fichiers depuis le dossier temporaire
- Analytics: Suivi du temps d'export
- Gestion d'erreurs avec messages traduits

### FileService

**Responsabilité**: Opérations sur les dossiers

**Méthodes**:

- `deleteFolders()` - Suppression récursive
- `renameFolder()` - Renommage de dossiers

### AdMobService

**Responsabilité**: Gestion des publicités Google AdMob

**Fonctionnalités**:

- Chargement de bannières, interstitielles, récompensées
- Gestion du cycle de vie des publicités
- Callbacks pour événements publicitaires

### AnalyticsService

**Responsabilité**: Suivi analytique Firebase

**Méthodes principales**:

- `initialize()` - Initialisation
- `videoImported()` - Suivi import
- `exportStarted()` / `exportSuccess()` / `exportFailed()` - Suivi export
- `videoShared()` - Suivi partage

### AppService

**Responsabilité**: Services généraux de l'application

**Fonctionnalités**:

- Gestion des notations in-app
- Partage de l'application (lien App Store/Play Store)
- Stratégie de timing pour les demandes de notation

### SharingService

**Responsabilité**: Réception de vidéos partagées (iOS Extension)

**Fonctionnalités**:

- Écoute via MethodChannel iOS
- Gestion des UserDefaults partagés (App Group)
- Timer périodique pour vérification (2 secondes)

### Localization

**Responsabilité**: Internationalisation

**Structure**:

- Classe `Translations` de GetX
- Map par langue (`en`, `fr`, `es`, `pt`, `ar`)
- Plus de 100 clés de traduction

---

## 🎨 Interface Utilisateur

### Thème et Design

#### Couleurs Principales

```dart
- Primary: #4A25CC (Violet)
- Secondary: #A492E5 (Violet clair)
- Background: #F5F6FA (Gris très clair)
- White: #FFFFFF
- Black: #000000
- Grey: #A7A7A7
- Red: #BE332E
- Green: #367562
- Orange: #E09215
```

#### Typographie

- **Police principale**: Poppins (via Google Fonts)
- **Police secondaire**: Jost (pour labels)
- **Material Design 3**: Activé (`useMaterial3: true`)

#### Composants UI

- **Cards**: Fond sombre (#302929)
- **Inputs**: Fond gris clair avec bordures arrondies
- **AppBar**: Centré, fond blanc
- **Boutons**: Style Material avec couleurs primaires

### Navigation

#### Routes Principales

1. `/introduction` - Écran d'introduction (route initiale)
2. `/home` - Écran principal (découpe vidéo)
3. `/settings` - Paramètres

#### Navigation Interne (HomeView)

Utilise `PageController` avec 3 pages:

1. **Page 0**: Sélection de vidéo
2. **Page 1**: Mes découpages (segments sauvegardés)
3. **Page 2+**: Résultats et prévisualisation

### Écrans Principaux

#### 1. IntroductionView

- Carousel d'introduction avec 5 pages
- Images: cut.png, upload.png, timer.png, sharing.png, bell.png
- Boutons "Skip" et "Later"
- Animation avec `flutter_animate`

#### 2. HomeView

- **Page 0**: Sélection de vidéo
  - Bouton "Charger une vidéo"
  - Affichage de la vidéo sélectionnée
  - Paramétrage de la durée
  - Bouton "Découper"
- **Page 1**: Mes découpages
  - Liste des dossiers sauvegardés
  - Prévisualisation des segments
  - Options de dossier (renommer, supprimer)
- **Page 2+**: Résultats
  - Grille de prévisualisation des segments
  - Sélection multiple
  - Boutons "Partager" et "Enregistrer"

#### 3. SettingsView

- Liste d'options:
  - Comment ça marche?
  - Contactez-nous
  - Signaler un problème
  - Noter l'application
  - Partager l'application
  - Langue
  - Politique de confidentialité
  - À propos

#### 4. ProgressingView

- Indicateur de progression (pourcentage)
- Messages motivants pendant le découpage
- Animation Lottie

---

## 📦 Dépendances Principales

### Core Flutter

- `flutter`: SDK Flutter
- `cupertino_icons`: Icônes iOS

### Gestion d'État et Navigation

- `get: ^4.7.2` - GetX (état, navigation, dépendances)

### Traitement Vidéo

- `ffmpeg_kit_flutter_new: ^1.2.1` - FFmpeg Kit
- `video_player: ^2.9.5` - Lecteur vidéo
- `file_picker: ^10.1.9` - Sélection de fichiers

### Firebase

- `firebase_core: ^3.13.1` - Core Firebase
- `firebase_analytics: ^11.4.6` - Analytics
- `firebase_crashlytics: any` - Crashlytics
- `firebase_messaging: ^15.2.6` - Cloud Messaging
- `firebase_storage: ^12.4.7` - Storage (optionnel)

### Publicités

- `google_mobile_ads: ^6.0.0` - AdMob

### Partage et Communication

- `share_plus: ^11.0.0` - Partage système
- `flutter_sharing_intent: ^1.1.1` - Réception de partages
- `url_launcher: ^6.3.2` - Ouverture d'URLs

### Permissions et Stockage

- `permission_handler: ^11.3.1` - Permissions
- `path_provider: ^2.0.13` - Dossiers système
- `shared_preferences: ^2.5.3` - Stockage local

### Notifications

- `flutter_local_notifications: ^18.0.0` - Notifications locales

### UI/UX

- `flutter_animate: ^4.5.2` - Animations
- `lottie: ^3.3.1` - Animations Lottie
- `google_fonts: ^6.3.3` - Polices Google
- `percent_indicator: ^4.2.5` - Indicateurs de progression
- `animated_digit: ^3.2.3` - Chiffres animés

### Utilitaires

- `intl: ^0.20.2` - Internationalisation
- `package_info_plus: ^8.3.0` - Infos de l'app
- `in_app_review: ^2.0.10` - Notation in-app
- `image_picker: ^1.1.2` - Sélection d'images
- `path: ^1.8.3` - Manipulation de chemins

### Analytics Externe

- `clarity_flutter: ^1.0.0` - Microsoft Clarity

---

## 🔐 Configuration et Sécurité

### Firebase Configuration

#### Fichiers Requis

**Android**:

- `android/app/google-services.json`
- Téléchargé depuis Firebase Console

**iOS**:

- `ios/Runner/GoogleService-Info.plist`
- Téléchargé depuis Firebase Console

#### Initialisation

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform
);
```

### AdMob Configuration

#### IDs Publicitaires

Les IDs AdMob doivent être configurés dans `AdMobService`:

- Banner Ad Unit ID
- Interstitial Ad Unit ID
- Rewarded Ad Unit ID

**Note**: Les IDs de test sont utilisés en développement.

### Permissions (Android)

#### android/app/src/main/AndroidManifest.xml

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

### Permissions (iOS)

#### ios/Runner/Info.plist

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Accès à la photothèque pour sélectionner des vidéos</string>
```

### Extension iOS (Share Extension)

L'application inclut une extension iOS pour recevoir des vidéos partagées:

- **Target**: `CutitShareExtension`
- **App Group**: `group.com.meetsum.cutit`
- **Method Channel**: `com.meetsum.cutit/sharing`

---

## 🚀 Déploiement

### Build Android

#### APK de Développement

```bash
flutter build apk --debug
```

#### APK de Production

```bash
flutter build apk --release
```

#### App Bundle (Play Store)

```bash
flutter build appbundle --release
```

#### Configuration de Signature

Fichier: `android/key.properties`

```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=path/to/upload-keystore.jks
```

### Build iOS

#### Configuration Requise

- Xcode installé
- Certificats de développement/distribution
- Provisioning profiles

#### Build

```bash
flutter build ios --release
```

#### Archive dans Xcode

1. Ouvrir `ios/Runner.xcworkspace`
2. Product > Archive
3. Distribuer l'App

### Versioning

La version est définie dans `pubspec.yaml`:

```yaml
version: 1.0.3+30
```

- `1.0.3` = Version (semver)
- `30` = Build number (incrementé à chaque build)

---

## 📊 Flux d'Utilisation Typique

### Scénario 1: Découpage depuis la Galerie

```
1. Utilisateur lance l'application
   → Écran d'introduction (si première fois)

2. Utilisateur sélectionne "Charger une vidéo"
   → Demande de permission (si nécessaire)
   → FilePicker s'ouvre

3. Utilisateur choisit une vidéo
   → Vidéo affichée dans HomeView
   → Durée configurable (défaut: 30s)

4. Utilisateur appuie sur "Découper"
   → ProgressingView affichée
   → Découpage asynchrone avec FFmpeg
   → Progression affichée en temps réel

5. Découpage terminé
   → ResultView avec grille de segments
   → Sélection possible des segments

6. Utilisateur appuie sur "Enregistrer"
   → Dialogue pour nommer le dossier
   → Sauvegarde des segments
   → Publicité interstitielle
   → Retour à "Mes découpages"
```

### Scénario 2: Partage depuis une Autre Application

```
1. Utilisateur partage une vidéo depuis la galerie/autre app
   → Extension iOS / Intent Android intercepte

2. Application Cutit s'ouvre (ou passe au premier plan)
   → Vidéo automatiquement chargée
   → HomeController.handleSharedVideo()

3. Suite identique au scénario 1 à partir de l'étape 3
```

### Scénario 3: Partage de Segments

```
1. Utilisateur dans "Mes découpages"
   → Sélectionne un dossier
   → Aperçu des segments

2. Utilisateur sélectionne des segments (ou tous)
   → Bouton "Partager" activé

3. Utilisateur appuie sur "Partager"
   → ShareSheet système s'ouvre
   → Utilisateur choisit l'application de destination

4. Partage réussi
   → Analytics enregistré
   → Publicité interstitielle
   → Demande de notation (conditionnelle)
```

---

## 🐛 Dépannage et Problèmes Courants

### Problème: Erreur FFmpeg

**Symptômes**: Échec du découpage, message d'erreur FFmpeg

**Solutions**:

1. Vérifier que la plateforme est supportée (Android/iOS uniquement)
2. Vérifier les logs FFmpeg via `session.getAllLogsAsString()`
3. Vérifier le format de la vidéo source
4. Vérifier l'espace de stockage disponible

### Problème: Vidéo non lisible après découpage

**Symptômes**: Segments générés mais non lisibles

**Solutions**:

1. Vérifier le codec utilisé (mpeg4)
2. Vérifier les dimensions (crop pour éviter impaires)
3. Vérifier les flags `-movflags +faststart`
4. Tester avec une autre vidéo source

### Problème: Permissions refusées

**Symptômes**: Impossible de sélectionner des vidéos

**Solutions**:

1. Vérifier les permissions dans les paramètres système
2. Redémarrer l'application après accord
3. Vérifier les déclarations dans AndroidManifest.xml / Info.plist

### Problème: Publicités non affichées

**Symptômes**: Pas de publicités ou erreurs AdMob

**Solutions**:

1. Vérifier la configuration AdMob (IDs)
2. Vérifier la connectivité réseau
3. Utiliser les IDs de test en développement
4. Vérifier les logs AdMob

### Problème: Partage iOS ne fonctionne pas

**Symptômes**: Extension iOS ne reçoit pas les vidéos

**Solutions**:

1. Vérifier l'App Group configuré
2. Vérifier le Method Channel
3. Vérifier les UserDefaults partagés
4. Vérifier les logs du SharingService

---

## 🔄 Maintenance et Évolutions Futures

### Points d'Attention

1. **Performance Vidéo**

   - Optimisation FFmpeg pour vidéos très longues
   - Gestion mémoire pour gros fichiers
   - Compression optionnelle

2. **Qualité Vidéo**

   - Support de codecs supplémentaires (H.264, H.265)
   - Options de qualité configurables
   - Prévisualisation avant découpage

3. **Fonctionnalités**

   - Découpage manuel (points de coupure)
   - Filtres et effets
   - Export vers formats spécifiques (TikTok, Instagram)
   - Watermark personnalisé

4. **Monétisation**

   - Abonnement premium
   - Suppression des publicités
   - Fonctionnalités avancées

5. **Analytics**
   - Dashboard analytics
   - A/B testing
   - Suivi de rétention

---

## 📞 Support et Contribution

### Structure de Code

- **GetX Pattern**: Respecter l'architecture GetX (Controllers, Bindings, Views)
- **Nommage**: Noms descriptifs en français pour variables locales
- **Documentation**: Commenter les fonctions complexes
- **Tests**: Ajouter des tests pour nouvelles fonctionnalités

### Guidelines

- Suivre les conventions Flutter/Dart
- Utiliser le linter configuré (`flutter_lints`)
- Tester sur Android et iOS
- Vérifier la performance
- Respecter les règles d'accessibilité

### Contact

- **Site web**: https://cutitapp.net
- **Politique de confidentialité**: https://cutitapp.net/privacy-policy
- **App Store**: https://apps.apple.com/us/app/cutit-découpage-de-vidéos/id6747193487
- **Play Store**: https://play.google.com/store/apps/details?id=com.meetsum.cutIt

---

## 📝 Notes Techniques Importantes

### Limitations

1. **Plateformes**: Android et iOS uniquement (pas de Web/Linux/Windows pour FFmpeg)
2. **Taille de vidéo**: Dépend de la mémoire disponible
3. **Formats**: Principalement MP4 (autres formats peuvent nécessiter conversion)
4. **Performance**: Découpage peut prendre du temps pour vidéos longues

### Bonnes Pratiques

1. **Gestion Mémoire**: Toujours disposer les VideoPlayerController
2. **Erreurs**: Toujours capturer et logger les erreurs FFmpeg
3. **Permissions**: Vérifier avant chaque opération de fichier
4. **Analytics**: Ne pas bloquer l'UI avec les appels analytics
5. **Publicités**: Respecter les cooldowns pour éviter saturation

---

**Documentation générée pour**: Cutit v1.0.3+30
**Dernière mise à jour**: 2024

---

_Développé avec ❤️ en Flutter_
