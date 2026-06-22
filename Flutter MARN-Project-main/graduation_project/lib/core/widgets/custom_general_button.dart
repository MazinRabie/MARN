import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomGeneralButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final bool isLoading;
  final bool isWidthLessThanDefault;
  final IconData? icon;

  const CustomGeneralButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.isLoading = false,
    this.isWidthLessThanDefault = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isWidthLessThanDefault ? null : double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          side: BorderSide(color: borderColor ?? Colors.transparent),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (icon != null)
                    Icon(icon, color: textColor ?? AppColors.white, size: 20),
                  if (icon != null) const SizedBox(width: 8),
                  Text(
                    text,
                    style: AppTextStyles.button.copyWith(
                      color: textColor ?? AppColors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
