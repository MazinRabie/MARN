import 'package:MARN/core/enums/models/enum_item.dart';

class RenterDashboardEntity {
  int? activeRentalsCount;
  int? savedPropertiesCount;
  RenterNextPaymentEntity? nextPayment;
  EnumItem? accountStatus;
  List<ActiveRentalCardEntity>? activeRentals;
  List<RenterPendingBookingRequestEntity>? renterPendingBookingRequests;
  List<RenterContractCardEntity>? renterAllContracts;
  List<PaidPaymentEntity>? paidPayments;

  RenterDashboardEntity({
    this.activeRentalsCount,
    this.savedPropertiesCount,
    this.nextPayment,
    this.accountStatus,
    this.activeRentals,
    this.renterPendingBookingRequests,
    this.renterAllContracts,
    this.paidPayments,
  });
}

class OwnerDashboardEntity {
  int? propertiesCount;
  int? occupiedPlaces;
  int? vacantPlaces;
  int? totalViews;
  List<MonthlyEarningEntity>? monthlyEarning;
  List<YearlyEarningEntity>? yearlyEarning;
  num? withdrawableEarnings;
  num? onHoldEarnings;
  num? averageRating;
  int? ratingsCount;
  List<OwnerContractCardEntity>? ownerAllContracts;
  int? pendingBookingRequestsCount;
  List<OwnerPendingBookingRequestEntity>? ownerPendingBookingRequests;
  List<ReceivedPaymentEntity>? receivedPayments;
  bool? stripeAccountEnabled;
  EnumItem? accountStatus;

  OwnerDashboardEntity({
    this.propertiesCount,
    this.occupiedPlaces,
    this.vacantPlaces,
    this.totalViews,
    this.monthlyEarning,
    this.yearlyEarning,
    this.withdrawableEarnings,
    this.onHoldEarnings,
    this.averageRating,
    this.ratingsCount,
    this.ownerAllContracts,
    this.pendingBookingRequestsCount,
    this.ownerPendingBookingRequests,
    this.receivedPayments,
    this.stripeAccountEnabled,
    this.accountStatus,
  });
}

class RenterNextPaymentEntity {
  final DateTime date;
  final num amount;
  final int propertyId;
  final String propertyTitle;

  RenterNextPaymentEntity({
    required this.date,
    required this.amount,
    required this.propertyId,
    required this.propertyTitle,
  });
}

class ActiveRentalCardEntity {
  final int contractId;
  final EnumItem contractStatus;
  final DateTime startDate;
  final DateTime endDate;
  final String propertyTitle;
  final String propertyAddress;
  final String propertyImageUrl;
  final EnumItem paymentFrequency;
  final DateTime? nextPaymentScheduleDate;
  final int? nextPaymentScheduleId;
  final EnumItem? nextPaymentScheduleStatus;
  final String ownerId;

  ActiveRentalCardEntity({
    required this.contractId,
    required this.contractStatus,
    required this.startDate,
    required this.endDate,
    required this.propertyTitle,
    required this.propertyAddress,
    required this.propertyImageUrl,
    required this.paymentFrequency,
    this.nextPaymentScheduleDate,
    this.nextPaymentScheduleId,
    this.nextPaymentScheduleStatus,
    required this.ownerId,
  });
}

class MonthlyEarningEntity {
  final int year;
  final int month;
  final num total;

  MonthlyEarningEntity({
    required this.year,
    required this.month,
    required this.total,
  });
}

class YearlyEarningEntity {
  final int year;
  final num total;

  YearlyEarningEntity({required this.year, required this.total});
}

class OwnerContractCardEntity {
  final int contractId;
  final EnumItem contractStatus;
  final DateTime expiryDate;
  final String renterId;
  final String renterName;
  final int propertyId;
  final String propertyTitle;

  OwnerContractCardEntity({
    required this.contractId,
    required this.contractStatus,
    required this.expiryDate,
    required this.renterId,
    required this.renterName,
    required this.propertyId,
    required this.propertyTitle,
  });
}

class RenterContractCardEntity {
  final int contractId;
  final EnumItem contractStatus;
  final DateTime expiryDate;
  final String ownerId;
  final String ownerName;
  final int propertyId;
  final String propertyTitle;

  RenterContractCardEntity({
    required this.contractId,
    required this.contractStatus,
    required this.expiryDate,
    required this.ownerId,
    required this.ownerName,
    required this.propertyId,
    required this.propertyTitle,
  });
}

class OwnerPendingBookingRequestEntity {
  final int bookingRequestId;
  final DateTime startDate;
  final DateTime endDate;
  final EnumItem paymentFrequency;
  final int propertyId;
  final String propertyTitle;
  final String renterId;
  final String renterName;
  final String? renterProfileImage;

  OwnerPendingBookingRequestEntity({
    required this.bookingRequestId,
    required this.startDate,
    required this.endDate,
    required this.paymentFrequency,
    required this.propertyId,
    required this.propertyTitle,
    required this.renterId,
    required this.renterName,
    this.renterProfileImage,
  });
}

class RenterPendingBookingRequestEntity {
  final int bookingRequestId;
  final DateTime startDate;
  final DateTime endDate;
  final EnumItem paymentFrequency;
  final int propertyId;
  final String propertyTitle;
  final String ownerId;
  final String ownerName;
  final String? ownerProfileImage;

  RenterPendingBookingRequestEntity({
    required this.bookingRequestId,
    required this.startDate,
    required this.endDate,
    required this.paymentFrequency,
    required this.propertyId,
    required this.propertyTitle,
    required this.ownerId,
    required this.ownerName,
    this.ownerProfileImage,
  });
}

class PaidPaymentEntity {
  final num amountPaid;
  final int contractId;
  final DateTime paidAt;
  

  PaidPaymentEntity({
    required this.amountPaid,
    required this.contractId,
    required this.paidAt,
    
  });
}

class ReceivedPaymentEntity {
  final num amountReceived;
  final int contractId;
  final DateTime paidAt;
  final DateTime availableAt;
  final EnumItem status;

  ReceivedPaymentEntity({
    required this.amountReceived,
    required this.contractId,
    required this.paidAt,
    required this.availableAt,
    required this.status,
  });
}

class OwnerPropertyContractEntity {
  final int contractId;
  final String renterId;
  final String renterName;
  final String? renterProfileImage;

  OwnerPropertyContractEntity({
    required this.contractId,
    required this.renterId,
    required this.renterName,
    this.renterProfileImage,
  });
}
