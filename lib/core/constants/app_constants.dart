import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../lang/lang_manager.dart';

class AppConstants {
  static String getText(BuildContext context, String key) {
    final languageProvider = context.read<LanguageProvider>();
    return LangManager.getText(key, languageProvider.currentLanguage);
  }

  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const Duration defaultDuration = Duration(milliseconds: 300);
}
