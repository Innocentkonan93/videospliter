// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum FeedbackType { automatic, manual }

class FeedbackService {
  final _db = FirebaseFirestore.instance;

  /// Sends feedback to Firestore.
  ///
  /// [message] is the main message/summary.
  /// [type] distinguishes between automatic system reports and user manual reports.
  /// [step] indicates where the error occurred (e.g., 'cutting', 'export').
  /// [error] contains detailed error info (code, trace).
  /// [videoContext] contains video metadata (duration, format, source, local path, size).
  /// [attachments] list of URLs for screenshots or files (mainly for manual feedback).
  /// [userId] optional user identifier.
  Future<void> send({
    required String message,
    FeedbackType type = FeedbackType.automatic,
    String? step,
    Map<String, dynamic>? error,
    Map<String, dynamic>? videoContext,
    List<String>? attachments,
    String? userId,
  }) async {
    try {
      final device = await _getDeviceInfo();
      final app = await _getAppInfo();

      final data = {
        'type': type.name,
        'message': message,
        'step': step,
        'created_at': FieldValue.serverTimestamp(),
        'device': device,
        'app': app,
        if (error != null) 'error': error,
        if (videoContext != null) 'video_context': videoContext,
        if (attachments != null) 'attachments': attachments,
        if (userId != null) 'user_id': userId,
      };

      await _db.collection('feedbacks').add(data);
    } catch (e, s) {
      print("[FeedbackService] Error sending feedback: $e\n$s");
    }
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        return {
          'os': 'Android',
          'os_version': info.version.release,
          'sdk': info.version.sdkInt,
          'model': info.model,
          'brand': info.brand,
          'device': info.device,
          'manufacturer': info.manufacturer,
        };
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        return {
          'os': 'iOS',
          'os_version': info.systemVersion,
          'model': info.utsname.machine, // e.g., iPhone12,1
          'name': info.name,
          'model_name': info.model,
        };
      }
    } catch (e) {
      return {'error': 'Failed to get device info: $e'};
    }
    return {'os': 'Unknown'};
  }

  Future<Map<String, dynamic>> _getAppInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return {
        'version': info.version,
        'build_number': info.buildNumber,
        'package_name': info.packageName,
        'app_name': info.appName,
      };
    } catch (e) {
      return {'error': 'Failed to get app info: $e'};
    }
  }
}
