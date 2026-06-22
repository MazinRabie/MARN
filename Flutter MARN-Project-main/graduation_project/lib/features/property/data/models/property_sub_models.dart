import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/widgets/buildImage_url.dart';
import 'package:MARN/features/property/domain/entities/property_sub_entities.dart';

class ActiveRenterModel extends ActiveRenterEntity {
  ActiveRenterModel({
    required super.id,
    required super.name,
    super.profilePhoto,
    super.matchingPercentage,
  });

  factory ActiveRenterModel.fromJson(Map<String, dynamic> json) {
    return ActiveRenterModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      profilePhoto: buildImageUrl(json['profilePhoto']),
      matchingPercentage: json['matchingPercentage'],
    );
  }
}

class PropertyAmenityItemModel extends PropertyAmenityItemEntity {
  PropertyAmenityItemModel({required super.id, required super.amenity});

  factory PropertyAmenityItemModel.fromJson(Map<String, dynamic> json) {
    return PropertyAmenityItemModel(
      id: json['id'] ?? 0,
      amenity: EnumItem.resolve(EnumType.amenityTypes, json['amenity']),
    );
  }
}

class PropertyRuleItemModel extends PropertyRuleItemEntity {
  PropertyRuleItemModel({required super.id, required super.text});

  factory PropertyRuleItemModel.fromJson(Map<String, dynamic> json) {
    return PropertyRuleItemModel(
      id: json['id'] ?? 0,
      text: json['text'] ?? json['rule'] ?? '',
    );
  }
}

class PropertyMediaItemModel extends PropertyMediaItemEntity {
  PropertyMediaItemModel({
    required super.id,
    required super.path,
    required super.isPrimary,
  });

  factory PropertyMediaItemModel.fromJson(Map<String, dynamic> json) {
    return PropertyMediaItemModel(
      id: json['id'] ?? 0,
      path: buildImageUrl(json['path']) ?? '',
      isPrimary: json['isPrimary'] ?? false,
    );
  }
}

class PropertyHostedByModel extends PropertyHostedByEntity {
  PropertyHostedByModel({
    required super.id,
    required super.fullName,
    super.profileImage,
    required super.averageRating,
    required super.propertiesCount,
    super.bio,
  });

  factory PropertyHostedByModel.fromJson(Map<String, dynamic> json) {
    return PropertyHostedByModel(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName'] ?? '',
      profileImage: buildImageUrl(json['profileImage']),
      averageRating: json['averageRating'] ?? 0,
      propertiesCount: json['propertiesCount'] ?? 0,
      bio: json['bio'],
    );
  }
}

class PropertyCommentDetailsModel extends PropertyCommentDetailsEntity {
  PropertyCommentDetailsModel({
    required super.commentId,
    required super.commenterId,
    required super.commenterFullName,
    super.commenterProfileImage,
    required super.createdAt,
    super.rating,
    required super.content,
    required super.stayInfo,
  });

  factory PropertyCommentDetailsModel.fromJson(Map<String, dynamic> json) {
    return PropertyCommentDetailsModel(
      commentId: json['commentId'] ?? 0,
      commenterId: json['commenterId']?.toString() ?? '',
      commenterFullName: json['commenterFullName'] ?? '',
      commenterProfileImage: buildImageUrl(json['commenterProfileImage']),
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      rating: json['rating'],
      content: json['content'] ?? '',
      stayInfo: PropertyCommentStayInfoModel.fromJson(json['stayInfo'] ?? {}),
    );
  }
}

class PropertyCommentStayInfoModel extends PropertyCommentStayInfoEntity {
  PropertyCommentStayInfoModel({
    super.checkIn,
    super.checkOut,
    required super.isContractActive,
  });

  factory PropertyCommentStayInfoModel.fromJson(Map<String, dynamic> json) {
    return PropertyCommentStayInfoModel(
      checkIn: DateTime.tryParse(json['checkIn']?.toString() ?? ''),
      checkOut: DateTime.tryParse(json['checkOut']?.toString() ?? ''),
      isContractActive: json['isContractActive'] ?? false,
    );
  }
}

class PropertyBookingRequestModel extends PropertyBookingRequestEntity {
  PropertyBookingRequestModel({
    required super.bookingRequestId,
    required super.startDate,
    required super.endDate,
    required super.paymentFrequency,
  });

  factory PropertyBookingRequestModel.fromJson(Map<String, dynamic> json) {
    return PropertyBookingRequestModel(
      bookingRequestId: json['bookingRequestId'] ?? 0,
      startDate:
          DateTime.tryParse(json['startDate']?.toString() ?? '') ??
          DateTime.now(),
      endDate:
          DateTime.tryParse(json['endDate']?.toString() ?? '') ??
          DateTime.now(),
      paymentFrequency: EnumItem.resolve(EnumType.paymentFrequencies, json['paymentFrequency']),
    );
  }
}

class OwnerPropertyExtrasModel extends OwnerPropertyExtrasEntity {
  OwnerPropertyExtrasModel({
    super.propertyStatus,
    required super.contractsHistory,
    required super.pendingBookingRequests,
  });

  factory OwnerPropertyExtrasModel.fromJson(Map<String, dynamic> json) {
    return OwnerPropertyExtrasModel(
      propertyStatus: json['propertyStatus'] != null 
          ? EnumItem.resolve(EnumType.propertyStatuses, json['propertyStatus'])
          : null,
      contractsHistory:
          (json['contractsHistory'] as List<dynamic>?)
              ?.map((e) => OwnerPropertyContractHistoryModel.fromJson(e))
              .toList() ??
          [],
      pendingBookingRequests:
          (json['pendingBookingRequests'] as List<dynamic>?)
              ?.map((e) => OwnerPropertyPendingBookingRequestModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class OwnerPropertyContractHistoryModel
    extends OwnerPropertyContractHistoryEntity {
  OwnerPropertyContractHistoryModel({
    required super.contractId,
    required super.contractStatus,
    required super.expiryDate,
    required super.renterId,
    required super.renterName,
  });

  factory OwnerPropertyContractHistoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OwnerPropertyContractHistoryModel(
      contractId: json['contractId'] ?? 0,
      contractStatus: EnumItem.resolve(EnumType.contractStatuses, json['contractStatus']),
      expiryDate:
          DateTime.tryParse(json['expiryDate']?.toString() ?? '') ??
          DateTime.now(),
      renterId: json['renterId']?.toString() ?? '',
      renterName: json['renterName'] ?? '',
    );
  }
}

class OwnerPropertyPendingBookingRequestModel
    extends OwnerPropertyPendingBookingRequestEntity {
  OwnerPropertyPendingBookingRequestModel({
    required super.bookingRequestId,
    required super.startDate,
    required super.endDate,
    required super.paymentFrequency,
    required super.renterId,
    required super.renterName,
    super.renterProfileImage,
  });

  factory OwnerPropertyPendingBookingRequestModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OwnerPropertyPendingBookingRequestModel(
      bookingRequestId: json['bookingRequestId'] ?? 0,
      startDate:
          DateTime.tryParse(json['startDate']?.toString() ?? '') ??
          DateTime.now(),
      endDate:
          DateTime.tryParse(json['endDate']?.toString() ?? '') ??
          DateTime.now(),
      paymentFrequency: EnumItem.resolve(EnumType.paymentFrequencies, json['paymentFrequency']),
      renterId: json['renterId']?.toString() ?? '',
      renterName: json['renterName'] ?? '',
      renterProfileImage: buildImageUrl(json['renterProfileImage']),
    );
  }
}
