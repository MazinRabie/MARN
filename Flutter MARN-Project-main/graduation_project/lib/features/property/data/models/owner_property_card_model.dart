import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/widgets/buildImage_url.dart';
import 'package:MARN/features/dashboard/data/models/dashboard_sub_models.dart';
import 'package:MARN/features/property/domain/entities/card/owner_property_card_entity.dart';

class OwnerPropertyCardModel extends OwnerPropertyCardEntity {
  OwnerPropertyCardModel({
    required super.id,
    required super.imagePath,
    required super.title,
    required super.address,
    required super.type,
    required super.views,
    required super.isSaved,
    required super.occupiedPlaces,
    required super.totalPlaces,
    required super.price,
    required super.rentalUnit,
    required super.averageRating,
    required super.ratings,
    required super.isActive,
    required super.status,
    super.activeContracts,
  });

  factory OwnerPropertyCardModel.fromJson(Map<String, dynamic> json) {
    return OwnerPropertyCardModel(
      id: json['id'],
      imagePath: buildImageUrl(json['imagePath'])!,
      title: json['title'],
      address: json['address'],
      type: EnumItem.resolve(EnumType.propertyTypes, json['type']),
      views: json['views'],
      isSaved: json['isSaved'],
      occupiedPlaces: json['occupiedPlaces'],
      totalPlaces: json['totalPlaces'],
      price: json['price'],
      rentalUnit: EnumItem.resolve(EnumType.rentalUnits, json['rentalUnit']),
      averageRating: json['averageRating'],
      ratings: json['ratings'],
      isActive: json['isActive'],
      status: EnumItem.resolve(EnumType.propertyStatuses, json['status']),
      activeContracts: json['activeContracts'] != null
          ? (json['activeContracts'] as List)
                .map((e) => OwnerPropertyContractModel.fromJson(e))
                .toList()
          : null,
    );
  }
}
