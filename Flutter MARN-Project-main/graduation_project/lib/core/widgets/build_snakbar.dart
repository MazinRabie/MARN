import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart' show AppTextStyles;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

void buildSnackBar(
  BuildContext context, {
  required String message,
  bool isError = false,
  IconData? icon,
  VoidCallback? actionOnPressed,
  String? actionText,
  Duration duration = const Duration(seconds: 4),
  Color? bgColor,
}) {
  actionText ??= LocaleKeys.commonRetry.tr();
  bgColor = bgColor ?? (isError ? AppColors.error : AppColors.success);
  final IconData snackIcon =
      icon ?? (isError ? Icons.error_outline : Icons.check_circle);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(snackIcon, color: AppColors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
          if (actionOnPressed != null)
            TextButton(
              onPressed: actionOnPressed,
              style: TextButton.styleFrom(foregroundColor: AppColors.white),
              child: Text(actionText, style: AppTextStyles.button),
            ),
        ],
      ),
      backgroundColor: bgColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      duration: duration,
      elevation: 6,
    ),
  );
}
