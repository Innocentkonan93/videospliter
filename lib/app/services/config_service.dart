import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ConfigService extends GetxService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  // Remote Config Keys
  static const String _isProVersionEnabledKey = "is_pro_version_enabled";

  // Reactive variables
  final isProVersionEnabled = true.obs;

  Future<ConfigService> init() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: kDebugMode ? Duration.zero : const Duration(hours: 1),
      ));

      // Définir les valeurs par défaut
      await _remoteConfig.setDefaults({
        _isProVersionEnabledKey: true,
      });

      // Fetch and activate
      bool updated = await _remoteConfig.fetchAndActivate();
      debugPrint("Remote Config updated: $updated");

      // Mettre à jour la variable reactive
      _updateValues();
      
      // Écouter les mises à jour en temps réel (optionnel)
      _remoteConfig.onConfigUpdated.listen((event) async {
        await _remoteConfig.activate();
        _updateValues();
      });

    } catch (e) {
      debugPrint("Error initializing Remote Config: $e");
    }
    return this;
  }

  void _updateValues() {
    isProVersionEnabled.value = _remoteConfig.getBool(_isProVersionEnabledKey);
    debugPrint("Is Pro Version Enabled: ${isProVersionEnabled.value}");
  }

  // Helper static method for easy access
  static bool get isProEnabled => Get.find<ConfigService>().isProVersionEnabled.value;
}
