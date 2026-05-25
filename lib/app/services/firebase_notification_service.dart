// ignore_for_file: avoid_print

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:video_spliter/app/configs/caches/cache_helper.dart';
import 'package:video_spliter/app/services/revenuecat_service.dart';

@pragma('vm:entry-point')
Future<void> notificationHandler(RemoteMessage? message) async {
  // FlutterAppBadger.updateBadgeCount(1);
  print("title: ${message?.notification?.title}");
  print("body: ${message?.notification?.body}");
  print("data: ${message?.data}");
}

@pragma('vm:entry-point')
Future<void> backgroundNotificationHandler(RemoteMessage? message) async {
  // FlutterAppBadger.updateBadgeCount(1);
  print("title: ${message!.notification!.title}");
  print("body: ${message.notification!.body}");
  print("data: ${message.data}");
}

class FirebaseNotificationService extends GetxService {
  static FirebaseNotificationService get to => Get.find();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<FirebaseNotificationService> init() async {
    FirebaseMessaging.onBackgroundMessage(backgroundNotificationHandler);
    await initPushNotification();

    // Écouter le renouvellement de token FCM pour invalider le cache et resynchroniser
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      debugPrint(
        "[FCM] Nouveau token détecté via onTokenRefresh. Invalidation du cache.",
      );
      await CacheHelper.removeData(key: 'fcm_last_sync_all');
      await CacheHelper.removeData(key: 'fcm_last_sync_pro');
      await syncTopics();
    });

    // Essayer de synchroniser les topics si l'utilisateur a donné la permission
    final settings = await _firebaseMessaging.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      await syncTopics();
    }

    return this;
  }

  Future<void> initPushNotification() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _firebaseMessaging.getInitialMessage().then(notificationHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(notificationHandler);
  }

  Future<void> initFirebaseNotifications() async {
    await _firebaseMessaging.requestPermission(provisional: true);
    await initPushNotification();
    await syncTopics();
  }

  Future<String?> addDeviceToken() async {
    final String? token = await _firebaseMessaging.getToken();
    return token;
  }

  /// Synchronise les abonnements aux topics FCM en fonction du statut de souscription.
  /// Optimisé avec un cache local SharedPreferences pour éviter de requêter Firebase inutilement.
  Future<void> syncTopics() async {
    try {
      final String? token = await _firebaseMessaging.getToken();
      if (token == null) {
        debugPrint(
          "[FCM] Aucun token FCM disponible. Saut de la synchronisation des topics.",
        );
        return;
      }

      // 0. Vérifier si le token a changé depuis la dernière synchronisation
      final String? lastSyncToken = CacheHelper.sharedPreferences.getString(
        'fcm_last_sync_token',
      );
      if (lastSyncToken != token) {
        debugPrint(
          "[FCM] Changement de token détecté (nouveau: $token, ancien: $lastSyncToken). Invalidation du cache des topics.",
        );
        await CacheHelper.removeData(key: 'fcm_last_sync_all');
        await CacheHelper.removeData(key: 'fcm_last_sync_pro');
        await CacheHelper.removeData(key: 'fcm_last_sync_locale');
        await CacheHelper.removeData(key: 'fcm_last_sync_platform');
      }

      // Récupérer le statut Pro/Free de l'utilisateur
      bool isPro = false;
      if (Get.isRegistered<RevenueCatService>()) {
        isPro = Get.find<RevenueCatService>().isProUser.value;
      }

      // Récupérer la langue actuelle et la plateforme
      final String currentLanguage = Get.locale?.languageCode ?? Get.deviceLocale?.languageCode ?? 'en';
      final String currentPlatform = Platform.isAndroid ? 'android' : 'ios';

      // Vérification des clés de cache
      final bool lastSyncAll =
          CacheHelper.sharedPreferences.getBool('fcm_last_sync_all') ?? false;
      final bool? lastSyncPro = CacheHelper.sharedPreferences.getBool(
        'fcm_last_sync_pro',
      );
      final String? lastSyncLocale = CacheHelper.sharedPreferences.getString(
        'fcm_last_sync_locale',
      );
      final String? lastSyncPlatform = CacheHelper.sharedPreferences.getString(
        'fcm_last_sync_platform',
      );

      // 1. S'assurer de l'abonnement à 'all_users' (fait une seule fois pour économiser du trafic)
      if (!lastSyncAll) {
        await _firebaseMessaging.subscribeToTopic('all_users');
        await CacheHelper.saveData(key: 'fcm_last_sync_all', value: true);
        await CacheHelper.saveData(key: 'fcm_last_sync_token', value: token);
        debugPrint("[FCM] Abonnement au topic 'all_users' réussi.");
      }

      // 2. Synchroniser les topics premium/free uniquement si le statut Pro a changé ou n'a jamais été synchronisé
      if (lastSyncPro == null || lastSyncPro != isPro) {
        if (isPro) {
          await _firebaseMessaging.subscribeToTopic('premium_users');
          await _firebaseMessaging.unsubscribeFromTopic('free_users');
          debugPrint(
            "[FCM] Abonnement au topic 'premium_users' et désabonnement de 'free_users'.",
          );
        } else {
          await _firebaseMessaging.subscribeToTopic('free_users');
          await _firebaseMessaging.unsubscribeFromTopic('premium_users');
          debugPrint(
            "[FCM] Abonnement au topic 'free_users' et désabonnement de 'premium_users'.",
          );
        }
        await CacheHelper.saveData(key: 'fcm_last_sync_pro', value: isPro);
        await CacheHelper.saveData(key: 'fcm_last_sync_token', value: token);
      }

      // 3. Topic de Langue (ex : désabonner de l'ancienne langue et s'abonner à la nouvelle si elle a changé)
      if (lastSyncLocale != currentLanguage) {
        if (lastSyncLocale != null && lastSyncLocale.isNotEmpty) {
          await _firebaseMessaging.unsubscribeFromTopic('lang_$lastSyncLocale');
        }
        await _firebaseMessaging.subscribeToTopic('lang_$currentLanguage');
        await CacheHelper.saveData(key: 'fcm_last_sync_locale', value: currentLanguage);
        await CacheHelper.saveData(key: 'fcm_last_sync_token', value: token);
        debugPrint("[FCM] Abonnement au topic de langue : lang_$currentLanguage");
      }

      // 4. Topic de Plateforme (OS)
      if (lastSyncPlatform != currentPlatform) {
        if (lastSyncPlatform != null && lastSyncPlatform.isNotEmpty) {
          await _firebaseMessaging.unsubscribeFromTopic('platform_$lastSyncPlatform');
        }
        await _firebaseMessaging.subscribeToTopic('platform_$currentPlatform');
        await CacheHelper.saveData(key: 'fcm_last_sync_platform', value: currentPlatform);
        await CacheHelper.saveData(key: 'fcm_last_sync_token', value: token);
        debugPrint("[FCM] Abonnement au topic de plateforme : platform_$currentPlatform");
      }
    } catch (e) {
      debugPrint("[FCM] Erreur lors de la synchronisation des topics : $e");
    }
  }
}
