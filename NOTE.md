# Plan Gratuit - Fonctionnalités et Limites Actuelles

Ce document recense les fonctionnalités disponibles et les limites du plan gratuit dans l'état actuel de l'application (basé sur le code source).

## ✅ Fonctionnalités (Free Plan)

L'application est actuellement entièrement gratuite avec un modèle financé par la publicité.

### 🎥 Découpage Vidéo

- **Découpage Automatique** : Segmentation intelligente des vidéos en durées prédéfinies (10s, 30s, 60s) ou personnalisées.
- **Support Multi-Segements** : Création simultanée de plusieurs segments.
- **Qualité Optimisée** : Utilisation de FFmpeg pour préserver la qualité vidéo lors de la découpe.
- **Filtrage Intelligent** : Suppression automatique des micro-segments (< 1 seconde) pour éviter les erreurs.

### 📤 Partage et Export

- **Sauvegarde Locale** : Enregistrement direct des segments dans la galerie de l'appareil.
- **Partage Direct** : Partage natif vers les applications sociales (WhatsApp, Instagram, TikTok, YouTube Shorts, etc.).
- **Aucun Filigrane (Watermark)** : Actuellement, le code n'applique pas de filigrane visible sur les vidéos exportées.

### 📁 Organisation

- **Gestion par Dossiers** : Création et gestion de dossiers personnalisés pour organiser les découpages.
- **Prévisualisation** : Lecture des segments découpés avant export.

### 👤 Compte Utilisateur

- **Accès Immédiat** : Aucune création de compte ou connexion requise ("Pas besoin de créer un compte").

---

## ⚠️ Limites et Contraintes

### 📢 Publicités (Monétisation)

Le plan gratuit inclut des publicités via **Google AdMob** :

1. **Bannières (Banners)** : Affichées sur l'écran d'accueil et les écrans principaux (`HomeController`).
2. **Interstitiels (Plein Écran)** : Déclenchés obligatoirement après chaque action d'export ou de partage (`VideoService`).
   - S'affichent après `saveVideos()` (Sauvegarde galerie).
   - S'affichent après `shareVideos()` (Partage social).

### 🔒 Fonctionnalités Premium (À venir)

- Une section **Premium** est présente dans l'interface mais indique "Upgrade to Cutit Premium coming soon!".
- Cela suggère que certaines fonctionnalités actuelles pourraient devenir payantes ou que de nouvelles fonctionnalités exclusives seront ajoutées (ex: suppression des pubs, formats avancés, cloud storage, etc.).

### 📱 Contraintes Techniques

- **Plateforme** : Le découpage est limité aux plateformes mobiles (Android & iOS) supportées par `FFmpegKit`. Le web n'est pas supporté.
- **Formats** : Dépend des codecs supportés par l'OS et FFmpeg.
