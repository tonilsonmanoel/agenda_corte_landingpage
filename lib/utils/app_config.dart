import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AppConfig {
  static late final Map<String, dynamic> _config;

  static Future<void> load() async {
    final String configString = await rootBundle.loadString('config.json');
    _config = json.decode(configString);
  }

  static String get apiBaseUrlSupabase => _config['apiBaseUrlSupabase'];
  static String get apiKeySupabase => _config['apiKeySupabase'];
  static String get apiKeyService => _config['apiKeyService'];
  static String get apiKeyBrevoEmail => _config['apiKeyBrevoEmail'];
  static String get emailBrevo => _config['emailBrevo'];
  static String get nomeExibicaoBrevo => _config['nomeExibicaoBrevo'];
}
