# 🎬 Cut It - Découpeur de Vidéos Flutter

## 📱 Description

**Cut It** est une application mobile Flutter moderne et intuitive qui permet aux utilisateurs de découper, partager et enregistrer des vidéos en quelques clics. L'application utilise FFmpeg pour le traitement vidéo et offre une interface utilisateur élégante avec des animations fluides.

## ✨ Fonctionnalités Principales

### 🎥 Découpe Vidéo
- **Découpe automatique** : Découpage de vidéos en segments de durée configurable
- **Prévisualisation** : Aperçu des segments créés avant sauvegarde
- **Qualité optimisée** : Utilisation d'algorithmes FFmpeg pour une qualité vidéo préservée
- **Support multi-format** : Compatible avec les formats vidéo courants (MP4, AVI, MOV, etc.)

### 📁 Gestion des Fichiers
- **Sélection de vidéos** : Import depuis la galerie ou partage d'autres applications
- **Organisation** : Création de dossiers personnalisés pour organiser les segments
- **Sauvegarde locale** : Stockage des vidéos découpées sur l'appareil
- **Partage** : Envoi des segments via les applications de partage du système

### 🎨 Interface Utilisateur
- **Design moderne** : Interface Material Design avec dégradés et animations
- **Navigation intuitive** : Navigation par pages avec PageView vertical
- **Thème personnalisable** : Palette de couleurs cohérente et thème adaptatif
- **Animations fluides** : Transitions et animations avec Flutter Animate

### 🔧 Fonctionnalités Avancées
- **Gestion des permissions** : Demande automatique des permissions nécessaires
- **Notifications Firebase** : Système de notifications push intégré
- **Analytics** : Suivi des utilisations avec Firebase Analytics
- **Publicités** : Intégration AdMob pour la monétisation
- **Cache intelligent** : Gestion optimisée de la mémoire et du stockage

## 🏗️ Architecture Technique

### Structure du Projet
```
lib/
├── app/
│   ├── configs/           # Configuration de l'application
│   ├── modules/           # Modules fonctionnels
│   │   ├── home/         # Module principal (découpe vidéo)
│   │   ├── introduction/ # Module d'introduction
│   │   └── settings/     # Module des paramètres
│   ├── routes/           # Gestion des routes
│   ├── services/         # Services métier
│   ├── utils/            # Utilitaires
│   └── widgets/          # Widgets personnalisés
├── firebase_options.dart  # Configuration Firebase
└── main.dart             # Point d'entrée
```

### Technologies Utilisées

#### 🎯 Framework Principal
- **Flutter** : Framework de développement cross-platform
- **GetX** : Gestion d'état et navigation
- **Material Design** : Composants UI modernes

#### 🎬 Traitement Vidéo
- **FFmpeg Kit** : Découpe et traitement vidéo avancé
- **Video Player** : Lecture et prévisualisation des vidéos
- **File Picker** : Sélection de fichiers système

#### ☁️ Services Cloud
- **Firebase Core** : Infrastructure de base
- **Firebase Analytics** : Suivi des utilisations
- **Firebase Messaging** : Notifications push
- **Firebase Storage** : Stockage cloud (optionnel)

#### 📱 Fonctionnalités Mobile
- **Permission Handler** : Gestion des permissions système
- **Path Provider** : Accès aux dossiers système
- **Shared Preferences** : Stockage local des préférences
- **AdMob** : Intégration publicitaire

#### 🎨 Interface et UX
- **Flutter Animate** : Animations fluides
- **Google Fonts** : Typographie personnalisée
- **Lottie** : Animations vectorielles
- **Percent Indicator** : Indicateurs de progression

## 🚀 Installation et Configuration

### Prérequis
- Flutter SDK 3.7.0 ou supérieur
- Dart SDK compatible
- Android Studio / Xcode pour le développement mobile
- Compte Firebase (pour les fonctionnalités cloud)

### Installation

1. **Cloner le projet**
   ```bash
   git clone [URL_DU_REPO]
   cd cut_it
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Configuration Firebase**
   - Créer un projet Firebase
   - Télécharger `google-services.json` (Android) et `GoogleService-Info.plist` (iOS)
   - Placer les fichiers dans les dossiers appropriés

4. **Configuration AdMob** (optionnel)
   - Créer un compte AdMob
   - Configurer les IDs publicitaires dans `ad_mob_service.dart`

5. **Lancer l'application**
   ```bash
   flutter run
   ```

## 📱 Utilisation

### 1. Introduction
- L'application démarre par un écran d'introduction
- Présentation des fonctionnalités principales
- Navigation vers l'écran principal

### 2. Découpe Vidéo
- **Sélection** : Choisir une vidéo depuis la galerie
- **Configuration** : Définir la durée des segments (défaut : 30 secondes)
- **Traitement** : Lancer la découpe avec FFmpeg
- **Prévisualisation** : Aperçu des segments créés
- **Sauvegarde** : Enregistrer les segments dans un dossier personnalisé

### 3. Gestion des Segments
- **Visualisation** : Parcourir tous les segments créés
- **Sélection** : Choisir des segments spécifiques
- **Partage** : Envoyer des segments via d'autres applications
- **Organisation** : Créer des dossiers thématiques

### 4. Paramètres
- **À propos** : Informations sur l'application
- **Comment ça marche** : Guide d'utilisation
- **Contact** : Support et feedback
- **Évaluations** : Système de notation in-app

## 🔧 Configuration Avancée

### Variables d'Environnement
```dart
// Firebase
projectId: "votre_project_id"
apiKey: "votre_api_key"

// AdMob
bannerAdUnitId: "votre_banner_id"
interstitialAdUnitId: "votre_interstitial_id"
```

### Personnalisation des Couleurs
```dart
// lib/app/configs/app_colors.dart
abstract class AppColors {
  static const Color primary = Color(0XFF4A25CC);
  static const Color secondary = Color(0XFFA492E5);
  // Personnaliser selon vos besoins
}
```

### Configuration FFmpeg
```dart
// lib/app/services/video_service.dart
// Modifier les paramètres de qualité et de format
'-qscale:v', '2', // Qualité vidéo (1-31, plus bas = meilleure qualité)
'-c:v', 'mpeg4',  // Codec vidéo
```

## 📊 Performance et Optimisation

### Gestion Mémoire
- **Cache intelligent** : Nettoyage automatique des fichiers temporaires
- **Controllers vidéo** : Gestion optimisée des lecteurs vidéo
- **Streams** : Utilisation de StreamSubscription pour les données partagées

### Optimisation Vidéo
- **Segmentation** : Découpe par segments pour éviter la surcharge mémoire
- **Qualité adaptative** : Paramètres FFmpeg optimisés par plateforme
- **Traitement asynchrone** : Opérations non-bloquantes pour l'UI

## 🧪 Tests

### Tests Widget
```bash
flutter test test/widget_test.dart
```

### Tests d'Intégration
```bash
flutter test integration_test/
```

## 📦 Build et Déploiement

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web (optionnel)
```bash
flutter build web --release
```

## 🐛 Dépannage

### Problèmes Courants

1. **Erreur FFmpeg**
   - Vérifier que FFmpeg Kit est correctement installé
   - S'assurer que la plateforme est supportée (Android/iOS uniquement)

2. **Permissions refusées**
   - Vérifier les permissions dans les paramètres système
   - Redémarrer l'application après accord des permissions

3. **Vidéo non lisible**
   - Vérifier le format de la vidéo
   - S'assurer que le fichier n'est pas corrompu

4. **Problèmes de stockage**
   - Vérifier l'espace disponible sur l'appareil
   - Nettoyer le cache de l'application

## 🤝 Contribution

### Structure de Code
- **GetX Pattern** : Respecter l'architecture GetX
- **Nommage** : Utiliser des noms descriptifs en français
- **Documentation** : Commenter les fonctions complexes
- **Tests** : Ajouter des tests pour les nouvelles fonctionnalités

### Guidelines
- Suivre les conventions Flutter
- Utiliser le linter configuré
- Tester sur Android et iOS
- Vérifier la performance

## 📄 Licence

Ce projet est sous licence privée. Tous droits réservés.

## 📞 Support

Pour toute question ou problème :
- **Email** : [votre_email]
- **Issues** : Créer une issue sur le repository
- **Documentation** : Consulter ce README et les commentaires du code

---

**Développé avec ❤️ en Flutter**
