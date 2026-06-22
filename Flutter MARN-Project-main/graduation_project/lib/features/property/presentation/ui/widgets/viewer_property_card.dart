import 'package:MARN/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/features/property/domain/entities/card/viewer_property_card_entity.dart';
import 'package:MARN/features/property/presentation/ui/widgets/property_card_layout.dart';
import 'package:flutter/material.dart';

class ViewerPropertyCard extends StatelessWidget {
  final ViewerPropertyCardEntity property;
  const ViewerPropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return PropertyCardLayout(
      property: property,
      extraInfoRow: [],
      bottomInfoRow: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.people_outline, size: 18),
            const SizedBox(width: 6),
            Text(
              "${LocaleKeys.propertyDetailsMaxOccupants.tr()}: ${property.maxOccupants}",
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bed_outlined, size: 18),
            const SizedBox(width: 6),
            Text(
              "${property.bedrooms} ${LocaleKeys.propertyDetailsBeds.tr()}",
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bathtub_outlined, size: 18),
            const SizedBox(width: 6),
            Text(
              "${property.bathrooms} ${LocaleKeys.propertyDetailsBaths.tr()}",
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
