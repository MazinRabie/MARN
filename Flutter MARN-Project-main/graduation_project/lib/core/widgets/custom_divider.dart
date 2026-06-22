import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.darkGray, indent: 10)),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.darkGray),
          ),
        ),

        const Expanded(
          child: Divider(color: AppColors.darkGray, endIndent: 10),
        ),
      ],
    );
  }
}
