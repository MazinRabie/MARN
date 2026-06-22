import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/services/shared_preferences_helper.dart';
import 'package:MARN/features/property/data/models/property_sub_models.dart';
import 'package:MARN/features/property/domain/entities/property_view_entity.dart';

class PropertyViewModel extends PropertyViewEntity {
  PropertyViewModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    required super.maxOccupants,
    required super.isShared,
    required super.bedrooms,
    required super.beds,
    required super.bathrooms,
    required super.squareMeters,
    required super.viewsCount,
    required super.price,
    required super.rentalUnit,
    required super.address,
    required super.city,
    required super.governorate,
    required super.zipCode,
    required super.latitude,
    required super.longitude,
    required super.isActive,
    required super.availability,
    required super.createdAt,
    required super.isSaved,
    required super.averageRating,
    required super.ratingsCount,
    required super.commentsCount,
    super.currentUserRating,
    required super.isUserAllowedToFeedback,
    required super.amenities,
    required super.rules,
    required super.media,
    required super.comments,
    required super.currentUserBookingRequests,
    required super.activeRenters,
    required super.hostedBy,
    super.ownerExtras,
    required super.isPersonal,
  });

  factory PropertyViewModel.fromJson(Map<String, dynamic> json) {
    return PropertyViewModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: EnumItem.resolve(EnumType.propertyTypes, json['type']),
      maxOccupants: json['maxOccupants'] ?? 0,
      isShared: json['isShared'] ?? false,
      bedrooms: json['bedrooms'] ?? 0,
      beds: json['beds'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      squareMeters: json['squareMeters'] ?? 0,
      viewsCount: json['viewsCount'] ?? 0,
      price: json['price'] ?? 0,
      rentalUnit: EnumItem.resolve(EnumType.rentalUnits, json['rentalUnit']),
      address: json['address'] ?? '',
      city: EnumItem.resolve(EnumType.cities, json['city']),
      governorate: EnumItem.resolve(
        EnumType.governorates,
        json['governorate'],
      ),
      zipCode: json['zipCode'] ?? '',
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      isActive: json['isActive'] ?? false,
      availability: json['availability'] ?? false,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      isSaved: json['isSaved'] ?? false,
      averageRating: json['averageRating'] ?? 0.0,
      ratingsCount: json['ratingsCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      currentUserRating: json['currentUserRating'],
      isUserAllowedToFeedback: json['isUserAllowedToFeedback'] ?? false,
      amenities:
          (json['amenities'] as List<dynamic>?)
              ?.map((e) => PropertyAmenityItemModel.fromJson(e))
              .toList() ??
          [],
      rules:
          (json['rules'] as List<dynamic>?)
              ?.map((e) => PropertyRuleItemModel.fromJson(e))
              .toList() ??
          [],
      media:
          (json['media'] as List<dynamic>?)
              ?.map((e) => PropertyMediaItemModel.fromJson(e))
              .toList() ??
          [],
      comments:
          (json['comments'] as List<dynamic>?)
              ?.map((e) => PropertyCommentDetailsModel.fromJson(e))
              .toList() ??
          [],
      currentUserBookingRequests:
          (json['currentUserBookingRequests'] as List<dynamic>?)
              ?.map((e) => PropertyBookingRequestModel.fromJson(e))
              .toList() ??
          [],
      activeRenters:
          (json['activeRenters'] as List<dynamic>?)
              ?.map((e) => ActiveRenterModel.fromJson(e))
              .toList() ??
          [],
      hostedBy: PropertyHostedByModel.fromJson(json['hostedBy'] ?? {}),
      ownerExtras: json['ownerExtras'] != null
          ? OwnerPropertyExtrasModel.fromJson(json['ownerExtras'])
          : null,
      isPersonal:
          json['hostedBy']?['id'] ==
          SharedPreferencesHelper.getString(LocalStorageVariables.userId),
    );
  }
}
