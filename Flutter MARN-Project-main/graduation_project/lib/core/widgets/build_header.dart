import 'package:flutter/material.dart';
import 'package:MARN/core/theme/app_text_styles.dart';

class BuildHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? date;

  const BuildHeader({super.key, required this.title, required this.subtitle, this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineLarge,
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium,
        ),
        if (date != null)
          Text(
            date!,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),
      ],
    );
  }
}
