import 'package:MARN/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final IconData iconData;
  const CustomIcon({super.key, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(iconData, color: AppColors.white, size: 36),
    );
  }
}
