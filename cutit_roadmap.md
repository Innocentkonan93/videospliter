# 🚀 Roadmap Produit & Technique : Cut It

> [!NOTE]
> **Vision Globale** : Transformer Cut It d'un simple "Video Splitter" utilitaire en une application incontournable pour les créateurs de contenu sur mobile, en maximisant la rétention et les revenus (Freemium + Ads).

## 1. Analyse de l'existant
Actuellement, l'application est fonctionnelle et repose sur des bases solides :
- **Stack** : Flutter, FFmpeg (`ffmpeg_kit_flutter_new`), GetX.
- **Business Model** : Hybride (AdMob + RevenueCat).
- **Core Feature** : Découpage vidéo (synchrone/asynchrone), compression, partage direct iOS/Android.

**Points de friction potentiels à anticiper** : 
- Le traitement FFmpeg sur mobile peut être gourmand en ressources et lent sur les vieux appareils, causant des crashs (OOM).
- Rétention : L'utilisateur vient pour un besoin utilitaire et ponctuel, le défi est de le faire revenir régulièrement.

---

## 2. Solution : La Roadmap Stratégique

### Phase 1 : Consolidation & Optimisation (Court Terme)
*Objectif : Zéro crash, performances maximales, et augmentation du taux de conversion.*

- **Optimisation FFmpeg (Performance)** :
  - **Fast Split** : S'assurer que le découpage utilise `-c:v copy` sans réencodage chaque fois que c'est possible (traitement quasi instantané).
  - **Hardware Acceleration** : Activer `VideoToolbox` pour iOS et `MediaCodec` pour Android si un réencodage est inévitable.
- **Leviers de Monétisation (Business)** :
  - **Watermark** : Ajouter un filigrane très subtil sur la version gratuite. Le retrait de ce watermark devient un argument fort pour la conversion Pro.
  - **Contextualisation du Paywall** : Mettre en avant le gain de temps (traitement ultra-rapide) et l'export sans perte (Lossless HD) au moment précis où l'utilisateur gratuit atteint une limite.
- **UX & Feedback (Produit)** :
  - Implémenter une vraie barre de progression avec un "Temps restant estimé" (ETA) pour rassurer l'utilisateur lors du traitement des vidéos lourdes.

### Phase 2 : Croissance & Fonctionnalités "Smart" (Moyen Terme)
*Objectif : Se démarquer de la concurrence avec des features intelligentes et virales.*

- **Smart Split (Produit)** :
  - Détection des silences : Analyser la piste audio pour couper les segments lors des pauses, évitant de couper l'utilisateur en plein milieu d'un mot. Un "game changer" pour les créateurs.
- **Auto-Formatting (Produit)** :
  - "Fit to Story" : Convertir automatiquement une vidéo paysage (16:9) en format vertical (9:16) en ajoutant un fond flouté animé ou coloré (très demandé).
- **Intégration Sociale Native (Viralité)** :
  - Mode "Rafale" : Export direct et séquentiel vers Instagram Stories, WhatsApp Status ou TikTok, limitant les clics pour l'utilisateur.

### Phase 3 : Rétention & Écosystème (Long Terme)
*Objectif : Devenir un outil "All-in-One" ultra-spécialisé.*

- **Édition Rapide (Produit)** :
  - Outils légers : ajout de texte global, stickers, ou d'une musique de fond avant de découper la vidéo.
- **Cloud Processing (Technique & Business)** :
  - Pour les vidéos > 1Go ou 4K, proposer un traitement Cloud (via Firebase Cloud Run / AWS) exclusif aux utilisateurs Pro. Cela épargne la batterie, supprime les lenteurs locales et justifie l'abonnement.
- **Analytics Predictifs (Data)** :
  - Analyser les comportements de "Drop-off" (abandon pendant le chargement) pour ajuster dynamiquement les seuils de vidéo gratuit/payant.

---

## 3. Implémentation : Prochaines Étapes Actionnables

Pour amorcer cette transition en tant que Lead Dev, voici ce qu'on peut attaquer immédiatement :

1. **Audit FFmpeg & Clean Architecture** : 
   - Revoir la classe `VideoLogic` et le module `VideoService` pour vérifier les arguments de commande.
   - Standardiser la gestion des erreurs et des annulations de tâches (Cancel token) si l'utilisateur met l'app en arrière-plan prolongé.
2. **A/B Testing du Freemium** : 
   - Intégrer un flag via Firebase Remote Config pour tester la feature "Watermark" sur 50% des utilisateurs gratuits et mesurer l'impact sur l'ARPU.
3. **Optimisation Mémoire** : 
   - Gérer finement la libération (dispose) des `VideoPlayerController` dans `HomeController` pour éviter les fuites de mémoire (memory leaks) si l'utilisateur traite plusieurs vidéos d'affilée.

> [!IMPORTANT]
> **Recommandation immédiate** : Concentrons-nous d'abord sur la **Phase 1 (Optimisation FFmpeg & Mémoire)**. Un traitement ultra-rapide réduit la frustration et augmente les notes 5 étoiles sur les stores, ce qui booste l'acquisition organique (ASO) avant d'ajouter de nouvelles fonctionnalités.
