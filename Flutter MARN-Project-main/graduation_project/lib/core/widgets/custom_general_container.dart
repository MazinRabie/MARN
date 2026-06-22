import 'package:MARN/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomGeneralContainer extends StatelessWidget {
  const CustomGeneralContainer({super.key, required this.child, this.margin});

  final Widget child;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.9 > 1000 ? 1000 : width * 0.9,
      margin:
          margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: AppColors.shadow,
          ),
        ],
      ),
      child: child,
    );
  }
}
