import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/payment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnerDetailsSection extends StatelessWidget {
  final OwnerDashboardEntity dashboardStats;

  const OwnerDetailsSection({super.key, required this.dashboardStats});

  @override
  Widget build(BuildContext context) {
    final stripeEnabled = dashboardStats.stripeAccountEnabled == true;
    final withdrawable = dashboardStats.withdrawableEarnings ?? 0.0;
    final onHold = dashboardStats.onHoldEarnings ?? 0.0;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
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
              Text(
                LocaleKeys.dashboardManagementOwnerProfileStripe.tr(),
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _OwnerInfoItem(
                    label: LocaleKeys.dashboardManagementVacantPlaces.tr(),
                    value: dashboardStats.vacantPlaces?.toString() ?? '0',
                  ),
                  _OwnerInfoItem(
                    label: LocaleKeys.dashboardManagementRating.tr(),
                    value:
                        '${dashboardStats.averageRating?.toStringAsFixed(1) ?? '0.0'} (${dashboardStats.ratingsCount ?? 0})',
                  ),
                  _OwnerInfoItem(
                    label: LocaleKeys.dashboardManagementStripeLinked.tr(),
                    value: stripeEnabled
                        ? LocaleKeys.dashboardStatusYes.tr()
                        : LocaleKeys.dashboardStatusNo.tr(),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, color: AppColors.divider),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.dashboardManagementWithdrawableEarnings
                              .tr(),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          LocaleKeys.dashboardReportsAmountEgp.tr(
                            namedArgs: {
                              'amount': withdrawable.toStringAsFixed(2),
                            },
                          ),
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.dashboardManagementOnHoldEarnings.tr(),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          LocaleKeys.dashboardReportsAmountEgp.tr(
                            namedArgs: {'amount': onHold.toStringAsFixed(2)},
                          ),
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.warning,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (stripeEnabled) ...[
                CustomGeneralButton(
                  text: LocaleKeys.dashboardButtonsWithdrawEarnings.tr(),
                  icon: Icons.account_balance_wallet,
                  onPressed: withdrawable > 0
                      ? () {
                          context.read<PaymentCubit>().withdrawEarnings();
                        }
                      : null, // Disabled if there's nothing to withdraw
                ),
              ] else ...[
                CustomGeneralButton(
                  text: LocaleKeys.dashboardButtonsSetupStripe.tr(),
                  icon: Icons.payment,
                  onPressed: () {
                    context.read<PaymentCubit>().connectStripeAccount();
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _OwnerInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _OwnerInfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
