import 'package:MARN/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OnlineState extends StatelessWidget {
  final bool isOnline;
  const OnlineState({super.key, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: isOnline ? AppColors.success : AppColors.grey,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white, width: 2),
        ),
      ),
    );
  }
}
