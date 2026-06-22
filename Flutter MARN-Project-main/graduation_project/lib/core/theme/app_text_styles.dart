import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  // ==================== Base Helper ====================
  static TextStyle _style({
    required double fontSize,
    required FontWeight fontWeight,
    required double height,
    Color? color,
    String? fontFamily,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? "Alexandria",
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  // ==================== Display ====================
  static TextStyle get display => _style(
    fontSize: 60,
    fontWeight: FontWeight.w700,
    height: 1.0,
    color: AppColors.textPrimary,
  );

  // ==================== Headline ====================
  static TextStyle get headlineLarge => _style(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.11,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineMedium => _style(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.33,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineSmall => _style(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.40,
    color: AppColors.textPrimary,
  );

  // ==================== Title ====================
  static TextStyle get titleLarge => _style(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.56,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleMedium => _style(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.50,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleSmall => _style(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.50,
    color: AppColors.textPrimary,
  );

  // ==================== Body ====================
  static TextStyle get bodyLarge => _style(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    color: AppColors.textSecondary,
  );

  static TextStyle get bodyMedium => _style(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    color: AppColors.textSecondary,
  );

  static TextStyle get bodySmall => _style(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    color: AppColors.textSecondary,
  );

  // Semantic Aliases
  static TextStyle get body => bodyMedium;
  static TextStyle get bodyBold => _style(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.50,
    color: AppColors.textPrimary,
  );
  static TextStyle get bodyDark => bodyBold;
  static TextStyle get bodyHint => _style(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    color: AppColors.textHint,
  );

  // ==================== Label ====================
  static TextStyle get labelLarge => _style(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  static TextStyle get labelMedium => _style(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  static TextStyle get labelSmall => _style(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    color: AppColors.textPrimary,
  );

  // ==================== Numbers ====================
  static TextStyle get numberLarge => _style(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.50,
    color: AppColors.primary,
  );

  static TextStyle get numberMedium => _style(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.primary,
  );

  static TextStyle get numberSmall => _style(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.primary,
  );

  // ==================== Specialized ====================
  static TextStyle get button => _style(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    color: AppColors.white,
  );

  static TextStyle get buttonLarge => _style(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.43,
    color: AppColors.white,
  );

  // ==================== Price ====================
  static TextStyle get price => numberSmall;
  static TextStyle get priceUnit => _style(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    color: AppColors.textTertiary,
  );

  // ==================== Testimonial ====================
  static TextStyle get testimonial => _style(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.63,
    color: AppColors.darkGray,
  );

  static TextStyle get metadata => bodySmall;
  static TextStyle get rating => _style(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  // ==================== Logo (special font) ====================
  static TextStyle get logoMark => _style(
    fontSize: 64,
    fontWeight: FontWeight.w700,
    height: 1.0,
    color: AppColors.white,
    fontFamily: 'Segoe UI Emoji',
  );

  static TextStyle get logoText => _style(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.0,
    color: AppColors.logoText,
    fontFamily: 'Segoe UI Emoji',
    letterSpacing: 1.2,
  );

  static TextStyle get logoSubtitle => _style(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.0,
    color: AppColors.textPrimary,
    fontFamily: 'Segoe UI Emoji',
  );

  static TextStyle get logoMarkSmall => _style(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.50,
    color: AppColors.white,
    fontFamily: 'Segoe UI Emoji',
  );

  static TextStyle get logoTextSmall => _style(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.50,
    color: AppColors.logoText,
    fontFamily: 'Segoe UI Emoji',
  );

  // Legacy Section / Card (kept for consistency during migration)
  static TextStyle get sectionTitle => headlineLarge;
  static TextStyle get sectionSubtitle => bodyMedium;
  static TextStyle get cardTitle => titleLarge;

  // Chat
  static TextStyle get chatName => titleLarge;
  static TextStyle get chatUserName => titleMedium;
  static TextStyle get chatUserSubtitle => bodySmall;
  static TextStyle get chatMessageTime => bodySmall;

  static TextStyle get chatMessageMe => _style(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    color: AppColors.onPrimary,
  );

  static TextStyle get chatMessageOther => _style(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    color: AppColors.textPrimary,
  );

  static TextStyle get chatTimeMe => _style(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    color: AppColors.white90,
  );

  static TextStyle get chatTimeOther => _style(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    color: AppColors.textTertiary,
  );
}
