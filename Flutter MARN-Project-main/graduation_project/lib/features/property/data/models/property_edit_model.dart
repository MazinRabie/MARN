import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/widgets/buildImage_url.dart';
import 'package:MARN/features/property/data/models/property_sub_models.dart';
import 'package:MARN/features/property/domain/entities/property_edit_entity.dart';

class PropertyEditModel extends PropertyEditEntity {
  PropertyEditModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    required super.isShared,
    required super.maxOccupants,
    required super.bedrooms,
    required super.beds,
    required super.bathrooms,
    required super.rentalUnit,
    required super.address,
    required super.city,
    required super.governorate,
    required super.zipCode,
    required super.squareMeters,
    required super.latitude,
    required super.longitude,
    required super.price,
    super.isActive,
    super.primaryImageUrl,
    super.proofOfOwnershipUrl,
    super.media,
    super.rules,
    super.amenities,
    super.removedMediaIds,
    super.newPrimaryImage,
    super.addedMediaFiles,
    super.removedRuleIds,
    super.newProofOfOwnership,
    super.addedRuleTexts,
    super.removedAmenityIds,
    super.addedAmenities,
  });

  factory PropertyEditModel.fromJson(Map<String, dynamic> json) {
    return PropertyEditModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: EnumItem.resolve(EnumType.propertyTypes, json['type']),
      isShared: json['isShared'],
      maxOccupants: json['maxOccupants'],
      bedrooms: json['bedrooms'],
      beds: json['beds'],
      bathrooms: json['bathrooms'],
      rentalUnit: EnumItem.resolve(EnumType.rentalUnits, json['rentalUnit']),
      address: json['address'],
      city: EnumItem.resolve(EnumType.cities, json['city']),
      governorate: EnumItem.resolve(
        EnumType.governorates,
        json['governorate'],
      ),
      zipCode: json['zipCode'],
      squareMeters: json['squareMeters'],
      proofOfOwnershipUrl: buildImageUrl(json['proofOfOwnershipUrl']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      price: json['price'],
      primaryImageUrl: buildImageUrl(json['primaryImageUrl']),
      isActive: json['isActive'],
      media: json['media'] != null
          ? (json['media'] as List<dynamic>)
                .map(
                  (e) => PropertyMediaItemModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : null,
      rules: json['rules'] != null
          ? (json['rules'] as List<dynamic>)
                .map(
                  (e) =>
                      PropertyRuleItemModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : null,
      amenities: json['amenities'] != null
          ? (json['amenities'] as List<dynamic>)
                .map(
                  (e) => PropertyAmenityItemModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : null,
    );
  }
}
