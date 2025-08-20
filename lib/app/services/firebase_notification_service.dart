import 'package:firebase_messaging/firebase_messaging.dart';

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

class FirebaseNotificationService {
  FirebaseNotificationService();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // final LocalNotificationService _localNotificationService =
  //     LocalNotificationService();

  Future<void> initPushNotification() async {
    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _firebaseMessaging.getInitialMessage().then(notificationHandler);

    FirebaseMessaging.onMessageOpenedApp.listen(notificationHandler);

    FirebaseMessaging.onBackgroundMessage(backgroundNotificationHandler);
  }

  Future<void> initFirebaseNotifications() async {
    // final String? token = await _firebaseMessaging.getToken();
    // log(token!);
    FirebaseMessaging.onBackgroundMessage(notificationHandler);
    await _firebaseMessaging.requestPermission(provisional: true);
    initPushNotification();
  }

  Future<String?> addDeviceToken() async {
    final String? token = await _firebaseMessaging.getToken();
    return token;
  }
}
