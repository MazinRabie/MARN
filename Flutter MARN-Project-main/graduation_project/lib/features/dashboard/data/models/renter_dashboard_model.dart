import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/features/dashboard/data/models/dashboard_sub_models.dart';
import 'package:MARN/features/dashboard/domain/entities/dashboard_entity.dart';

class RenterDashboardModel extends RenterDashboardEntity {
  RenterDashboardModel({
    super.activeRentalsCount,
    super.savedPropertiesCount,
    super.nextPayment,
    super.accountStatus,
    super.activeRentals,
    super.renterPendingBookingRequests,
    super.renterAllContracts,
    super.paidPayments,
  });

  factory RenterDashboardModel.fromJson(Map<String, dynamic> json) {
    return RenterDashboardModel(
      activeRentalsCount: json['activeRentalsCount'],
      savedPropertiesCount: json['savedPropertiesCount'],
      nextPayment: json['nextPayment'] != null
          ? RenterNextPaymentModel.fromJson(json['nextPayment'])
          : null,
      accountStatus: json['accountStatus'] != null
          ? EnumItem.resolve(EnumType.accountStatuses, json['accountStatus'])
          : null,
      activeRentals: json['activeRentals'] != null
          ? (json['activeRentals'] as List)
                .map((e) => ActiveRentalCardModel.fromJson(e))
                .toList()
          : null,
      renterPendingBookingRequests: json['pendingBookingRequests'] != null
          ? (json['pendingBookingRequests'] as List)
                .map((e) => RenterPendingBookingRequestModel.fromJson(e))
                .toList()
          : null,
      renterAllContracts: json['allContracts'] != null
          ? (json['allContracts'] as List)
                .map((e) => RenterContractCardModel.fromJson(e))
                .toList()
          : null,
      paidPayments: json['paidPayments'] != null
          ? (json['paidPayments'] as List)
                .map((e) => PaidPaymentModel.fromJson(e))
                .toList()
          : null,
    );
  }
}
