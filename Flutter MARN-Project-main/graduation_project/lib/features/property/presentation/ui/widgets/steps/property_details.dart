import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/widgets/custom_text_form_field.dart';
import 'package:MARN/core/widgets/enum_select_field.dart.dart';
import 'package:MARN/features/property/presentation/ui/models/property_form_state.dart';
import 'package:MARN/features/property/presentation/ui/widgets/pickLocation_screen.dart';
import 'package:MARN/features/property/presentation/ui/widgets/show_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PropertyDetailsStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final PropertyFormState property;

  const PropertyDetailsStep({
    super.key,
    required this.formKey,
    required this.property,
  });

  @override
  State<PropertyDetailsStep> createState() => _PropertyDetailsStepState();
}

class _PropertyDetailsStepState extends State<PropertyDetailsStep> {
  late final MapController _mapController;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    if (widget.property.latitude != null && widget.property.longitude != null) {
      _selectedLocation = LatLng(
        widget.property.latitude!.toDouble(),
        widget.property.longitude!.toDouble(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        child: Column(
          spacing: 12,
          children: [
            CustomTextFormField(
              type: CustomTextFormFieldType.text,
              initialValue: widget.property.title,
              labelText: LocaleKeys.propertyFormTitle.tr(),
              hintText: LocaleKeys.propertyFormTitleHint.tr(),
              maxLines: 5,
              onChanged: (value) => widget.property.title = value.trim(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.propertyFormTitleRequired.tr();
                }
                if (value.length < 10 || value.length > 100) {
                  return LocaleKeys.propertyFormTitleLength.tr();
                }
                return null;
              },
            ),

            CustomTextFormField(
              type: CustomTextFormFieldType.text,
              initialValue: widget.property.description,
              labelText: LocaleKeys.propertyFormDescription.tr(),
              hintText: LocaleKeys.propertyFormDescriptionHint.tr(),
              maxLines: 5,
              onChanged: (value) => widget.property.description = value.trim(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.propertyFormDescriptionRequired.tr();
                }
                if (value.length < 20 || value.length > 2000) {
                  return LocaleKeys.propertyFormDescriptionLength.tr();
                }
                return null;
              },
            ),

            EnumSelectField(
              enumType: EnumType.propertyTypes,
              initialValue: widget.property.type,
              labelText: LocaleKeys.propertyFiltersType.tr(),
              onChanged: (value) {
                if (value != null) {
                  widget.property.type = value;
                  setState(() {});
                }
              },
            ),

            EnumSelectField(
              enumType: EnumType.governorates,
              initialValue: widget.property.governorate,
              labelText: LocaleKeys.propertyFiltersGovernorate.tr(),
              onChanged: (value) {
                if (value != null) {
                  widget.property.governorate = value;
                  setState(() {});
                }
              },
            ),

            EnumSelectField(
              enumType: EnumType.cities,
              initialValue: widget.property.city,
              labelText: LocaleKeys.propertyFiltersCity.tr(),
              onChanged: (value) {
                if (value != null) {
                  widget.property.city = value;
                  setState(() {});
                }
              },
            ),

            CustomTextFormField(
              type: CustomTextFormFieldType.text,
              initialValue: widget.property.address,
              maxLines: 5,
              labelText: LocaleKeys.propertyFormAddress.tr(),
              hintText: LocaleKeys.propertyFormAddressHint.tr(),
              onChanged: (value) => widget.property.address = value.trim(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.propertyFormAddressRequired.tr();
                }
                return null;
              },
            ),

            CustomTextFormField(
              type: CustomTextFormFieldType.number,
              prefixIcon: Icons.location_on,
              initialValue: widget.property.zipCode,
              labelText: LocaleKeys.propertyFormZip.tr(),
              hintText: LocaleKeys.propertyFormZipHint.tr(),
              onChanged: (value) => widget.property.zipCode = value.trim(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.propertyFormZipRequired.tr();
                }
                return null;
              },
            ),

            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  _selectedLocation != null
                      ? ShowMap(
                          mapController: _mapController,
                          selectedLocation: _selectedLocation!,
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.propertyFormNoLocationSelected.tr(),
                                style: AppTextStyles.labelLarge,
                              ),
                              Icon(
                                Icons.location_on,
                                size: 40,
                                color: AppColors.error,
                              ),
                            ],
                          ),
                        ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: FloatingActionButton.extended(
                      heroTag: 'pick_location_btn',
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PickLocationScreen(property: widget.property),
                          ),
                        );
                        if (result != null && result is LatLng) {
                          final wasMapRendered = _selectedLocation != null;
                          setState(() {
                            widget.property.latitude = result.latitude;
                            widget.property.longitude = result.longitude;
                            _selectedLocation = result;
                          });
                          if (wasMapRendered) {
                            _mapController.move(result, 13);
                          }
                        }
                      },
                      icon: const Icon(Icons.edit_location_alt),
                      label: Text(LocaleKeys.propertyFormChangeLocation.tr()),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            CustomTextFormField(
              type: CustomTextFormFieldType.number,
              prefixIcon: Icons.numbers,
              initialValue: widget.property.squareMeters?.toString(),
              labelText: LocaleKeys.propertyFormSqMeters.tr(),
              hintText: LocaleKeys.propertyFormSqMetersHint.tr(),
              onChanged: (value) =>
                  widget.property.squareMeters = double.tryParse(value) ?? 0.0,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.propertyFormSqMetersRequired.tr();
                }
                return null;
              },
            ),

            CustomTextFormField(
              type: CustomTextFormFieldType.number,
              prefixIcon: Icons.numbers,
              initialValue: widget.property.bedrooms?.toString(),
              labelText: LocaleKeys.propertyFormBedrooms.tr(),
              hintText: LocaleKeys.propertyFormBedroomsHint.tr(),
              onChanged: (value) =>
                  widget.property.bedrooms = int.tryParse(value) ?? 0,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.propertyFormBedroomsRequired.tr();
                }
                if (!(int.parse(value) >= 0 && int.parse(value) <= 50)) {
                  return LocaleKeys.propertyFormBedroomsLength.tr();
                }
                return null;
              },
            ),

            CustomTextFormField(
              type: CustomTextFormFieldType.number,
              prefixIcon: Icons.numbers,
              initialValue: widget.property.bathrooms?.toString(),
              labelText: LocaleKeys.propertyFormBathrooms.tr(),
              hintText: LocaleKeys.propertyFormBathroomsHint.tr(),
              onChanged: (value) =>
                  widget.property.bathrooms = int.tryParse(value) ?? 0,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.propertyFormBathroomsRequired.tr();
                }
                if (!(int.parse(value) >= 0 && int.parse(value) <= 50)) {
                  return LocaleKeys.propertyFormBathroomsLength.tr();
                }
                return null;
              },
            ),

            CustomTextFormField(
              type: CustomTextFormFieldType.number,
              prefixIcon: Icons.numbers,
              initialValue: widget.property.beds?.toString(),
              labelText: LocaleKeys.propertyFormBeds.tr(),
              hintText: LocaleKeys.propertyFormBedsHint.tr(),
              onChanged: (value) =>
                  widget.property.beds = int.tryParse(value) ?? 0,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.propertyFormBedsRequired.tr();
                }
                if (!(int.parse(value) >= 0 && int.parse(value) <= 50)) {
                  return LocaleKeys.propertyFormBedsLength.tr();
                }
                return null;
              },
            ),

            CustomTextFormField(
              type: CustomTextFormFieldType.number,
              prefixIcon: Icons.group,
              initialValue: widget.property.maxOccupants?.toString(),
              labelText: LocaleKeys.propertyFormMaxOccupants.tr(),
              hintText: LocaleKeys.propertyFormMaxOccupantsHint.tr(),
              onChanged: (value) =>
                  widget.property.maxOccupants = int.tryParse(value) ?? 0,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.propertyFormMaxOccupantsRequired.tr();
                }
                if (!(int.parse(value) >= 1 && int.parse(value) <= 50)) {
                  return LocaleKeys.propertyFormMaxOccupantsLength.tr();
                }
                return null;
              },
            ),

            SwitchListTile(
              value: widget.property.isShared ?? false,
              onChanged: (value) {
                setState(() {
                  widget.property.isShared = value;
                });
              },
              title: Text(
                (widget.property.isShared ?? false)
                    ? LocaleKeys.propertyStatusShared.tr()
                    : LocaleKeys.propertyStatusNotShared.tr(),
              ),
              secondary: (widget.property.isShared ?? false)
                  ? const Icon(Icons.groups)
                  : const Icon(Icons.person),
              subtitle: Text(
                (widget.property.isShared ?? false)
                    ? LocaleKeys.propertyStatusSharedSubtitle.tr()
                    : LocaleKeys.propertyStatusNotSharedSubtitle.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
