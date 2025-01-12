import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../providers/language_provider.dart';

class LangManager {
  static final Map<String, Map<String, dynamic>> _translations = {};

  static Future<void> init() async {
    // Core modül dil dosyaları
    await _loadTranslations('lib/core/lang/tr.json', 'tr');
    await _loadTranslations('lib/core/lang/en.json', 'en');
  }

  static Future<void> _loadTranslations(String path, String langCode) async {
    try {
      final jsonString = await rootBundle.loadString(path);
      _translations[langCode] = json.decode(jsonString);
    } catch (e) {
      debugPrint('Dil dosyası yüklenemedi: $path');
    }
  }

  static String getText(String key, AppLanguage language) {
    final langCode = language.code;
    final parts = key.split('.');

    dynamic value = _translations[langCode];
    for (final part in parts) {
      value = value?[part];
    }

    return value?.toString() ?? key;
  }

  static Future<void> loadModuleTranslations(String moduleName) async {
    await _loadTranslations('lib/$moduleName/lang/tr.json', 'tr');
    await _loadTranslations('lib/$moduleName/lang/en.json', 'en');
  }
}
