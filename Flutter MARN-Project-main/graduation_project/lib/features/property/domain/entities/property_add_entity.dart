import 'dart:io';
import 'package:MARN/core/enums/models/enum_item.dart';

abstract class PropertyAddEntity {
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
  File? proofOfOwnership;
  num? latitude;
  num? longitude;
  File? primaryImage;

  List<File>? mediaFiles;
  List<EnumItem>? amenities;
  List<String>? rules;
  PropertyAddEntity({
    required this.title,
    required this.description,
    required this.type,
    required this.isShared,
    required this.maxOccupants,
    required this.bedrooms,
    required this.beds,
    required this.bathrooms,
    required this.price,
    required this.rentalUnit,
    required this.address,
    required this.city,
    required this.governorate,
    required this.zipCode,
    required this.squareMeters,
    required this.proofOfOwnership,
    required this.latitude,
    required this.longitude,
    required this.primaryImage,
    this.mediaFiles,
    this.amenities,
    this.rules,
  });
}
