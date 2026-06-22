import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/routes/routes.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/date_formatter.dart';
import 'package:MARN/core/widgets/image_card_widget.dart';
import 'package:MARN/core/widgets/status_badge_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:MARN/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/payment_cubit.dart';

class ActiveRentalCard extends StatelessWidget {
  final ActiveRentalCardEntity rental;

  const ActiveRentalCard({super.key, required this.rental});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dueDate = rental.nextPaymentScheduleDate;
    final canPay =
        rental.nextPaymentScheduleId != null &&
        (dueDate == null ||
            dueDate.difference(now).inHours <= 168); // 7 days = 168 hours

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomGeneralContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (rental.propertyImageUrl.isNotEmpty)
                  ImageCardWidget(
                    imagePath: rental.propertyImageUrl,
                    width: 100,
                    height: 100,
                  )
                else
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.home),
                  ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rental.propertyTitle,
                        style: AppTextStyles.titleMedium,
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: AppColors.textTertiary,
                          ),

                          const SizedBox(width: 4),

                          Expanded(
                            child: Text(
                              rental.propertyAddress,
                              style: AppTextStyles.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      StatusBadgeWidget(status: rental.contractStatus),
                    ],
                  ),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1, color: AppColors.divider),
            ),

            // DATES
            Row(
              children: [
                Expanded(
                  child: _RentalInfoItem(
                    label: LocaleKeys.propertyBookingStartDate.tr(),
                    value: DateFormatter.format(rental.startDate),
                  ),
                ),

                Expanded(
                  child: _RentalInfoItem(
                    label: LocaleKeys.propertyBookingEndDate.tr(),
                    value: DateFormatter.format(rental.endDate),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // PAYMENT INFO
            Row(
              children: [
                Expanded(
                  child: _RentalInfoItem(
                    label: LocaleKeys.dashboardManagementPaymentFrequencyLabel.tr(),
                    value: rental.paymentFrequency.displayName.isNotEmpty
                    ? rental.paymentFrequency.displayName
                    : rental.paymentFrequency.name,
                  ),
                ),

                Expanded(
                  child: _RentalInfoItem(
                    label: LocaleKeys.dashboardManagementNextPayment.tr(),
                    value: rental.nextPaymentScheduleDate != null
                        ? DateFormatter.format(rental.nextPaymentScheduleDate!)
                        : LocaleKeys.dashboardManagementNoSchedule.tr(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // PAYMENT STATUS
            _RentalInfoItem(
              label: LocaleKeys.dashboardManagementPaymentStatusLabel.tr(),
              value: rental.nextPaymentScheduleStatus != null
                  ? (rental.nextPaymentScheduleStatus!.displayName.isNotEmpty
                      ? rental.nextPaymentScheduleStatus!.displayName
                      : rental.nextPaymentScheduleStatus!.name)
                  : LocaleKeys.dashboardManagementUnknown.tr(),
            ),

            const SizedBox(height: 20),

            // ACTIONS
            Row(
              children: [
                Expanded(
                  child: CustomGeneralButton(
                    text: LocaleKeys.dashboardManagementContract.tr(),
                    icon: Icons.description,
                    onPressed: () {
                      context.push(
                        AppRoutes.contractScreen,
                        extra: ContractScreenArguments(
                          contractId: rental.contractId,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomGeneralButton(
                    text: LocaleKeys.dashboardManagementPayment.tr(),
                    icon: Icons.payment,
                    onPressed: canPay
                        ? () {
                            context.read<PaymentCubit>().paySchedule(
                              paymentScheduleId: rental.nextPaymentScheduleId!,
                            );
                          }
                        : null,
                  ),
                ),
              ],
            ),
            if (rental.nextPaymentScheduleId != null &&
                !canPay &&
                dueDate != null) ...[
              const SizedBox(height: 8),
              Center(
                child: Text(
                  LocaleKeys.dashboardManagementPaymentOnlyAvailableSevenDays.tr(
                    namedArgs: {'date': DateFormatter.format(dueDate.subtract(const Duration(days: 7)))},
                  ),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 16),
            CustomGeneralButton(
              text: LocaleKeys.dashboardManagementChatWithOwner.tr(),
              icon: Icons.chat,
              onPressed: () {
                context.push(
                  AppRoutes.chatScreen,
                  extra: ChatScreenArguments(userId: rental.ownerId),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RentalInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _RentalInfoItem({required this.label, required this.value});

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

        const SizedBox(height: 4),

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
