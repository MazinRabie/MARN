import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:MARN/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:MARN/core/widgets/date_formatter.dart';

List<Widget> buildRenterStatCards(RenterDashboardEntity dashboardStats) {
  List<Widget> cards = [];

  if (dashboardStats.nextPayment != null) {
    cards.add(
      StatCard(
        title: LocaleKeys.dashboardStatisticsNextPaymentRent.tr(),
        value: LocaleKeys.dashboardReportsAmountEgp.tr(namedArgs: {'amount': dashboardStats.nextPayment!.amount.toStringAsFixed(0)}),
        subtitle:
            LocaleKeys.dashboardReportsDue.tr(namedArgs: {'date': DateFormatter.format(dashboardStats.nextPayment!.date)}),
        icon: Icons.credit_card,
        color: AppColors.primary,
        width: 200,
      ),
    );
  }

  if (dashboardStats.activeRentalsCount != null) {
    cards.add(
      StatCard(
        title: LocaleKeys.dashboardStatisticsActiveRentals.tr(),
        value: dashboardStats.activeRentalsCount.toString(),
        icon: Icons.home_outlined,
        color: AppColors.primary,
        width: 160,
      ),
    );
  }

  if (dashboardStats.savedPropertiesCount != null) {
    cards.add(
      StatCard(
        title: LocaleKeys.dashboardStatisticsSavedProperties.tr(),
        value: dashboardStats.savedPropertiesCount.toString(),
        icon: Icons.favorite_border,
        color: AppColors.secondary,
        width: 160,
      ),
    );
  }

  return cards;
}

List<Widget> buildOwnerStatCards(OwnerDashboardEntity dashboardStats) {
  List<Widget> cards = [];

  cards.add(
    StatCard(
      title: LocaleKeys.dashboardStatisticsTotalRevenue.tr(),
      value:
          LocaleKeys.dashboardReportsAmountEgp.tr(namedArgs: {'amount': dashboardStats.withdrawableEarnings?.toStringAsFixed(0) ?? '0'}),
      subtitle:
          LocaleKeys.dashboardStatisticsOnHoldAmount.tr(namedArgs: {'amount': dashboardStats.onHoldEarnings?.toStringAsFixed(0) ?? '0'}),
      icon: Icons.account_balance_wallet_outlined,
      color: AppColors.success,
      width: 200,
    ),
  );
  cards.add(
    StatCard(
      title: LocaleKeys.dashboardStatisticsMyProperties.tr(),
      value: dashboardStats.propertiesCount?.toString() ?? '0',
      subtitle: LocaleKeys.dashboardStatisticsOccupied.tr(namedArgs: {'count': (dashboardStats.occupiedPlaces ?? 0).toString()}),
      icon: Icons.home_work_outlined,
      color: AppColors.primary,
      width: 170,
    ),
  );
  cards.add(
    StatCard(
      title: LocaleKeys.dashboardStatisticsPendingRequests.tr(),
      value: dashboardStats.pendingBookingRequestsCount?.toString() ?? '0',
      icon: Icons.pending_actions_outlined,
      color: AppColors.warning,
      width: 180,
    ),
  );
  cards.add(
    StatCard(
      title: LocaleKeys.dashboardStatisticsTotalViews.tr(),
      value: dashboardStats.totalViews?.toString() ?? '0',
      icon: Icons.visibility_outlined,
      color: AppColors.secondary,
      width: 160,
    ),
  );

  return cards;
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final double? width;

  const StatCard({
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 160,
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: AppColors.shadow,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: color, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textTertiary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
