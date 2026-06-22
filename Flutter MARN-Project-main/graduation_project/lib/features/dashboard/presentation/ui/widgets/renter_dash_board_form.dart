import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/sub_widgets/active_bookings_list.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/sub_widgets/booking_requests_section.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/sub_widgets/contracts_list_section.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/sub_widgets/dashboard_general_info.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/sub_widgets/dashboard_section_header.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/sub_widgets/financial_list_section.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/sub_widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:MARN/core/widgets/top_bounce_only_scroll_physics.dart';

class RenterDashBoardForm extends StatelessWidget {
  final RenterDashboardEntity dashboardStats;
  const RenterDashBoardForm({super.key, required this.dashboardStats});

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
              children: [Text(LocaleKeys.dashboardMyDashboard.tr(), style: AppTextStyles.titleLarge)],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              spacing: 12,
              children: buildRenterStatCards(dashboardStats),
            ),
          ),
        ),

        DashboardGeneralInfo(accountStatus: dashboardStats.accountStatus),

        if (dashboardStats.activeRentals != null &&
            dashboardStats.activeRentals!.isNotEmpty) ...[
          DashboardSectionHeader(title: LocaleKeys.dashboardActiveRentals.tr()),
          ActiveRentalsList(activeRentals: dashboardStats.activeRentals),
        ],

        BookingRequestsSection(
          renterPendingRequests: dashboardStats.renterPendingBookingRequests,
        ),

        ContractsListSection(
          title: LocaleKeys.dashboardMyContractsAsRenter.tr(),
          contracts: dashboardStats.renterAllContracts ?? [],
          isOwner: false,
        ),

        if (dashboardStats.paidPayments != null &&
            dashboardStats.paidPayments!.isNotEmpty)
          PaymentsListSection<PaidPaymentEntity>(
            title: LocaleKeys.dashboardRecentPaidPayments.tr(),
            payments: dashboardStats.paidPayments!,
            isReceived: false,
          ),

        const SliverPadding(padding: EdgeInsets.only(bottom: 70)),
      ],
    );
  }
}
