import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/widgets/buildImage_url.dart';
import 'package:MARN/features/property/domain/entities/card/viewer_property_card_entity.dart';

class ViewerPropertyCardModel extends ViewerPropertyCardEntity {
  ViewerPropertyCardModel({
    required super.id,
    required super.imagePath,
    required super.title,
    required super.address,
    required super.bedrooms,
    required super.bathrooms,
    required super.maxOccupants,
    required super.type,
    required super.averageRating,
    required super.ratings,
    required super.price,
    required super.rentalUnit,
    required super.isSaved,
  });

  factory ViewerPropertyCardModel.fromJson(Map<String, dynamic> json) {
    return ViewerPropertyCardModel(
      id: json['id'],
      imagePath: buildImageUrl(json['imagePath']) ?? "",
      title: json['title'],
      address: json['address'],
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
      maxOccupants: json['maxOccupants'],
      type: EnumItem.resolve(EnumType.propertyTypes, json['type']),
      averageRating: json['averageRating'],
      ratings: json['ratings'],
      price: json['price'],
      rentalUnit: EnumItem.resolve(EnumType.rentalUnits, json['rentalUnit']),
      isSaved: json['isSaved'],
    );
  }
}
