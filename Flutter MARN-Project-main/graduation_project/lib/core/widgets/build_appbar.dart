import 'package:flutter/material.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_gradient.dart';
import 'package:MARN/core/theme/app_text_styles.dart';

Widget buildAppBar(BuildContext context) {
  return SizedBox(
    height: 50,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: ShapeDecoration(
            gradient: AppGradient.logoGradient,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadows: [
              BoxShadow(
                color: AppColors.black.withAlpha(25), // 0.1 alpha
                blurRadius: 6,
                offset: const Offset(0, 4),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: AppColors.black.withAlpha(25), // 0.1 alpha
                blurRadius: 15,
                offset: const Offset(0, 10),
                spreadRadius: -3,
              ),
            ],
          ),
          child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "assets/images/logo_outline.png",
                  fit: BoxFit.cover,
                  height: 100,
                  width: 100,
                ),
              ),
        ),
        SizedBox(
          width: 100,
          height: 50,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: -3.11,
                child: Text('MARN', style: AppTextStyles.logoTextSmall),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
