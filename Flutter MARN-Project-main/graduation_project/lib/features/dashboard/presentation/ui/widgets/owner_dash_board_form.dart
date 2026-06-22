import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/sub_widgets/booking_requests_section.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/sub_widgets/contracts_list_section.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/sub_widgets/dashboard_general_info.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/sub_widgets/earning_section.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/sub_widgets/financial_list_section.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/sub_widgets/owner_details_section.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/sub_widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:MARN/core/widgets/top_bounce_only_scroll_physics.dart';

class OwnerDashBoardForm extends StatelessWidget {
  final OwnerDashboardEntity dashboardStats;
  const OwnerDashBoardForm({super.key, required this.dashboardStats});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const TopBounceOnlyScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(LocaleKeys.dashboardOwnerDashboard.tr(), style: AppTextStyles.titleLarge),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              spacing: 12,
              children: buildOwnerStatCards(dashboardStats),
            ),
          ),
        ),

        DashboardGeneralInfo(accountStatus: dashboardStats.accountStatus),

        OwnerDetailsSection(dashboardStats: dashboardStats),

        SliverToBoxAdapter(
          child: EarningSection(
            monthlyEarning: dashboardStats.monthlyEarning ?? [],
            yearlyEarning: dashboardStats.yearlyEarning ?? [],
          ),
        ),

        BookingRequestsSection(
          ownerPendingRequests: dashboardStats.ownerPendingBookingRequests,
        ),

        ContractsListSection(
          title: LocaleKeys.dashboardMyContractsAsOwner.tr(),
          contracts: dashboardStats.ownerAllContracts ?? [],
          isOwner: true,
        ),

        if (dashboardStats.receivedPayments != null &&
            dashboardStats.receivedPayments!.isNotEmpty)
          PaymentsListSection<ReceivedPaymentEntity>(
            title: LocaleKeys.dashboardRecentReceivedPayments.tr(),
            payments: dashboardStats.receivedPayments!,
            isReceived: true,
          ),

        const SliverPadding(padding: EdgeInsets.only(bottom: 70)),
      ],
    );
  }
}
