import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AmenityBox extends StatelessWidget {
  final String label;
  final Color? boxColor;
  final Color? borderColor;

  const AmenityBox({
    super.key,
    required this.label,
    this.boxColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: ShapeDecoration(
        color: boxColor ?? AppColors.primarySoft,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.6, color: borderColor ?? AppColors.primary),
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(getIconForAmenity(label)),
          const SizedBox(height: 10),
          Text(
            label,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  static IconData getIconForAmenity(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('wifi')) return Icons.wifi;
    if (lowerName.contains('parking')) return Icons.car_rental;
    if (lowerName.contains('air')) return Icons.air;
    if (lowerName.contains('heat')) return Icons.heat_pump;
    if (lowerName.contains('wash')) return Icons.local_laundry_service;
    if (lowerName.contains('dry')) return Icons.dry;
    if (lowerName.contains('tv')) return Icons.tv;
    if (lowerName.contains('elevator')) return Icons.elevator;
    if (lowerName.contains('pool')) return Icons.pool;
    if (lowerName.contains('gym')) return Icons.fitness_center;
    if (lowerName.contains('kitchen') ||
        lowerName.contains('dish') ||
        lowerName.contains('microwave') ||
        lowerName.contains('refrigerator'))
      return Icons.kitchen;
    if (lowerName.contains('balcony')) return Icons.balcony;
    if (lowerName.contains('hardwood')) return Icons.home_repair_service;
    if (lowerName.contains('storage')) return Icons.storage;
    if (lowerName.contains('security')) return Icons.security;
    if (lowerName.contains('pet')) return Icons.pets;
    return Icons.check_circle_outline;
  }
}
