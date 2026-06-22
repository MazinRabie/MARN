import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class GeneralBoxOption extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isMultiple;
  final IconData icon;

  const GeneralBoxOption({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    this.isMultiple = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        width: 135,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: ShapeDecoration(
          color: isSelected ? AppColors.primarySoft : AppColors.surfaceVariant,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.6,
              color: isSelected ? AppColors.primary : AppColors.transparent,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(height: 10),
            Text(
              label,
              style: AppTextStyles.bodyBold,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
