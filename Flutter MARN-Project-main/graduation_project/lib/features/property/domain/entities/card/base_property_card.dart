import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/features/property/domain/entities/card/owner_property_card_entity.dart';
import 'package:MARN/features/property/domain/entities/card/viewer_property_card_entity.dart';

abstract class BasePropertyCard {
  int get id;
  String get imagePath;
  String get title;
  String get address;
  EnumItem get type;
  num get price;
  EnumItem get rentalUnit;
  num get averageRating;
  int get ratings;
  bool isSaved;

  BasePropertyCard({required this.isSaved});
}

extension BasePropertyCardX on BasePropertyCard {
  // owner in this case means the person who is the owner
  bool get isOwner => this is OwnerPropertyCardEntity;

  OwnerPropertyCardEntity? get asOwner =>
      this is OwnerPropertyCardEntity ? this as OwnerPropertyCardEntity : null;

  // viewer in this case means the person who is not the owner
  bool get isViewer => this is ViewerPropertyCardEntity;

  ViewerPropertyCardEntity? get asViewer => this is ViewerPropertyCardEntity
      ? this as ViewerPropertyCardEntity
      : null;
}
