import 'package:MARN/core/enums/models/enum_item.dart';

abstract class ActiveRenterEntity {
  String id;
  String name;
  String? profilePhoto;
  num? matchingPercentage;

  ActiveRenterEntity({
    required this.id,
    required this.name,
    this.profilePhoto,
    this.matchingPercentage,
  });
}

abstract class PropertyAmenityItemEntity {
  int id;
  EnumItem amenity;

  PropertyAmenityItemEntity({required this.id, required this.amenity});
}

abstract class PropertyRuleItemEntity {
  int id;
  String text;

  PropertyRuleItemEntity({required this.id, required this.text});
}

abstract class PropertyMediaItemEntity {
  int id;
  String path;
  bool isPrimary;

  PropertyMediaItemEntity({
    required this.id,
    required this.path,
    required this.isPrimary,
  });
}

abstract class PropertyHostedByEntity {
  String id;
  String fullName;
  String? profileImage;
  num averageRating;
  int propertiesCount;
  String? bio;

  PropertyHostedByEntity({
    required this.id,
    required this.fullName,
    this.profileImage,
    required this.averageRating,
    required this.propertiesCount,
    this.bio,
  });
}

abstract class PropertyCommentDetailsEntity {
  int commentId;
  String commenterId;
  String commenterFullName;
  String? commenterProfileImage;
  DateTime createdAt;
  int? rating;
  String content;
  PropertyCommentStayInfoEntity stayInfo;

  PropertyCommentDetailsEntity({
    required this.commentId,
    required this.commenterId,
    required this.commenterFullName,
    this.commenterProfileImage,
    required this.createdAt,
    this.rating,
    required this.content,
    required this.stayInfo,
  });
}

abstract class PropertyCommentStayInfoEntity {
  DateTime? checkIn;
  DateTime? checkOut;
  bool isContractActive;

  PropertyCommentStayInfoEntity({
    this.checkIn,
    this.checkOut,
    required this.isContractActive,
  });
}

abstract class PropertyBookingRequestEntity {
  int bookingRequestId;
  DateTime startDate;
  DateTime endDate;
  EnumItem paymentFrequency;

  PropertyBookingRequestEntity({
    required this.bookingRequestId,
    required this.startDate,
    required this.endDate,
    required this.paymentFrequency,
  });
}

abstract class OwnerPropertyExtrasEntity {
  EnumItem? propertyStatus;
  List<OwnerPropertyContractHistoryEntity> contractsHistory;
  List<OwnerPropertyPendingBookingRequestEntity> pendingBookingRequests;

  OwnerPropertyExtrasEntity({
    this.propertyStatus,
    required this.contractsHistory,
    required this.pendingBookingRequests,
  });
}

abstract class OwnerPropertyContractHistoryEntity {
  int contractId;
  EnumItem contractStatus;
  DateTime expiryDate;
  String renterId;
  String renterName;

  OwnerPropertyContractHistoryEntity({
    required this.contractId,
    required this.contractStatus,
    required this.expiryDate,
    required this.renterId,
    required this.renterName,
  });
}

abstract class OwnerPropertyPendingBookingRequestEntity {
  int bookingRequestId;
  DateTime startDate;
  DateTime endDate;
  EnumItem paymentFrequency;
  String renterId;
  String renterName;
  String? renterProfileImage;

  OwnerPropertyPendingBookingRequestEntity({
    required this.bookingRequestId,
    required this.startDate,
    required this.endDate,
    required this.paymentFrequency,
    required this.renterId,
    required this.renterName,
    this.renterProfileImage,
  });
}
