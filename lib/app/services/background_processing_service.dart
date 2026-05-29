// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class BackgroundProcessingService {
  static Future<dynamic> start(String title) async {
    if (Platform.isAndroid) {
      try {
        // Request post notification permission for Android 13+
        if (await FlutterForegroundTask.checkNotificationPermission() !=
            NotificationPermission.granted) {
          await FlutterForegroundTask.requestNotificationPermission();
        }

        // Initialize foreground task configurations
        FlutterForegroundTask.init(
          androidNotificationOptions: AndroidNotificationOptions(
            channelId: 'video_processing_channel',
            channelName: 'Cutit Video Processing',
            channelDescription: 'Affichage du statut du traitement vidéo',
            channelImportance: NotificationChannelImportance.LOW,
            priority: NotificationPriority.LOW,
          ),
          iosNotificationOptions: const IOSNotificationOptions(
            showNotification: false,
            playSound: false,
          ),
          foregroundTaskOptions: ForegroundTaskOptions(
            eventAction: ForegroundTaskEventAction.nothing(),
            autoRunOnBoot: false,
            allowWakeLock: true,
            allowWifiLock: false,
          ),
        );

        // Start Foreground Service
        if (!await FlutterForegroundTask.isRunningService) {
          final ServiceRequestResult result =
              await FlutterForegroundTask.startService(
            notificationTitle: title,
            notificationText: 'Veuillez patienter...',
            notificationIcon: const NotificationIcon(
              metaDataName: 'com.pravera.flutter_foreground_task.notification_icon',
            ),
          );
          return result is ServiceRequestSuccess;
        }
        return true;
      } catch (e) {
        print('❌ Error starting Android foreground service: $e');
        return false;
      }
    } else if (Platform.isIOS) {
      try {
        const MethodChannel channel =
            MethodChannel('com.meetsum.cutit/background_task');
        final dynamic result =
            await channel.invokeMethod('beginBackgroundTask');
        return result;
      } catch (e) {
        print('❌ Error starting iOS background task: $e');
        return null;
      }
    }
    return null;
  }

  static Future<void> update(String message) async {
    if (Platform.isAndroid) {
      try {
        if (await FlutterForegroundTask.isRunningService) {
          await FlutterForegroundTask.updateService(
            notificationText: message,
          );
        }
      } catch (e) {
        print('❌ Error updating foreground service: $e');
      }
    }
  }

  static Future<void> stop(dynamic taskId) async {
    if (Platform.isAndroid) {
      try {
        if (await FlutterForegroundTask.isRunningService) {
          await FlutterForegroundTask.stopService();
        }
      } catch (e) {
        print('❌ Error stopping Android foreground service: $e');
      }
    } else if (Platform.isIOS) {
      if (taskId != null) {
        try {
          const MethodChannel channel =
              MethodChannel('com.meetsum.cutit/background_task');
          await channel.invokeMethod('endBackgroundTask', {'id': taskId});
        } catch (e) {
          print('❌ Error stopping iOS background task: $e');
        }
      }
    }
  }
}
