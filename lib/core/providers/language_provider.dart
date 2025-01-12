import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  tr('Türkçe', 'tr'),
  en('English', 'en');

  final String name;
  final String code;
  const AppLanguage(this.name, this.code);
}

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  AppLanguage _currentLanguage = AppLanguage.tr;
  AppLanguage get currentLanguage => _currentLanguage;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString(_languageKey);
    if (savedLang != null) {
      _currentLanguage = AppLanguage.values.firstWhere(
        (lang) => lang.code == savedLang,
        orElse: () => AppLanguage.tr,
      );
      notifyListeners();
    }
  }

  Future<void> _saveLanguage(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language.code);
  }

  void setLanguage(AppLanguage language) {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      _saveLanguage(language);
      notifyListeners();
    }
  }

  void toggleLanguage() {
    _currentLanguage =
        _currentLanguage == AppLanguage.tr ? AppLanguage.en : AppLanguage.tr;
    _saveLanguage(_currentLanguage);
    notifyListeners();
  }
}
