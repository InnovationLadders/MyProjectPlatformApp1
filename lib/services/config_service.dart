import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/app_config.dart';

class ConfigService {
  static AppConfig? _config;

  static Future<AppConfig> loadConfig() async {
    if (_config != null) {
      return _config!;
    }

    try {
      final String configString = await rootBundle.loadString('assets/config.json');
      final Map<String, dynamic> configJson = json.decode(configString);
      _config = AppConfig.fromJson(configJson);
      return _config!;
    } catch (e) {
      _config = AppConfig(
        appName: 'sky property',
        url: 'https://skypropertyksa.com',
      );
      return _config!;
    }
  }

  static AppConfig? get config => _config;
}
