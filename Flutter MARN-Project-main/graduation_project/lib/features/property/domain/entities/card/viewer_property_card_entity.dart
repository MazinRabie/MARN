import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/features/property/domain/entities/card/base_property_card.dart';

class ViewerPropertyCardEntity implements BasePropertyCard {
  @override
  final int id;
  @override
  String imagePath;
  @override
  final String title;
  @override
  final String address;
  @override
  final EnumItem type;
  @override
  final num price;
  @override
  final EnumItem rentalUnit;
  @override
  final num averageRating;
  @override
  final int ratings;
  @override
  bool isSaved;

  final int bedrooms;
  final int bathrooms;
  final int maxOccupants;

  ViewerPropertyCardEntity({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.address,
    required this.bedrooms,
    required this.bathrooms,
    required this.maxOccupants,
    required this.type,
    required this.averageRating,
    required this.ratings,
    required this.price,
    required this.rentalUnit,
    required this.isSaved,
  });
}
