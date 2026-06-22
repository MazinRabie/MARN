import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class StepTitle extends StatelessWidget {
  final int stepNumber;
  const StepTitle({super.key, required this.stepNumber});

  String _getTitle(int stepNumber) {
    switch (stepNumber) {
      case 0:
        return LocaleKeys.propertyFormStepsDetails.tr();
      case 1:
        return LocaleKeys.propertyFormStepsAmenities.tr();
      case 2:
        return LocaleKeys.propertyFormStepsPhotos.tr();
      case 3:
        return LocaleKeys.propertyFormStepsPricing.tr();
      case 4:
        return LocaleKeys.propertyFormStepsRules.tr();
      case 5:
        return LocaleKeys.propertyFormStepsLegal.tr();
      default:
        return "";
    }
  }

  IconData _getIcon(int stepNumber) {
    switch (stepNumber) {
      case 0:
        return Icons.home_outlined;
      case 1:
        return Icons.check_circle_outline;
      case 2:
        return Icons.photo_outlined;
      case 3:
        return Icons.attach_money;
      case 4:
        return Icons.rule_rounded;
      case 5:
        return Icons.description;
      default:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (index) {
            final isActive = index == stepNumber;
            final isDone = index < stepNumber;

            return Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isDone
                        ? AppColors.primary
                        : isActive
                        ? AppColors.primarySoft
                        : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIcon(index),
                    size: 18,
                    color: isDone
                        ? Colors.white
                        : isActive
                        ? AppColors.primary
                        : Colors.grey,
                  ),
                ),

                if (index != 5)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.04,
                    height: 2,
                    color: index < stepNumber
                        ? AppColors.primary
                        : Colors.grey.shade300,
                  ),
              ],
            );
          }),
        ),

        const SizedBox(height: 10),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _getTitle(stepNumber),
            key: ValueKey(stepNumber),
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}
