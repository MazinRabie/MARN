import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:MARN/features/property/domain/entities/card/base_property_card.dart';

class OwnerPropertyCardEntity implements BasePropertyCard {
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

  final EnumItem status;
  final int occupiedPlaces;
  final int totalPlaces;
  final int views;
  bool isActive;
  final List<OwnerPropertyContractEntity>? activeContracts;

  OwnerPropertyCardEntity({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.address,
    required this.type,
    required this.views,
    required this.isSaved,
    required this.occupiedPlaces,
    required this.totalPlaces,
    required this.price,
    required this.rentalUnit,
    required this.averageRating,
    required this.ratings,
    required this.status,
    required this.activeContracts,
    required this.isActive,
  });
}
