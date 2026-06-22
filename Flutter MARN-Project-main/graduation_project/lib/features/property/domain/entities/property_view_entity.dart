import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/features/property/domain/entities/property_sub_entities.dart';

abstract class PropertyViewEntity {
  int id;
  String title;
  String description;
  EnumItem type;
  int maxOccupants;
  bool isShared;
  int bedrooms;
  int beds;
  int bathrooms;
  num squareMeters;
  int viewsCount;
  num price;
  EnumItem rentalUnit;
  String address;
  EnumItem city;
  EnumItem governorate;
  String zipCode;
  num latitude;
  num longitude;
  bool isActive;
  bool availability;
  DateTime createdAt;
  bool isSaved;

  num averageRating;
  int ratingsCount;
  int commentsCount;
  int? currentUserRating;
  bool isUserAllowedToFeedback;

  List<PropertyAmenityItemEntity> amenities;
  List<PropertyRuleItemEntity> rules;
  List<PropertyMediaItemEntity> media;
  List<PropertyCommentDetailsEntity> comments;
  List<PropertyBookingRequestEntity> currentUserBookingRequests;
  List<ActiveRenterEntity> activeRenters;

  PropertyHostedByEntity hostedBy;
  OwnerPropertyExtrasEntity? ownerExtras;
  bool isPersonal;

  PropertyViewEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.maxOccupants,
    required this.isShared,
    required this.bedrooms,
    required this.beds,
    required this.bathrooms,
    required this.squareMeters,
    required this.viewsCount,
    required this.price,
    required this.rentalUnit,
    required this.address,
    required this.city,
    required this.governorate,
    required this.zipCode,
    required this.latitude,
    required this.longitude,
    required this.isActive,
    required this.availability,
    required this.createdAt,
    required this.isSaved,
    required this.averageRating,
    required this.ratingsCount,
    required this.commentsCount,
    this.currentUserRating,
    required this.isUserAllowedToFeedback,
    required this.amenities,
    required this.rules,
    required this.media,
    required this.comments,
    required this.currentUserBookingRequests,
    required this.activeRenters,
    required this.hostedBy,
    this.ownerExtras,
    required this.isPersonal,
  });
}
