import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.info_outline,
          color: AppColors.error,
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(message, style: AppTextStyles.metadata),
      ],
    );
  }
}