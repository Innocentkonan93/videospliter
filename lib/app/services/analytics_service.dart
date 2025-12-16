import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsService {
  AnalyticsService._();

  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Clés pour le suivi des sessions et de la rétention
  static const String _firstLaunchKey = 'analytics_first_launch';
  static const String _lastSessionKey = 'analytics_last_session';
  static const String _sessionStartKey = 'analytics_session_start';
  static const String _totalSessionsKey = 'analytics_total_sessions';
  static const String _totalExportsKey = 'analytics_total_exports';
  static const String _totalVideosImportedKey =
      'analytics_total_videos_imported';

  /* =========================
   CORE & INITIALISATION
  ========================= */

  /// Initialise le service analytics et enregistre le premier lancement
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    // Premier lancement
    if (!prefs.containsKey(_firstLaunchKey)) {
      await prefs.setString(_firstLaunchKey, now.toIso8601String());
      await _analytics.logEvent(
        name: 'cutit_first_open',
        parameters: {'timestamp': now.millisecondsSinceEpoch},
      );
      await _analytics.setUserProperty(
        name: 'first_launch_date',
        value: now.toIso8601String().split('T')[0], // Format YYYY-MM-DD
      );
    }

    // Vérifier le retour utilisateur (rétention)
    if (prefs.containsKey(_lastSessionKey)) {
      final lastSession = DateTime.parse(prefs.getString(_lastSessionKey)!);
      final daysSinceLastSession = now.difference(lastSession).inDays;

      if (daysSinceLastSession > 0) {
        await _analytics.logEvent(
          name: 'user_returned',
          parameters: {
            'days_since_last_session': daysSinceLastSession,
            'is_same_day': daysSinceLastSession == 0,
          },
        );
      }
    }

    // Mettre à jour la dernière session
    await prefs.setString(_lastSessionKey, now.toIso8601String());

    // Incrémenter le nombre de sessions
    final totalSessions = (prefs.getInt(_totalSessionsKey) ?? 0) + 1;
    await prefs.setInt(_totalSessionsKey, totalSessions);
    await _analytics.setUserProperty(
      name: 'total_sessions',
      value: totalSessions.toString(),
    );

    // Enregistrer le début de session
    await prefs.setString(_sessionStartKey, now.toIso8601String());

    await appOpen();
  }

  static Future<void> appOpen() async {
    await _analytics.logAppOpen();
  }

  /// Enregistre la fin de session avec la durée
  static Future<void> sessionEnd() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionStart = prefs.getString(_sessionStartKey);

    if (sessionStart != null) {
      final start = DateTime.parse(sessionStart);
      final duration = DateTime.now().difference(start).inSeconds;

      await _analytics.logEvent(
        name: 'session_end',
        parameters: {'duration_sec': duration},
      );
    }
  }

  static Future<void> setUserType({required bool isPremium}) async {
    await _analytics.setUserProperty(
      name: 'user_type',
      value: isPremium ? 'premium' : 'free',
    );
  }

  /// Définit des propriétés utilisateur supplémentaires pour le segmenting
  static Future<void> setUserProperties({
    String? language,
    String? platform,
    int? totalExports,
    int? totalVideosImported,
  }) async {
    if (language != null) {
      await _analytics.setUserProperty(name: 'user_language', value: language);
    }
    if (platform != null) {
      await _analytics.setUserProperty(name: 'platform', value: platform);
    }
    if (totalExports != null) {
      await _analytics.setUserProperty(
        name: 'total_exports',
        value: totalExports.toString(),
      );
    }
    if (totalVideosImported != null) {
      await _analytics.setUserProperty(
        name: 'total_videos_imported',
        value: totalVideosImported.toString(),
      );
    }
  }

  /* =========================
   VIDEO & ONBOARDING
  ========================= */

  /// Enregistre l'import d'une vidéo avec des métriques détaillées
  static Future<void> videoImported({
    required int durationSec,
    required double sizeMb,
    String? source, // 'file_picker', 'share', 'gallery', etc.
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final totalVideos = (prefs.getInt(_totalVideosImportedKey) ?? 0) + 1;
    await prefs.setInt(_totalVideosImportedKey, totalVideos);

    await _analytics.logEvent(
      name: 'video_imported',
      parameters: {
        'duration_sec': durationSec,
        'size_mb': sizeMb,
        'total_videos_imported': totalVideos,
        'source': source ?? 'unknown',
        'duration_category': _getDurationCategory(durationSec),
        'size_category': _getSizeCategory(sizeMb),
      },
    );

    // Mettre à jour la propriété utilisateur
    await setUserProperties(totalVideosImported: totalVideos);
  }

  /// Enregistre la création de segments avec plus de contexte
  static Future<void> segmentCreated({
    required int segmentCount,
    required int videoDurationSec,
    double? sliceDurationSec,
  }) async {
    await _analytics.logEvent(
      name: 'segment_created',
      parameters: {
        'segment_count': segmentCount,
        'video_duration_sec': videoDurationSec,
        'slice_duration_sec': sliceDurationSec?.round() ?? 0,
        'segments_per_minute':
            videoDurationSec > 0
                ? (segmentCount / (videoDurationSec / 60)).toStringAsFixed(2)
                : '0',
      },
    );
  }

  /// Enregistre le début du traitement vidéo
  static Future<void> videoProcessingStarted({
    required int videoDurationSec,
    required int segmentCount,
  }) async {
    await _analytics.logEvent(
      name: 'video_processing_started',
      parameters: {
        'video_duration_sec': videoDurationSec,
        'segment_count': segmentCount,
        'estimated_time_sec': (videoDurationSec / segmentCount).round(),
      },
    );
  }

  /// Enregistre la fin du traitement vidéo avec le temps réel
  static Future<void> videoProcessingCompleted({
    required int processingTimeSec,
    required int segmentCount,
    required int videoDurationSec,
  }) async {
    await _analytics.logEvent(
      name: 'video_processing_completed',
      parameters: {
        'processing_time_sec': processingTimeSec,
        'segment_count': segmentCount,
        'video_duration_sec': videoDurationSec,
        'processing_speed':
            videoDurationSec > 0
                ? (videoDurationSec / processingTimeSec).toStringAsFixed(2)
                : '0',
      },
    );
  }

  /// Enregistre l'échec du traitement vidéo
  static Future<void> videoProcessingFailed({
    required String reason,
    int? videoDurationSec,
  }) async {
    await _analytics.logEvent(
      name: 'video_processing_failed',
      parameters: {
        'reason': reason,
        if (videoDurationSec != null) 'video_duration_sec': videoDurationSec,
      },
    );
    FirebaseCrashlytics.instance.log('Video processing failed: $reason');
  }

  /// Enregistre la complétion de l'onboarding
  static Future<void> onboardingCompleted({
    int? screensViewed,
    int? timeSpentSec,
  }) async {
    await _analytics.logEvent(
      name: 'onboarding_completed',
      parameters: {
        if (screensViewed != null) 'screens_viewed': screensViewed,
        if (timeSpentSec != null) 'time_spent_sec': timeSpentSec,
      },
    );
  }

  /// Enregistre l'abandon de l'onboarding
  static Future<void> onboardingAbandoned({
    required int screenNumber,
    int? timeSpentSec,
  }) async {
    await _analytics.logEvent(
      name: 'onboarding_abandoned',
      parameters: {
        'screen_number': screenNumber,
        if (timeSpentSec != null) 'time_spent_sec': timeSpentSec,
      },
    );
  }

  /* =========================
   EXPORT (ROI)
  ========================= */

  /// Enregistre le début d'un export avec contexte
  static Future<void> exportStarted({
    required int segmentCount,
    required bool isPremium,
    String? exportFormat, // 'mp4', 'mov', etc.
  }) async {
    await _analytics.logEvent(
      name: 'export_started',
      parameters: {
        'segment_count': segmentCount,
        'is_premium': isPremium,
        if (exportFormat != null) 'export_format': exportFormat,
      },
    );
  }

  /// Enregistre un export réussi avec métriques détaillées
  static Future<void> exportSuccess({
    required int exportTimeSec,
    required bool isPremium,
    required int segmentCount,
    double? totalSizeMb,
    String? exportFormat,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final totalExports = (prefs.getInt(_totalExportsKey) ?? 0) + 1;
    await prefs.setInt(_totalExportsKey, totalExports);

    await _analytics.logEvent(
      name: 'export_success',
      parameters: {
        'export_time_sec': exportTimeSec,
        'is_premium': isPremium,
        'segment_count': segmentCount,
        'total_exports': totalExports,
        if (totalSizeMb != null) 'total_size_mb': totalSizeMb,
        if (exportFormat != null) 'export_format': exportFormat,
        'export_speed_mb_per_sec':
            totalSizeMb != null && exportTimeSec > 0
                ? (totalSizeMb / exportTimeSec).toStringAsFixed(2)
                : '0',
      },
    );

    // Mettre à jour la propriété utilisateur
    await setUserProperties(totalExports: totalExports);

    // Enregistrer un événement de conversion (export = valeur pour l'utilisateur)
    await _analytics.logEvent(
      name: 'export_conversion',
      parameters: {'is_premium': isPremium, 'total_exports': totalExports},
    );
  }

  /// Enregistre un échec d'export avec détails
  static Future<void> exportFailed({
    required String reason,
    int? segmentCount,
    bool? isPremium,
  }) async {
    await _analytics.logEvent(
      name: 'export_failed',
      parameters: {
        'reason': reason,
        if (segmentCount != null) 'segment_count': segmentCount,
        if (isPremium != null) 'is_premium': isPremium,
      },
    );

    FirebaseCrashlytics.instance.log('Export failed: $reason');
  }

  /// Enregistre l'annulation d'un export
  static Future<void> exportCanceled({
    int? segmentCount,
    int? timeSpentSec,
  }) async {
    await _analytics.logEvent(
      name: 'export_canceled',
      parameters: {
        if (segmentCount != null) 'segment_count': segmentCount,
        if (timeSpentSec != null) 'time_spent_sec': timeSpentSec,
      },
    );
  }

  /* =========================
   MONETISATION
  ========================= */

  /// Enregistre l'affichage du paywall avec contexte
  static Future<void> paywallViewed({
    String source = 'export',
    int? totalExports,
    int? totalVideosImported,
    int? sessionNumber,
  }) async {
    await _analytics.logEvent(
      name: 'paywall_viewed',
      parameters: {
        'source': source,
        if (totalExports != null) 'total_exports': totalExports,
        if (totalVideosImported != null)
          'total_videos_imported': totalVideosImported,
        if (sessionNumber != null) 'session_number': sessionNumber,
      },
    );
  }

  /// Enregistre le début d'un abonnement premium
  static Future<void> premiumStarted({
    String? productId,
    String? price,
    String? currency,
    String? source, // 'paywall', 'settings', etc.
  }) async {
    await _analytics.logEvent(
      name: 'premium_started',
      parameters: {
        if (productId != null) 'product_id': productId,
        if (price != null) 'price': price,
        if (currency != null) 'currency': currency,
        if (source != null) 'source': source,
      },
    );

    // Mettre à jour le type d'utilisateur
    await setUserType(isPremium: true);
  }

  /// Enregistre l'achat premium complété (avec revenus)
  static Future<void> premiumPurchased({
    required String productId,
    required double value,
    required String currency,
    String? source,
  }) async {
    await _analytics.logEvent(
      name: 'purchase',
      parameters: {
        'item_id': productId,
        'value': value,
        'currency': currency,
        if (source != null) 'source': source,
      },
    );

    await _analytics.logEvent(
      name: 'premium_purchased',
      parameters: {
        'product_id': productId,
        'value': value,
        'currency': currency,
        if (source != null) 'source': source,
      },
    );

    await setUserType(isPremium: true);
  }

  /// Enregistre l'annulation d'un abonnement
  static Future<void> premiumCanceled({
    String? reason,
    int? daysSincePurchase,
  }) async {
    await _analytics.logEvent(
      name: 'premium_canceled',
      parameters: {
        if (reason != null) 'reason': reason,
        if (daysSincePurchase != null) 'days_since_purchase': daysSincePurchase,
      },
    );
  }

  /// Enregistre le renouvellement d'un abonnement
  static Future<void> premiumRenewed({
    required String productId,
    required double value,
    required String currency,
  }) async {
    await _analytics.logEvent(
      name: 'premium_renewed',
      parameters: {
        'product_id': productId,
        'value': value,
        'currency': currency,
      },
    );
  }

  /// Enregistre le refus du paywall
  static Future<void> paywallDismissed({
    required String source,
    int? timeSpentSec,
  }) async {
    await _analytics.logEvent(
      name: 'paywall_dismissed',
      parameters: {
        'source': source,
        if (timeSpentSec != null) 'time_spent_sec': timeSpentSec,
      },
    );
  }

  /* =========================
   ADS
  ========================= */

  /// Enregistre une impression publicitaire
  static Future<void> adImpression({
    required String placement,
    String? adFormat, // 'banner', 'interstitial', 'rewarded'
    bool? isPremium,
  }) async {
    await _analytics.logEvent(
      name: 'ad_impression',
      parameters: {
        'placement': placement,
        if (adFormat != null) 'ad_format': adFormat,
        if (isPremium != null) 'is_premium': isPremium,
      },
    );
  }

  /// Enregistre un clic sur une publicité
  static Future<void> adClicked({
    required String placement,
    String? adFormat,
  }) async {
    await _analytics.logEvent(
      name: 'ad_clicked',
      parameters: {
        'placement': placement,
        if (adFormat != null) 'ad_format': adFormat,
      },
    );
  }

  /// Enregistre le chargement réussi d'une publicité
  static Future<void> adLoaded({
    required String placement,
    String? adFormat,
    int? loadTimeMs,
  }) async {
    await _analytics.logEvent(
      name: 'ad_loaded',
      parameters: {
        'placement': placement,
        if (adFormat != null) 'ad_format': adFormat,
        if (loadTimeMs != null) 'load_time_ms': loadTimeMs,
      },
    );
  }

  /// Enregistre l'échec de chargement d'une publicité
  static Future<void> adFailedToLoad({
    required String placement,
    required String error,
    String? adFormat,
  }) async {
    await _analytics.logEvent(
      name: 'ad_failed_to_load',
      parameters: {
        'placement': placement,
        'error': error,
        if (adFormat != null) 'ad_format': adFormat,
      },
    );
  }

  /// Enregistre la récompense d'une publicité récompensée
  static Future<void> adRewarded({
    required String placement,
    String? rewardType,
  }) async {
    await _analytics.logEvent(
      name: 'ad_rewarded',
      parameters: {
        'placement': placement,
        if (rewardType != null) 'reward_type': rewardType,
      },
    );
  }

  /* =========================
   ENGAGEMENT & PARTAGE
  ========================= */

  /// Enregistre le partage de l'application
  static Future<void> appShared({
    String? source, // 'settings', 'paywall', etc.
    String? method, // 'native_share', 'link', etc.
  }) async {
    await _analytics.logEvent(
      name: 'app_shared',
      parameters: {
        if (source != null) 'source': source,
        if (method != null) 'method': method,
      },
    );
  }

  /// Enregistre une demande de notation
  static Future<void> ratingRequested({
    String? source,
    int? totalExports,
    int? sessionNumber,
  }) async {
    await _analytics.logEvent(
      name: 'rating_requested',
      parameters: {
        if (source != null) 'source': source,
        if (totalExports != null) 'total_exports': totalExports,
        if (sessionNumber != null) 'session_number': sessionNumber,
      },
    );
  }

  /// Enregistre une notation donnée
  static Future<void> ratingGiven({required int rating, String? source}) async {
    await _analytics.logEvent(
      name: 'rating_given',
      parameters: {'rating': rating, if (source != null) 'source': source},
    );
  }

  /// Enregistre le refus de notation
  static Future<void> ratingDeclined({String? source}) async {
    await _analytics.logEvent(
      name: 'rating_declined',
      parameters: {if (source != null) 'source': source},
    );
  }

  /// Enregistre le partage d'une vidéo exportée
  static Future<void> videoShared({
    required int segmentCount,
    String? method, // 'native_share', 'save_to_gallery', etc.
    bool? isPremium,
  }) async {
    await _analytics.logEvent(
      name: 'video_shared',
      parameters: {
        'segment_count': segmentCount,
        if (method != null) 'method': method,
        if (isPremium != null) 'is_premium': isPremium,
      },
    );
  }

  /// Enregistre l'utilisation d'une fonctionnalité spécifique
  static Future<void> featureUsed({
    required String featureName,
    Map<String, dynamic>? additionalParams,
  }) async {
    final params = <String, Object>{
      'feature_name': featureName,
      if (additionalParams != null)
        ...additionalParams.map((k, v) => MapEntry(k, v as Object)),
    };
    await _analytics.logEvent(name: 'feature_used', parameters: params);
  }

  /// Enregistre l'accès aux paramètres
  static Future<void> settingsOpened() async {
    await _analytics.logEvent(name: 'settings_opened');
  }

  /// Enregistre un changement de langue
  static Future<void> languageChanged({
    required String fromLanguage,
    required String toLanguage,
  }) async {
    await _analytics.logEvent(
      name: 'language_changed',
      parameters: {'from_language': fromLanguage, 'to_language': toLanguage},
    );
    await setUserProperties(language: toLanguage);
  }

  /* =========================
   ERRORS & PERFORMANCE
  ========================= */

  /// Enregistre une erreur avec contexte
  static void recordError(
    dynamic exception,
    StackTrace stack, {
    String? reason,
    String? feature,
    Map<String, dynamic>? context,
  }) {
    FirebaseCrashlytics.instance.recordError(exception, stack, reason: reason);

    // Enregistrer aussi dans Analytics pour le suivi
    final params = <String, Object>{
      if (reason != null) 'reason': reason,
      if (feature != null) 'feature': feature,
      'error_type': exception.runtimeType.toString(),
      if (context != null) ...context.map((k, v) => MapEntry(k, v as Object)),
    };
    _analytics.logEvent(name: 'error_occurred', parameters: params);
  }

  /// Enregistre un problème de performance
  static Future<void> performanceIssue({
    required String operation,
    required int durationMs,
    String? threshold,
  }) async {
    await _analytics.logEvent(
      name: 'performance_issue',
      parameters: {
        'operation': operation,
        'duration_ms': durationMs,
        if (threshold != null) 'threshold': threshold,
      },
    );
  }

  /// Enregistre un événement personnalisé
  static Future<void> logCustomEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: parameters?.map((k, v) => MapEntry(k, v as Object)),
    );
  }

  /* =========================
   HELPERS PRIVÉS
  ========================= */

  /// Catégorise la durée d'une vidéo
  static String _getDurationCategory(int durationSec) {
    if (durationSec < 60) return 'very_short'; // < 1 min
    if (durationSec < 300) return 'short'; // < 5 min
    if (durationSec < 1800) return 'medium'; // < 30 min
    if (durationSec < 3600) return 'long'; // < 1h
    return 'very_long'; // >= 1h
  }

  /// Catégorise la taille d'une vidéo
  static String _getSizeCategory(double sizeMb) {
    if (sizeMb < 10) return 'very_small'; // < 10 MB
    if (sizeMb < 50) return 'small'; // < 50 MB
    if (sizeMb < 200) return 'medium'; // < 200 MB
    if (sizeMb < 500) return 'large'; // < 500 MB
    return 'very_large'; // >= 500 MB
  }
}
