import 'dart:io';
import 'package:MARN/core/enums/models/enum_item.dart';

import 'package:MARN/features/property/domain/entities/property_sub_entities.dart';

abstract class PropertyEditEntity {
  int id;
  String title;
  String description;
  EnumItem type;
  bool isShared;
  int maxOccupants;
  int bedrooms;
  int beds;
  int bathrooms;
  num price;
  EnumItem rentalUnit;
  String address;
  EnumItem city;
  EnumItem governorate;
  String zipCode;
  num squareMeters;
  num latitude;
  num longitude;
  
  bool? isActive;

  String? primaryImageUrl;
  File? newPrimaryImage;

  String? proofOfOwnershipUrl;
  File? newProofOfOwnership;

  List<PropertyMediaItemEntity>? media;
  List<int>? removedMediaIds;
  List<File>? addedMediaFiles;

  List<PropertyRuleItemEntity>? rules;
  List<int>? removedRuleIds;
  List<String>? addedRuleTexts;

  List<PropertyAmenityItemEntity>? amenities;
  List<int>? removedAmenityIds;
  List<EnumItem>? addedAmenities;

  PropertyEditEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.isShared,
    required this.maxOccupants,
    required this.bedrooms,
    required this.beds,
    required this.bathrooms,
    required this.rentalUnit,
    required this.address,
    required this.city,
    required this.governorate,
    required this.zipCode,
    required this.squareMeters,
    required this.primaryImageUrl,
    required this.newPrimaryImage,
    required this.proofOfOwnershipUrl,
    required this.newProofOfOwnership,
    required this.latitude,
    required this.longitude,
    required this.price,
    required this.media,
    required this.rules,
    required this.amenities,
    required this.removedMediaIds,
    required this.addedMediaFiles,
    required this.removedRuleIds,
    required this.addedRuleTexts,
    required this.removedAmenityIds,
    required this.addedAmenities,
    this.isActive,
  });
}
