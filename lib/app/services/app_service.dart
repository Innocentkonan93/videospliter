import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_spliter/app/modules/settings/views/feedbacks_view.dart';
import 'package:video_spliter/app/widgets/pre_rating_dialog.dart';

class AppService {
  AppService();

  static const _launchCountKey = 'app_rating_launch_count';
  static const _firstLaunchDateKey = 'app_rating_first_launch';
  static const _lastPromptDateKey = 'app_rating_last_prompt';
  static const _promptDisabledKey = 'app_rating_disabled';

  static const int launchThreshold = 5;
  static const int cutThreshold = 3; // Demander à la 3ème vidéo coupée
  static const Duration minInstallDuration = Duration(days: 7);
  static const Duration promptCooldown = Duration(days: 30);
  static const Duration shortCooldown = Duration(
    days: 3,
  ); // Cooldown si "pas vraiment"

  final InAppReview _inAppReview = InAppReview.instance;

  static Future<void> shareApp() async {
    final appStoreLink =
        'https://apps.apple.com/us/app/cutit-découpage-de-vidéos/id6747193487';
    final playStoreLink =
        'https://play.google.com/store/apps/details?id=com.meetsum.cutIt';

    final url = Platform.isAndroid ? playStoreLink : appStoreLink;

    final context = Get.context;
    final box = context?.findRenderObject() as RenderBox?;

    await SharePlus.instance.share(
      ShareParams(
        title: 'share_app_title'.tr,
        text: 'share_app_text'.tr + url,
        sharePositionOrigin:
            box != null ? box.localToGlobal(Offset.zero) & box.size : null,
      ),
    );
  }

  static Future<void> askForRating() async {
    try {
      final inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      } else {
        // Fallback vers le store
        inAppReview.openStoreListing();
      }
    } catch (e) {
      print(e);
    }
  }

  /// Vérifie si les conditions sont réunies pour afficher le prompt natif
  /// lors d’un lancement classique de l’application (ex. découpage vidéo terminée).
  Future<void> handleRatingRequestOnLaunch() async {
    await _handleRatingRequest(
      incrementLaunchCount: true,
      requireLaunchThreshold: true,
      usePreDialog: false,
    );
  }

  /// Tente d’afficher le prompt directement après une action positive
  /// (ex. découpage vidéo terminée) en ignorant le seuil de lancements.
  Future<void> handleRatingRequestAfterClaim() async {
    await _handleRatingRequest(
      incrementLaunchCount: false,
      requireLaunchThreshold: false,
      usePreDialog: true,
    );
  }

  Future<void> handleRatingRequestAfterFeedback() async {
    await _handleRatingRequest(
      incrementLaunchCount: true,
      requireLaunchThreshold: false,
      usePreDialog:
          false, // Déjà engagé, on peut demander direct ou pas du tout
    );
  }

  /// Tente d'afficher le prompt après un découpage réussi
  /// Demande uniquement après [cutThreshold] découpages
  Future<void> handleRatingRequestAfterCutting() async {
    final prefs = await SharedPreferences.getInstance();
    int cutCount = prefs.getInt('app_rating_cut_count') ?? 0;
    cutCount++;
    await prefs.setInt('app_rating_cut_count', cutCount);

    if (cutCount >= cutThreshold) {
      await _handleRatingRequest(
        incrementLaunchCount: true,
        requireLaunchThreshold: false,
        requireMinInstallDuration: false,
        usePreDialog: true,
      );
    }
  }

  /// Tente d'afficher le prompt après un partage réussi
  /// Ignore le seuil de lancements et la durée minimale d'installation
  /// pour permettre un prompt plus rapide après des actions positives
  Future<void> handleRatingRequestAfterShare() async {
    await _handleRatingRequest(
      incrementLaunchCount: true,
      requireLaunchThreshold: false,
      requireMinInstallDuration: false,
      usePreDialog: true,
    );
  }

  /// Gère la logique d'affichage du prompt de notation en fonction des paramètres donnés.
  /// - [incrementLaunchCount] : incrémente le compteur de lancements si true.
  /// - [requireLaunchThreshold] : exige que le seuil de lancements soit atteint si true.
  /// - [requireMinInstallDuration] : exige que la durée minimale d'installation soit atteinte si true.
  /// - [usePreDialog] : Affiche d'abord le dialogue "Êtes-vous satisfait ?".
  Future<void> _handleRatingRequest({
    required bool incrementLaunchCount,
    required bool requireLaunchThreshold,
    bool requireMinInstallDuration = true,
    bool usePreDialog = false,
  }) async {
    try {
      // Récupère les préférences partagées.
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();

      // Récupère ou initialise la date du premier lancement.
      final firstLaunchIso = prefs.getString(_firstLaunchDateKey);
      DateTime firstLaunch;
      if (firstLaunchIso == null) {
        // Premier lancement : enregistre la date actuelle.
        firstLaunch = now;
        await prefs.setString(_firstLaunchDateKey, now.toIso8601String());
      } else {
        // Parse la date de premier lancement enregistrée.
        firstLaunch = DateTime.tryParse(firstLaunchIso) ?? now;
      }

      // Récupère et met à jour le nombre de lancements de l'application.
      var launchCount = prefs.getInt(_launchCountKey) ?? 0;
      if (incrementLaunchCount) {
        launchCount += 1;
        await prefs.setInt(_launchCountKey, launchCount);
      }

      // Vérifie si le prompt est désactivé (optionnel, si on veut ajouter un bouton "Ne plus jamais demander")
      final promptDisabled = prefs.getBool(_promptDisabledKey) ?? false;
      if (promptDisabled) {
        return;
      }

      // Conditions à respecter pour afficher le prompt :
      // 1. Seuil de lancement atteint ? (si requis)
      final meetsLaunchThreshold =
          requireLaunchThreshold ? launchCount >= launchThreshold : true;
      // 2. Durée d'installation minimale atteinte ? (si requise)
      final meetsInstallDuration =
          requireMinInstallDuration
              ? now.difference(firstLaunch) >= minInstallDuration
              : true;

      // 3. Cooldown expiré depuis la dernière demande de notation ?
      final lastPromptIso = prefs.getString(_lastPromptDateKey);
      final lastPrompt =
          lastPromptIso == null ? null : DateTime.tryParse(lastPromptIso);

      // On utilise 'promptCooldownDate' qui sera soit générée lors du prompt, soit lue
      final promptCooldownIso = prefs.getString(
        '${_lastPromptDateKey}_cooldown',
      );
      final applicableCooldown =
          promptCooldownIso != null
              ? Duration(
                milliseconds:
                    int.tryParse(promptCooldownIso) ??
                    promptCooldown.inMilliseconds,
              )
              : promptCooldown;

      final cooldownExpired =
          lastPrompt == null
              ? true
              : now.difference(lastPrompt) >= applicableCooldown;

      // Si toutes les conditions sont réunies, alors on tente d'afficher le prompt.
      if (meetsLaunchThreshold && meetsInstallDuration && cooldownExpired) {
        if (usePreDialog) {
          Get.dialog(
            PreRatingDialog(
              onRate: () async {
                final prompted = await _askForRating();
                if (prompted) {
                  // Mettre à jour la date du dernier prompt (cooldown long car on a demandé sur le store)
                  await prefs.setString(
                    _lastPromptDateKey,
                    now.toIso8601String(),
                  );
                  await prefs.setString(
                    '${_lastPromptDateKey}_cooldown',
                    promptCooldown.inMilliseconds.toString(),
                  );
                }
              },
              onFeedback: () async {
                // Rediriger vers la page de feedback
                Get.to(() => const FeedbacksView());
                // Cooldown plus court car on a eu un retour interne, on pourra retenter plus tard
                await prefs.setString(
                  _lastPromptDateKey,
                  now.toIso8601String(),
                );
                await prefs.setString(
                  '${_lastPromptDateKey}_cooldown',
                  shortCooldown.inMilliseconds.toString(),
                );
              },
              onDismiss: () async {
                // Si l'utilisateur ferme simplement (la croix), on met le cooldown standard
                await prefs.setString(
                  _lastPromptDateKey,
                  now.toIso8601String(),
                );
                await prefs.setString(
                  '${_lastPromptDateKey}_cooldown',
                  promptCooldown.inMilliseconds.toString(),
                );
              },
            ),
          );
        } else {
          final prompted = await _askForRating();
          if (prompted) {
            // On enregistre la date à laquelle on a affiché le prompt
            await prefs.setString(_lastPromptDateKey, now.toIso8601String());
            await prefs.setString(
              '${_lastPromptDateKey}_cooldown',
              promptCooldown.inMilliseconds.toString(),
            );
          }
        }
      }
    } catch (e) {
      print('Error handling rating prompt: $e');
    }
  }

  Future<bool> _askForRating() async {
    try {
      if (await _inAppReview.isAvailable()) {
        await _inAppReview.requestReview();
      } else {
        await _inAppReview.openStoreListing();
      }
      return true;
    } catch (e) {
      print('Error requesting in-app review: $e');
      return false;
    }
  }

  Future<void> openStoreListing() async {
    try {
      await _inAppReview.openStoreListing();
    } catch (e) {
      print('Error opening store listing: $e');
    }
  }
}
