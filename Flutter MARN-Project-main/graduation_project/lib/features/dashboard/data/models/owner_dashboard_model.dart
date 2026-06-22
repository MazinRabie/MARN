import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/features/dashboard/data/models/dashboard_sub_models.dart';
import 'package:MARN/features/dashboard/domain/entities/dashboard_entity.dart';

class OwnerDashboardModel extends OwnerDashboardEntity {
  OwnerDashboardModel({
    super.propertiesCount,
    super.occupiedPlaces,
    super.vacantPlaces,
    super.totalViews,
    super.monthlyEarning,
    super.yearlyEarning,
    super.withdrawableEarnings,
    super.onHoldEarnings,
    super.averageRating,
    super.ratingsCount,
    super.ownerAllContracts,
    super.pendingBookingRequestsCount,
    super.ownerPendingBookingRequests,
    super.accountStatus,
    super.receivedPayments,
    super.stripeAccountEnabled,
  });

  factory OwnerDashboardModel.fromJson(Map<String, dynamic> json) {
    return OwnerDashboardModel(
      propertiesCount: json['propertiesCount'],
      occupiedPlaces: json['occupiedPlaces'],
      vacantPlaces: json['vacantPlaces'],
      totalViews: json['totalViews'],
      monthlyEarning: json['monthlyEarning'] != null
          ? (json['monthlyEarning'] as List)
                .map((e) => MonthlyEarningModel.fromJson(e))
                .toList()
          : null,
      yearlyEarning: json['yearlyEarning'] != null
          ? (json['yearlyEarning'] as List)
                .map((e) => YearlyEarningModel.fromJson(e))
                .toList()
          : null,
      withdrawableEarnings: json['withdrawableEarnings'],
      onHoldEarnings: json['onHoldEarnings'],
      averageRating: json['averageRating'],
      ratingsCount: json['ratingsCount'],
      ownerAllContracts: json['allContracts'] != null
          ? (json['allContracts'] as List)
                .map((e) => OwnerContractCardModel.fromJson(e))
                .toList()
          : null,
      pendingBookingRequestsCount: json['pendingBookingRequestsCount'],
      ownerPendingBookingRequests: json['pendingBookingRequests'] != null
          ? (json['pendingBookingRequests'] as List)
                .map((e) => OwnerPendingBookingRequestModel.fromJson(e))
                .toList()
          : null,
      accountStatus: json['accountStatus'] != null
          ? EnumItem.resolve(EnumType.accountStatuses, json['accountStatus'])
          : null,
      receivedPayments: json['receivedPayments'] != null
          ? (json['receivedPayments'] as List)
                .map((e) => ReceivedPaymentModel.fromJson(e))
                .toList()
          : null,
      stripeAccountEnabled: json['stripeAccountEnabled'],
    );
  }
}
