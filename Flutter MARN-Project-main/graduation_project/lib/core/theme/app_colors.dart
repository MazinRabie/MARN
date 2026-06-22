import 'package:flutter/material.dart';

abstract class AppColors {
  // ==================== Primary Brand Colors ====================
  static const Color primary = Color(0xFF3A6EA5);
  static const Color primarySecond = Color(0xFF4073A8);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFF5F7FA);
  static const Color secondaryContainer = Color(0xFFF5F7FA);
  static const Color primaryLight = Color(0xFF9CBBDC); // secondary brand
  static const Color primaryDark = Color(0xFF2E5A8A);
  static const Color primarySoft = Color(0xFFC9DAEB); // legacy

  // ==================== Secondary Colors ====================
  static const Color secondary = Color(0xFF9CBBDC);
  static const Color onSecondary = Color(0xFF1A1A1A);

  // ==================== Background & Surface ====================
  static const Color background = Color(0xFFF2F4F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F7FA);
  static const Color surfaceDark = Color(0xFF2A2A2A); // footer, icon background
  static const Color softBackground = Color(0xFFFFFBE9); // legacy

  // ==================== Text Colors ====================
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF4A5565);
  static const Color textTertiary = Color(0xFF6A7282);
  static const Color textHint = Color(0xFF99A1AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ==================== Status Colors ====================
  static const Color success = Color(0xFF00A63E);
  static const Color successSoft = Color.fromARGB(137, 0, 166, 50);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = Color(0xFFDCFCE7);

  static const Color error = Color(0xFFFB2C36);
  static const Color errorSoft = Color.fromARGB(137, 251, 44, 54);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFE2E2);

  static const Color warning = Color(0xFFCA3500);
  static const Color warningContainer = Color(0xFFFFEDD4);

  static const Color pending = Color.fromARGB(255, 76, 142, 255);
  static const Color pendingContainer = Color(0xFFFEF9C2);

  static const Color unverified = Color.fromARGB(255, 147, 170, 177);
  static const Color unverifiedContainer = Color(0xFFFFEDD4);

  static const Color available = Color(0xFFff9800);
  static const Color availableContainer = Color.fromARGB(114, 255, 153, 0);

  static const Color love = Color.fromARGB(180, 255, 38, 81);

  // ==================== Neutral & Borders ====================
  static const Color divider = Color(0xFFE2E8F0);
  static const Color border = Color(0x333A6EA5); // 20% opacity
  static const Color shadow = Color(0x1A000000); // 10% opacity
  static const Color shadowDark = Color(0x7F3A6EA5); // 50% opacity
  static const Color grey = Color(0xFF99A1AF);
  static const Color grayLight = Color(0xFFE8E8E8);
  static const Color darkGray = Color(0xFF364153);

  // ==================== Logo Colors ====================
  static const Color logoDarker = Color(0xFF2E5A8A);
  static const Color logoLighter = Color(0xFF3A6EA5);
  static const Color logoText = Color(0xFF9CBBDC);

  // ==================== Basic Colors ====================
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color white90 = Color(0xE6FFFFFF);
  static const Color transparent = Colors.transparent;
}
