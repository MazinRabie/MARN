import 'package:MARN/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LoveButton extends StatelessWidget {
  final bool isLiked;
  final void Function()? onPressed;
  const LoveButton({super.key, required this.isLiked, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? AppColors.love : AppColors.textPrimary,
      ),
      onPressed: onPressed,
    );
  }
}
