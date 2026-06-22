import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class BuildStaticCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData? icon;
  final double? height;
  final String? imagePath;
  const BuildStaticCard({
    super.key,
    required this.title,
    required this.description,
    this.icon,
    this.height,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 150,
      width: 165,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryDark, width: 1.5),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imagePath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    imagePath!,
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                )
              : Icon(icon, color: AppColors.primary, size: 40),
          SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelLarge,
          ),
          SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}
