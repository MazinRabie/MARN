import 'package:MARN/core/enums/models/enum_item.dart';

class PropertySearchParameters {
  final String? keyword;
  final double? latitude;
  final double? longitude;
  final double? radiusKm;
  final EnumItem? city;
  final EnumItem? governorate;
  final EnumItem? type;
  final EnumItem? rentalUnit;
  final bool? isShared;
  final double? minPrice;
  final double? maxPrice;
  final int? minBedrooms;
  final int? minBeds;
  final int? minBathrooms;
  final int? minMaxOccupants;
  final double? minSquareMeters;
  final double? maxSquareMeters;
  final double? minRating;
  final List<EnumItem>? amenities;
  final EnumItem? sortBy;
  final bool? sortAscending;
  final int? page;
  final int? pageSize;

  PropertySearchParameters({
    this.keyword,
    this.latitude,
    this.longitude,
    this.radiusKm,
    this.city,
    this.governorate,
    this.type,
    this.rentalUnit,
    this.isShared,
    this.minPrice,
    this.maxPrice,
    this.minBedrooms,
    this.minBeds,
    this.minBathrooms,
    this.minMaxOccupants,
    this.minSquareMeters,
    this.maxSquareMeters,
    this.minRating,
    this.amenities,
    this.sortBy,
    this.sortAscending,
    this.page,
    this.pageSize,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (keyword != null) map['Keyword'] = keyword;
    if (latitude != null) map['Latitude'] = latitude;
    if (longitude != null) map['Longitude'] = longitude;
    if (radiusKm != null) map['RadiusKm'] = radiusKm;
    if (city != null) map['City'] = city!.toBackendValue();
    if (governorate != null) map['Governorate'] = governorate!.toBackendValue();
    if (type != null) map['Type'] = type!.toBackendValue();
    if (rentalUnit != null) map['RentalUnit'] = rentalUnit!.toBackendValue();
    if (isShared != null) map['IsShared'] = isShared;
    if (minPrice != null) map['MinPrice'] = minPrice;
    if (maxPrice != null) map['MaxPrice'] = maxPrice;
    if (minBedrooms != null) map['MinBedrooms'] = minBedrooms;
    if (minBeds != null) map['MinBeds'] = minBeds;
    if (minBathrooms != null) map['MinBathrooms'] = minBathrooms;
    if (minMaxOccupants != null) map['MinMaxOccupants'] = minMaxOccupants;
    if (minSquareMeters != null) map['MinSquareMeters'] = minSquareMeters;
    if (maxSquareMeters != null) map['MaxSquareMeters'] = maxSquareMeters;
    if (minRating != null) map['MinRating'] = minRating;
    // Dio automatically encodes list query parameters if added as List, but sometimes needs special handling depending on backend.
    // Usually List<String> is fine for typical setups. If it needs duplicate keys, we might need a custom serializer or just pass the list.
    if (amenities != null && amenities!.isNotEmpty) {
      map['Amenities'] = amenities!.map((e) => e.toBackendValue()).toList();
    }
    if (sortBy != null) map['SortBy'] = sortBy!.toBackendValue();
    if (sortAscending != null) map['SortAscending'] = sortAscending;
    if (page != null) map['Page'] = page;
    if (pageSize != null) map['PageSize'] = pageSize;
    return map;
  }

  PropertySearchParameters copyWith({
    String? keyword,
    double? latitude,
    double? longitude,
    double? radiusKm,
    EnumItem? city,
    EnumItem? governorate,
    EnumItem? type,
    EnumItem? rentalUnit,
    bool? isShared,
    double? minPrice,
    double? maxPrice,
    int? minBedrooms,
    int? minBeds,
    int? minBathrooms,
    int? minMaxOccupants,
    double? minSquareMeters,
    double? maxSquareMeters,
    double? minRating,
    List<EnumItem>? amenities,
    EnumItem? sortBy,
    bool? sortAscending,
    int? page,
    int? pageSize,
  }) {
    return PropertySearchParameters(
      keyword: keyword ?? this.keyword,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusKm: radiusKm ?? this.radiusKm,
      city: city ?? this.city,
      governorate: governorate ?? this.governorate,
      type: type ?? this.type,
      rentalUnit: rentalUnit ?? this.rentalUnit,
      isShared: isShared ?? this.isShared,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minBedrooms: minBedrooms ?? this.minBedrooms,
      minBeds: minBeds ?? this.minBeds,
      minBathrooms: minBathrooms ?? this.minBathrooms,
      minMaxOccupants: minMaxOccupants ?? this.minMaxOccupants,
      minSquareMeters: minSquareMeters ?? this.minSquareMeters,
      maxSquareMeters: maxSquareMeters ?? this.maxSquareMeters,
      minRating: minRating ?? this.minRating,
      amenities: amenities ?? this.amenities,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
