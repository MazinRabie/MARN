import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/enums/utils/enum_helper.dart';
import 'package:MARN/core/widgets/general_box_option.dart';
import 'package:MARN/features/property/presentation/ui/models/property_form_state.dart';
import 'package:MARN/features/property/presentation/ui/widgets/amenity_box.dart';
import 'package:flutter/material.dart';

class PropertyAmenitiesStep extends StatefulWidget {
  const PropertyAmenitiesStep({
    super.key,
    required this.formKey,
    required this.property,
  });
  final PropertyFormState property;
  final GlobalKey<FormState> formKey;

  @override
  State<PropertyAmenitiesStep> createState() => _PropertyAmenitiesStepState();
}

class _PropertyAmenitiesStepState extends State<PropertyAmenitiesStep> {
  Set<String> selectedAmenityNames = {};
  List<EnumItem> amenitiesList = [];

  @override
  void initState() {
    super.initState();
    if (widget.property.isEdit) {
      if (widget.property.existingAmenities.isNotEmpty) {
        final validExisting = widget.property.existingAmenities.where(
          (e) => !widget.property.removedAmenityIds.contains(e.id),
        );
        selectedAmenityNames.addAll(
          validExisting.map((e) => e.amenity.name.toLowerCase()),
        );
      }
      if (widget.property.addedAmenities.isNotEmpty) {
        selectedAmenityNames.addAll(
          widget.property.addedAmenities.map((e) => e.name.toLowerCase()),
        );
      }
    } else {
      if (widget.property.addedAmenities.isNotEmpty) {
        selectedAmenityNames.addAll(
          widget.property.addedAmenities.map((e) => e.name.toLowerCase()),
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (amenitiesList.isEmpty) {
      amenitiesList = EnumHelper.getEnum(context, EnumType.amenityTypes) ?? [];
    }
  }

  void updatePropertyState() {
    if (widget.property.isEdit) {
      widget.property.removedAmenityIds = widget.property.existingAmenities
          .where(
            (e) => !selectedAmenityNames.contains(e.amenity.name.toLowerCase()),
          )
          .map((e) => e.id)
          .toList();

      widget.property.addedAmenities = selectedAmenityNames
          .where(
            (s) => !widget.property.existingAmenities.any(
              (e) => e.amenity.name.toLowerCase() == s,
            ),
          )
          .map(
            (s) => amenitiesList.firstWhere(
              (a) => a.name.toLowerCase() == s,
              orElse: () => EnumItem(id: 0, name: s, displayName: s),
            ),
          )
          .toList();
    } else {
      widget.property.addedAmenities = selectedAmenityNames
          .map(
            (s) => amenitiesList.firstWhere(
              (a) => a.name.toLowerCase() == s,
              orElse: () => EnumItem(id: 0, name: s, displayName: s),
            ),
          )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    updatePropertyState();
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 8,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: amenitiesList.map((amenity) {
            final nameStr = amenity.name.toLowerCase();
            final isSelected = selectedAmenityNames.contains(nameStr);
            return GeneralBoxOption(
              label: amenity.displayName.isNotEmpty
                  ? amenity.displayName
                  : amenity.name,
              icon: AmenityBox.getIconForAmenity(amenity.name),
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedAmenityNames.remove(nameStr);
                  } else {
                    selectedAmenityNames.add(nameStr);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
