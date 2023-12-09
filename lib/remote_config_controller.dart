import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class FirebaseRemoteConfigService {
  FirebaseRemoteConfigService._()
      : _remoteConfig = FirebaseRemoteConfig.instance;

  static FirebaseRemoteConfigService? _instance;
  factory FirebaseRemoteConfigService() =>
      _instance ??= FirebaseRemoteConfigService._();

  final FirebaseRemoteConfig _remoteConfig;

  String getString(String key) => _remoteConfig.getString(key);

  Future<void> _setConfigSettings() async => _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 0),
          minimumFetchInterval: const Duration(hours: 12),
        ),
      );

  Future<void> _setDefaults() async => _remoteConfig.setDefaults(
        const {
          "example_param_4": 'LOCAL DEFAULT',
        },
      );

  Future<void> fetchAndActivate() async {
    bool updated = await _remoteConfig.fetchAndActivate();

    if (updated) {
      debugPrint('updated');
    } else {
      debugPrint('not updated');
    }
  }

  Future<void> initialize() async {
    await _setConfigSettings();
    await _setDefaults();
    // await fetchAndActivate();

    try {
      await fetchAndActivate();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
