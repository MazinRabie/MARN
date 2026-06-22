import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class StatusBadgeWidget extends StatelessWidget {
  final EnumItem status;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const StatusBadgeWidget({
    super.key,
    required this.status,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getStatusColor(status.name),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding,
      child: Text(
        status.displayName.isNotEmpty
            ? status.displayName.toUpperCase()
            : status.name.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
      ),
    );
  }

  Color _getStatusColor(String name) {
    final lowerName = name.toLowerCase();

    // Success colors
    if (lowerName == 'verified' ||
        lowerName == 'active' ||
        lowerName == 'completed' ||
        lowerName == 'approved' ||
        lowerName == 'success') {
      return AppColors.success;
    }
    // Pending colors
    if (lowerName == 'pending' ||
        lowerName == 'processing' ||
        lowerName == 'in_progress') {
      return AppColors.pending;
    }
    // Warning / Unverified colors
    if (lowerName == 'unverified' || lowerName == 'draft') {
      return AppColors.unverified;
    }

    // Neutral color for unknown or empty states
    if (lowerName == 'unknown' || lowerName.isEmpty || lowerName == 'none') {
      return Colors.grey;
    }

    // Default to Error / Danger color for negative or unknown statuses
    return AppColors.error;
  }
}
