import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/widgets/buildImage_url.dart';
import 'package:MARN/features/dashboard/domain/entities/dashboard_entity.dart';

class RenterNextPaymentModel extends RenterNextPaymentEntity {
  RenterNextPaymentModel({
    required super.date,
    required super.amount,
    required super.propertyId,
    required super.propertyTitle,
  });

  factory RenterNextPaymentModel.fromJson(Map<String, dynamic> json) {
    return RenterNextPaymentModel(
      date: DateTime.parse(json['date']),
      amount: json['amount'],
      propertyId: json['propertyId'],
      propertyTitle: json['propertyTitle'] ?? '',
    );
  }
}

class ActiveRentalCardModel extends ActiveRentalCardEntity {
  ActiveRentalCardModel({
    required super.contractId,
    required super.contractStatus,
    required super.startDate,
    required super.endDate,
    required super.propertyTitle,
    required super.propertyAddress,
    required super.propertyImageUrl,
    required super.paymentFrequency,
    super.nextPaymentScheduleDate,
    super.nextPaymentScheduleId,
    super.nextPaymentScheduleStatus,
    required super.ownerId,
  });

  factory ActiveRentalCardModel.fromJson(Map<String, dynamic> json) {
    return ActiveRentalCardModel(
      contractId: json['contractId'],
      contractStatus: EnumItem.resolve(EnumType.contractStatuses, json['contractStatus']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      propertyTitle: json['propertyTitle'] ?? '',
      propertyAddress: json['propertyAddress'] ?? '',
      propertyImageUrl: buildImageUrl(json['propertyImageUrl']) ?? '',
      paymentFrequency: EnumItem.resolve(EnumType.paymentFrequencies, json['paymentFrequency']),
      nextPaymentScheduleDate: json['nextPaymentScheduleDate'] != null
          ? DateTime.parse(json['nextPaymentScheduleDate'])
          : null,
      nextPaymentScheduleId: json['nextPaymentScheduleId'],
      nextPaymentScheduleStatus: json['nextPaymentScheduleStatus'] != null
          ? EnumItem.resolve(EnumType.paymentScheduleStatuses, json['nextPaymentScheduleStatus'])
          : null,
      ownerId: json['ownerId'].toString(),
    );
  }
}

class MonthlyEarningModel extends MonthlyEarningEntity {
  MonthlyEarningModel({
    required super.year,
    required super.month,
    required super.total,
  });

  factory MonthlyEarningModel.fromJson(Map<String, dynamic> json) {
    return MonthlyEarningModel(
      year: json['year'],
      month: json['month'],
      total: json['total'],
    );
  }
}

class YearlyEarningModel extends YearlyEarningEntity {
  YearlyEarningModel({required super.year, required super.total});

  factory YearlyEarningModel.fromJson(Map<String, dynamic> json) {
    return YearlyEarningModel(year: json['year'], total: json['total']);
  }
}

class OwnerContractCardModel extends OwnerContractCardEntity {
  OwnerContractCardModel({
    required super.contractId,
    required super.contractStatus,
    required super.expiryDate,
    required super.renterId,
    required super.renterName,
    required super.propertyId,
    required super.propertyTitle,
  });

  factory OwnerContractCardModel.fromJson(Map<String, dynamic> json) {
    return OwnerContractCardModel(
      contractId: json['contractId'],
      contractStatus: EnumItem.resolve(EnumType.contractStatuses, json['contractStatus']),
      expiryDate: DateTime.parse(json['expiryDate']),
      renterId: json['renterId'],
      renterName: json['renterName'],
      propertyId: json['propertyId'],
      propertyTitle: json['propertyTitle'],
    );
  }
}

class RenterContractCardModel extends RenterContractCardEntity {
  RenterContractCardModel({
    required super.contractId,
    required super.contractStatus,
    required super.expiryDate,
    required super.ownerId,
    required super.ownerName,
    required super.propertyId,
    required super.propertyTitle,
  });

  factory RenterContractCardModel.fromJson(Map<String, dynamic> json) {
    return RenterContractCardModel(
      contractId: json['contractId'],
      contractStatus: EnumItem.resolve(EnumType.contractStatuses, json['contractStatus']),
      expiryDate: DateTime.parse(json['expiryDate']),
      ownerId: json['ownerId'],
      ownerName: json['ownerName'],
      propertyId: json['propertyId'],
      propertyTitle: json['propertyTitle'],
    );
  }
}

class OwnerPendingBookingRequestModel extends OwnerPendingBookingRequestEntity {
  OwnerPendingBookingRequestModel({
    required super.bookingRequestId,
    required super.startDate,
    required super.endDate,
    required super.paymentFrequency,
    required super.propertyId,
    required super.propertyTitle,
    required super.renterId,
    required super.renterName,
    super.renterProfileImage,
  });

  factory OwnerPendingBookingRequestModel.fromJson(Map<String, dynamic> json) {
    return OwnerPendingBookingRequestModel(
      bookingRequestId: json['bookingRequestId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      paymentFrequency: EnumItem.resolve(EnumType.paymentFrequencies, json['paymentFrequency']),
      propertyId: json['propertyId'],
      propertyTitle: json['propertyTitle'],
      renterId: json['renterId'],
      renterName: json['renterName'],
      renterProfileImage: buildImageUrl(json['renterProfileImage']),
    );
  }
}

class RenterPendingBookingRequestModel
    extends RenterPendingBookingRequestEntity {
  RenterPendingBookingRequestModel({
    required super.bookingRequestId,
    required super.startDate,
    required super.endDate,
    required super.paymentFrequency,
    required super.propertyId,
    required super.propertyTitle,
    required super.ownerId,
    required super.ownerName,
    super.ownerProfileImage,
  });

  factory RenterPendingBookingRequestModel.fromJson(Map<String, dynamic> json) {
    return RenterPendingBookingRequestModel(
      bookingRequestId: json['bookingRequestId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      paymentFrequency: EnumItem.resolve(EnumType.paymentFrequencies, json['paymentFrequency']),
      propertyId: json['propertyId'],
      propertyTitle: json['propertyTitle'] ?? '',
      ownerId: json['ownerId'].toString(),
      ownerName: json['ownerName'] ?? '',
      ownerProfileImage: buildImageUrl(json['ownerProfileImage']),
    );
  }
}

class PaidPaymentModel extends PaidPaymentEntity {
  PaidPaymentModel({
    required super.amountPaid,
    required super.contractId,
    required super.paidAt,
  });

  factory PaidPaymentModel.fromJson(Map<String, dynamic> json) {
    return PaidPaymentModel(
      amountPaid: json['amountPaid'],
      contractId: json['contractId'],
      paidAt: DateTime.parse(json['paidAt']),
    );
  }
}

class ReceivedPaymentModel extends ReceivedPaymentEntity {
  ReceivedPaymentModel({
    required super.amountReceived,
    required super.contractId,
    required super.paidAt,
    required super.availableAt,
    required super.status,
  });

  factory ReceivedPaymentModel.fromJson(Map<String, dynamic> json) {
    return ReceivedPaymentModel(
      amountReceived: json['amountReceived'],
      contractId: json['contractId'],
      paidAt: DateTime.parse(json['paidAt']),
      availableAt: DateTime.parse(json['availableAt']),
      status: EnumItem.resolve(EnumType.paymentStatuses, json['status']),
    );
  }
}

class OwnerPropertyContractModel extends OwnerPropertyContractEntity {
  OwnerPropertyContractModel({
    required super.contractId,
    required super.renterId,
    required super.renterName,
    super.renterProfileImage,
  });

  factory OwnerPropertyContractModel.fromJson(Map<String, dynamic> json) {
    return OwnerPropertyContractModel(
      contractId: json['contractId'],
      renterId: json['renterId'].toString(),
      renterName: json['renterName'] ?? '',
      renterProfileImage: buildImageUrl(json['renterProfileImage']),
    );
  }
}
