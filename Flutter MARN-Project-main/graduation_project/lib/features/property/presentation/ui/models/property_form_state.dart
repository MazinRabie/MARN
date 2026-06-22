import 'dart:io';
import 'package:MARN/core/enums/models/enum_item.dart';

import 'package:MARN/features/property/data/models/property_add_model.dart';
import 'package:MARN/features/property/data/models/property_edit_model.dart';
import 'package:MARN/features/property/domain/entities/property_add_entity.dart';
import 'package:MARN/features/property/domain/entities/property_edit_entity.dart';
import 'package:MARN/features/property/domain/entities/property_sub_entities.dart';

class PropertyFormState {
  final bool isEdit;
  final int? propertyId;

  // Basic Info
  String? title;
  String? description;
  EnumItem? type;
  bool? isShared;
  int? maxOccupants;
  int? bedrooms;
  int? beds;
  int? bathrooms;
  num? price;
  EnumItem? rentalUnit;
  String? address;
  EnumItem? city;
  EnumItem? governorate;
  String? zipCode;
  num? squareMeters;
  num? latitude;
  num? longitude;

  // Media
  File? newPrimaryImage;
  String? existingPrimaryImageUrl;

  File? newProofOfOwnership;
  String? existingProofOfOwnershipUrl;

  List<File> addedMediaFiles = [];
  List<PropertyMediaItemEntity> existingMedia = [];
  List<int> removedMediaIds = [];

  // Amenities
  List<EnumItem> addedAmenities = [];
  List<PropertyAmenityItemEntity> existingAmenities = [];
  List<int> removedAmenityIds = [];

  // Rules
  List<String> addedRules = [];
  List<PropertyRuleItemEntity> existingRules = [];
  List<int> removedRuleIds = [];

  PropertyFormState.empty() : isEdit = false, propertyId = null;

  PropertyFormState.fromEditEntity(PropertyEditEntity entity)
    : isEdit = true,
      propertyId = entity.id,
      title = entity.title,
      description = entity.description,
      type = entity.type,
      isShared = entity.isShared,
      maxOccupants = entity.maxOccupants,
      bedrooms = entity.bedrooms,
      beds = entity.beds,
      bathrooms = entity.bathrooms,
      price = entity.price,
      rentalUnit = entity.rentalUnit,
      address = entity.address,
      city = entity.city,
      governorate = entity.governorate,
      zipCode = entity.zipCode,
      squareMeters = entity.squareMeters,
      latitude = entity.latitude,
      longitude = entity.longitude,
      existingPrimaryImageUrl = entity.primaryImageUrl,
      existingProofOfOwnershipUrl = entity.proofOfOwnershipUrl,
      existingMedia = entity.media != null ? List.from(entity.media!) : [],
      existingAmenities = entity.amenities != null
          ? List.from(entity.amenities!)
          : [],
      existingRules = entity.rules != null ? List.from(entity.rules!) : [];

  PropertyAddEntity toAddEntity() {
    return PropertyAddModel(
      title: title,
      description: description,
      type: type,
      isShared: isShared,
      maxOccupants: maxOccupants,
      bedrooms: bedrooms,
      beds: beds,
      bathrooms: bathrooms,
      price: price,
      rentalUnit: rentalUnit,
      address: address,
      city: city,
      governorate: governorate,
      zipCode: zipCode,
      squareMeters: squareMeters,
      latitude: latitude,
      longitude: longitude,
      proofOfOwnership: newProofOfOwnership,
      primaryImage: newPrimaryImage,
      mediaFiles: addedMediaFiles,
      amenities: addedAmenities,
      rules: addedRules,
    );
  }

  PropertyEditEntity toEditEntity() {
    return PropertyEditModel(
      id: propertyId!,
      title: title ?? '',
      description: description ?? '',
      type: type ?? EnumItem.empty,
      isShared: isShared ?? false,
      maxOccupants: maxOccupants ?? 0,
      bedrooms: bedrooms ?? 0,
      beds: beds ?? 0,
      bathrooms: bathrooms ?? 0,
      price: price?.toInt() ?? 0,
      rentalUnit: rentalUnit ?? EnumItem.empty,
      address: address ?? '',
      city: city ?? EnumItem.empty,
      governorate: governorate ?? EnumItem.empty,
      zipCode: zipCode ?? '',
      squareMeters: squareMeters?.toInt() ?? 0,
      latitude: latitude ?? 0.0,
      longitude: longitude ?? 0.0,
      newPrimaryImage: newPrimaryImage,
      primaryImageUrl: existingPrimaryImageUrl,
      newProofOfOwnership: newProofOfOwnership,
      proofOfOwnershipUrl: existingProofOfOwnershipUrl,
      media: existingMedia.isEmpty ? null : existingMedia,
      addedMediaFiles: addedMediaFiles.isEmpty ? null : addedMediaFiles,
      removedMediaIds: removedMediaIds.isEmpty ? null : removedMediaIds,
      amenities: existingAmenities.isEmpty ? null : existingAmenities,
      addedAmenities: addedAmenities.isEmpty ? null : addedAmenities,
      removedAmenityIds: removedAmenityIds.isEmpty ? null : removedAmenityIds,
      rules: existingRules.isEmpty ? null : existingRules,
      addedRuleTexts: addedRules.isEmpty ? null : addedRules,
      removedRuleIds: removedRuleIds.isEmpty ? null : removedRuleIds,
    );
  }
}
