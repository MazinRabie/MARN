import 'package:MARN/features/property/domain/entities/card/base_property_card.dart';
import 'package:MARN/features/property/presentation/ui/widgets/owner_property_card.dart';
import 'package:MARN/features/property/presentation/ui/widgets/viewer_property_card.dart';
import 'package:flutter/material.dart';

class PropertyCard extends StatelessWidget {
  final int index;
  const PropertyCard({super.key, required this.property, required this.index});

  final BasePropertyCard property;

  @override
  Widget build(BuildContext context) {
    if (property.isOwner) {
      return OwnerPropertyCard(property: property.asOwner!, index: index);
    } else {
      return ViewerPropertyCard(property: property.asViewer!);
    }
  }
}
