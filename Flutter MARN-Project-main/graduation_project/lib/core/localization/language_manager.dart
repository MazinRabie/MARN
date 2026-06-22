import 'dart:ui';
import 'package:MARN/core/enums/cubit/enum_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MARN/core/services/shared_preferences_helper.dart';
import 'package:easy_localization/easy_localization.dart';

/// Manager for language switching and persistence
/// Handles language change, persistence, and enum synchronization
class LanguageManager {
  static const String _defaultLanguage = 'en';

  /// Get current saved language
  static String getSavedLanguage() {
    final saved = SharedPreferencesHelper.getString(LocalStorageVariables.language);
    if (saved != null) return saved;

    // Fallback to device locale if it is supported (en or ar)
    final deviceLocale = PlatformDispatcher.instance.locale.languageCode;
    if (deviceLocale == 'ar' || deviceLocale == 'en') {
      return deviceLocale;
    }
    return _defaultLanguage;
  }

  /// Save language preference
  static Future<void> saveLanguage(String languageCode) async {
    await SharedPreferencesHelper.setString(
      LocalStorageVariables.language,
      languageCode,
    );
  }

  /// Change app language — updates locale, persists, and re-fetches enums
  static Future<void> changeLanguage(
    BuildContext context,
    String languageCode,
  ) async {
    await saveLanguage(languageCode);

    if (context.mounted) {
      try {
        await context.read<EnumCubit>().switchLanguage(languageCode);
      } catch (_) {}
    }

    if (context.mounted) {
      await context.setLocale(Locale(languageCode));
    }
  }

  /// Initialize language from saved preference
  static Future<Locale> getInitialLocale() async {
    final savedLanguage = getSavedLanguage();
    return Locale(savedLanguage);
  }

  /// Check if current language is RTL
  static bool isRTL(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }

  /// Get current language code
  static String getCurrentLanguage(BuildContext context) {
    return context.locale.languageCode;
  }

  /// Get supported locales
  static List<Locale> getSupportedLocales() {
    return [Locale('en'), Locale('ar')];
  }
}
