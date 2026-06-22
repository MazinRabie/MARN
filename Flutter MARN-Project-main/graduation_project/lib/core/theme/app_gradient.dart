import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppGradient {
  // /// Primary gradient (full spectrum)
  // static const LinearGradient primaryGradient = LinearGradient(
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  //   colors: [
  //     Color(0xFF3A6EA5),
  //     Color(0xFF4173A9),
  //     Color(0xFF4879AD),
  //     Color(0xFF4F7EB1),
  //     Color(0xFF5684B5),
  //     Color(0xFF5D89B9),
  //     Color(0xFF648FBD),
  //     Color(0xFF6B94C1),
  //     Color(0xFF729AC5),
  //     Color(0xFF799FC8),
  //     Color(0xFF80A5CC),
  //     Color(0xFF87AAD0),
  //     Color(0xFF8EB0D4),
  //     Color(0xFF95B5D8),
  //     Color(0xFF9CBBDC),
  //   ],
  // );

  /// Light primary gradient (simpler)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primary, AppColors.primaryLight],
  );


  /// Background gradient (legacy)
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.background, AppColors.surface, AppColors.background],
    stops: [0.0, 0.5, 1.0],
  );

  /// Soft primary gradient (legacy)
  static const LinearGradient primarySoftGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primary, AppColors.primarySoft],
  );
  /// Logo gradient (legacy)
  static const LinearGradient logoGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.logoDarker, AppColors.logoLighter],
  );
}
