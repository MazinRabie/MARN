import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/enums/utils/enum_helper.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/widgets/enum_select_field.dart.dart';
import 'package:MARN/features/property/domain/entities/property_search_parameters.dart';
import 'package:MARN/features/property/presentation/ui/models/property_form_state.dart';
import 'package:MARN/features/property/presentation/ui/widgets/amenity_box.dart';
import 'package:MARN/features/property/presentation/ui/widgets/pickLocation_screen.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class PropertyFilterBottomSheet extends StatefulWidget {
  final PropertySearchParameters initialParams;
  final ValueChanged<PropertySearchParameters> onApply;
  final ScrollController scrollController;

  const PropertyFilterBottomSheet({
    super.key,
    required this.initialParams,
    required this.onApply,
    required this.scrollController,
  });

  @override
  State<PropertyFilterBottomSheet> createState() =>
      _PropertyFilterBottomSheetState();
}

class _PropertyFilterBottomSheetState extends State<PropertyFilterBottomSheet> {
  late String? keyword;
  late EnumItem? city;
  late EnumItem? governorate;
  late EnumItem? type;
  late EnumItem? rentalUnit;
  late EnumItem? sortBy;
  late bool? sortAscending;
  late double? minPrice;
  late double? maxPrice;
  late int? minBedrooms;
  late int? minBeds;
  late int? minBathrooms;
  late int? minMaxOccupants;
  late double? minSquareMeters;
  late double? maxSquareMeters;
  late double? minRating;
  late bool? isShared;
  late double? latitude;
  late double? longitude;
  late double? radiusKm;
  List<EnumItem> selectedAmenities = [];
  List<EnumItem> amenitiesList = [];

  @override
  void initState() {
    super.initState();
    keyword = widget.initialParams.keyword;

    city = widget.initialParams.city;
    governorate = widget.initialParams.governorate;
    type = widget.initialParams.type;
    rentalUnit = widget.initialParams.rentalUnit;
    sortBy = widget.initialParams.sortBy;

    sortAscending = widget.initialParams.sortAscending;
    minPrice = widget.initialParams.minPrice;
    maxPrice = widget.initialParams.maxPrice;
    minBedrooms = widget.initialParams.minBedrooms;
    minBeds = widget.initialParams.minBeds;
    minBathrooms = widget.initialParams.minBathrooms;
    minMaxOccupants = widget.initialParams.minMaxOccupants;
    minSquareMeters = widget.initialParams.minSquareMeters;
    maxSquareMeters = widget.initialParams.maxSquareMeters;
    minRating = widget.initialParams.minRating;
    isShared = widget.initialParams.isShared;
    latitude = widget.initialParams.latitude;
    longitude = widget.initialParams.longitude;
    radiusKm = widget.initialParams.radiusKm;
    selectedAmenities = widget.initialParams.amenities != null
        ? List.from(widget.initialParams.amenities!)
        : [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (amenitiesList.isEmpty) {
      amenitiesList = EnumHelper.getEnum(context, EnumType.amenityTypes) ?? [];
    }
  }

  void _pickLocation() async {
    final formState = PropertyFormState.empty();
    if (latitude != null && longitude != null) {
      formState.latitude = latitude;
      formState.longitude = longitude;
    }
    final LatLng? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PickLocationScreen(property: formState),
      ),
    );
    if (result != null) {
      setState(() {
        latitude = result.latitude;
        longitude = result.longitude;
        if (radiusKm == null) radiusKm = 10;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(LocaleKeys.propertyFiltersTitle.tr(), style: AppTextStyles.bodyLarge),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                _buildSectionTitle(LocaleKeys.propertyFiltersSorting.tr()),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: EnumSelectField(
                        labelText: LocaleKeys.propertyFiltersSortBy.tr(),
                        enumType: EnumType.propertySortByOptions,
                        initialValue: sortBy,
                        onChanged: (v) => setState(() => sortBy = v),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdown(
                        LocaleKeys.propertyFiltersOrder.tr(),
                        sortAscending == null
                            ? null
                            : (sortAscending!
                                ? LocaleKeys.propertyFiltersAscending.tr()
                                : LocaleKeys.propertyFiltersDescending.tr()),
                        [
                          LocaleKeys.propertyFiltersAscending.tr(),
                          LocaleKeys.propertyFiltersDescending.tr()
                        ],
                        (v) {
                          if (v == null)
                            setState(() => sortAscending = null);
                          else
                            setState(() => sortAscending =
                                v == LocaleKeys.propertyFiltersAscending.tr());
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _buildSectionTitle(LocaleKeys.propertyFiltersLocation.tr()),
                Row(
                  children: [
                    Expanded(
                      child: EnumSelectField(
                        labelText: LocaleKeys.propertyFiltersGovernorate.tr(),
                        enumType: EnumType.governorates,
                        initialValue: governorate,
                        onChanged: (v) => setState(() => governorate = v),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: EnumSelectField(
                        labelText: LocaleKeys.propertyFiltersCity.tr(),
                        enumType: EnumType.cities,
                        initialValue: city,
                        onChanged: (v) => setState(() => city = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.propertyFiltersMapSearch.tr(),
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _pickLocation,
                            icon: const Icon(Icons.map),
                            label: Text(
                              latitude != null
                                  ? LocaleKeys.propertyFiltersChange.tr()
                                  : LocaleKeys.propertyFiltersSelectOnMap.tr(),
                            ),
                          ),
                        ],
                      ),
                      if (latitude != null && longitude != null) ...[
                        Text(
                          LocaleKeys.propertyFiltersSelectedCoords.tr(
                            namedArgs: {
                              'lat': latitude!.toStringAsFixed(4),
                              'lng': longitude!.toStringAsFixed(4),
                            },
                          ),
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              LocaleKeys.propertyFiltersRadius.tr(),
                              style: AppTextStyles.bodyMedium,
                            ),
                            Expanded(
                              child: Slider(
                                value: radiusKm ?? 10,
                                min: 1,
                                max: 100,
                                divisions: 99,
                                label: LocaleKeys.propertyFiltersRadiusValue.tr(
                                  namedArgs: {
                                    'km': (radiusKm?.round() ?? 10).toString(),
                                  },
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    radiusKm = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                _buildSectionTitle(LocaleKeys.propertyFiltersDetails.tr()),
                EnumSelectField(
                  labelText: LocaleKeys.propertyFiltersType.tr(),
                  enumType: EnumType.propertyTypes,
                  initialValue: type,
                  onChanged: (v) => setState(() => type = v),
                ),
                const SizedBox(height: 16),
                EnumSelectField(
                  labelText: LocaleKeys.propertyFiltersRentalUnit.tr(),
                  enumType: EnumType.rentalUnits,
                  initialValue: rentalUnit,
                  onChanged: (v) => setState(() => rentalUnit = v),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: Text(
                    LocaleKeys.propertyFiltersIsShared.tr(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.primary,
                  value: isShared ?? false,
                  onChanged: (val) {
                    setState(() {
                      isShared = val ? true : null;
                    });
                  },
                ),
                const SizedBox(height: 24),

                _buildSectionTitle(LocaleKeys.propertyFiltersPricingRating.tr()),
                Row(
                  children: [
                    Expanded(
                      child: _buildNumberField(
                        LocaleKeys.propertyFiltersMinPrice.tr(),
                        minPrice,
                        (v) => setState(() => minPrice = v),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildNumberField(
                        LocaleKeys.propertyFiltersMaxPrice.tr(),
                        maxPrice,
                        (v) => setState(() => maxPrice = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      LocaleKeys.propertyFiltersMinRating.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: minRating ?? 0,
                        min: 0,
                        max: 5,
                        divisions: 5,
                        label: minRating == 0 || minRating == null
                            ? LocaleKeys.propertyFiltersAny.tr()
                            : minRating.toString(),
                        onChanged: (val) {
                          setState(() {
                            minRating = val == 0 ? null : val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _buildSectionTitle(LocaleKeys.propertyFiltersCapacitySpace.tr()),
                Row(
                  children: [
                    Expanded(
                      child: _buildIntField(
                        LocaleKeys.propertyFiltersMinBedrooms.tr(),
                        minBedrooms,
                        (v) => setState(() => minBedrooms = v),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildIntField(
                        LocaleKeys.propertyFiltersMinBeds.tr(),
                        minBeds,
                        (v) => setState(() => minBeds = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildIntField(
                        LocaleKeys.propertyFiltersMinBathrooms.tr(),
                        minBathrooms,
                        (v) => setState(() => minBathrooms = v),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildIntField(
                        LocaleKeys.propertyFiltersMaxOccupants.tr(),
                        minMaxOccupants,
                        (v) => setState(() => minMaxOccupants = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildNumberField(
                        LocaleKeys.propertyFiltersMinSqMeters.tr(),
                        minSquareMeters,
                        (v) => setState(() => minSquareMeters = v),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildNumberField(
                        LocaleKeys.propertyFiltersMaxSqMeters.tr(),
                        maxSquareMeters,
                        (v) => setState(() => maxSquareMeters = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _buildSectionTitle(LocaleKeys.propertyFiltersAmenities.tr()),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: amenitiesList.map((amenity) {
                    final isSelected = selectedAmenities.any((e) => e.id == amenity.id);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedAmenities.removeWhere((e) => e.id == amenity.id);
                          } else {
                            selectedAmenities.add(amenity);
                          }
                        });
                      },
                      child: Stack(
                        children: [
                          Opacity(
                            opacity: isSelected ? 1.0 : 0.6,
                            child: AmenityBox(label: amenity.displayName.isNotEmpty ? amenity.displayName : amenity.name),
                          ),
                          if (isSelected)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 12, bottom: 24),
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomGeneralButton(
                    text: LocaleKeys.propertyFiltersClearAll.tr(),
                    backgroundColor: AppColors.onPrimary,
                    textColor: AppColors.primary,
                    borderColor: AppColors.primaryLight,
                    onPressed: () {
                      setState(() {
                        keyword = null;
                        city = null;
                        governorate = null;
                        type = null;
                        rentalUnit = null;
                        sortBy = null;
                        sortAscending = null;
                        minPrice = null;
                        maxPrice = null;
                        minBedrooms = null;
                        minBeds = null;
                        minBathrooms = null;
                        minMaxOccupants = null;
                        minSquareMeters = null;
                        maxSquareMeters = null;
                        minRating = null;
                        isShared = null;
                        latitude = null;
                        longitude = null;
                        radiusKm = null;
                        selectedAmenities.clear();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomGeneralButton(
                    text: LocaleKeys.propertyFiltersApply.tr(),
                    onPressed: () {
                      final params = PropertySearchParameters(
                        keyword: keyword,
                        city: city,
                        governorate: governorate,
                        type: type,
                        rentalUnit: rentalUnit,
                        sortBy: sortBy,
                        sortAscending: sortAscending,
                        minPrice: minPrice,
                        maxPrice: maxPrice,
                        minBedrooms: minBedrooms,
                        minBeds: minBeds,
                        minBathrooms: minBathrooms,
                        minMaxOccupants: minMaxOccupants,
                        minSquareMeters: minSquareMeters,
                        maxSquareMeters: maxSquareMeters,
                        minRating: minRating,
                        isShared: isShared,
                        latitude: latitude,
                        longitude: longitude,
                        radiusKm: radiusKm,
                        amenities: selectedAmenities.isNotEmpty
                            ? selectedAmenities
                            : null,
                      );
                      widget.onApply(params);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: AppTextStyles.bodyLarge),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodyLarge),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              hint: Text(LocaleKeys.commonSelect.tr(), style: AppTextStyles.bodyHint),
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(LocaleKeys.propertyFiltersAny.tr()),
                ),
                ...options.map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: value == e
                          ? AppTextStyles.bodyLarge
                          : AppTextStyles.bodyMedium,
                    ),
                  ),
                ),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberField(
    String label,
    double? value,
    ValueChanged<double?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value?.toString() ?? "",
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: LocaleKeys.propertyFiltersAny.tr(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          onChanged: (val) => onChanged(double.tryParse(val)),
        ),
      ],
    );
  }

  Widget _buildIntField(
    String label,
    int? value,
    ValueChanged<int?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value?.toString() ?? "",
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: LocaleKeys.propertyFiltersAny.tr(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          onChanged: (val) => onChanged(int.tryParse(val)),
        ),
      ],
    );
  }
}
