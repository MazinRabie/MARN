import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/routes/routes.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/date_formatter.dart';
import 'package:MARN/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/sub_widgets/dashboard_section_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentsListSection<T> extends StatelessWidget {
  final String title;
  final List<T> payments;
  final bool isReceived;

  const PaymentsListSection({
    super.key,
    required this.title,
    required this.payments,
    required this.isReceived,
  });

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        DashboardSectionHeader(title: title),

        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final payment = payments[index];

            final num amount = isReceived
                ? (payment as ReceivedPaymentEntity).amountReceived
                : (payment as PaidPaymentEntity).amountPaid;

            final DateTime paidAt = isReceived
                ? (payment as ReceivedPaymentEntity).paidAt
                : (payment as PaidPaymentEntity).paidAt;

            final int contractId = isReceived
                ? (payment as ReceivedPaymentEntity).contractId
                : (payment as PaidPaymentEntity).contractId;

            final EnumItem? status = isReceived
                ? (payment as ReceivedPaymentEntity).status
                : null;

            final DateTime? availableAt = isReceived
                ? (payment as ReceivedPaymentEntity).availableAt
                : null;

            return CustomGeneralContainer(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,

                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.successContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isReceived ? Icons.arrow_downward : Icons.check,
                        color: AppColors.success,
                        size: 20,
                      ),
                    ),

                    title: Text(
                      LocaleKeys.dashboardReportsAmountEgp.tr(
                        namedArgs: {'amount': amount.toStringAsFixed(0)},
                      ),
                      style: AppTextStyles.titleMedium,
                    ),
                    subtitle: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      runAlignment: WrapAlignment.spaceEvenly,
                      children: [
                        Text(
                          isReceived
                              ? LocaleKeys.dashboardReportsReceivedOn.tr(
                                  namedArgs: {
                                    'date': DateFormatter.format(paidAt),
                                  },
                                )
                              : LocaleKeys.dashboardReportsPaidOn.tr(
                                  namedArgs: {
                                    'date': DateFormatter.format(paidAt),
                                  },
                                ),
                        ),

                        if (availableAt != null)
                          Text(
                            LocaleKeys.dashboardReportsAvailableOn.tr(
                              namedArgs: {
                                'date': DateFormatter.format(availableAt),
                              },
                            ),
                          ),
                      ],
                    ),

                    trailing: status != null
                        ? Text(
                            _getTranslatedStatus(status.name),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: _getPaymentStatusColor(status),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  CustomGeneralButton(
                    text: LocaleKeys.dashboardButtonsViewContract.tr(),
                    onPressed: () {
                      context.push(
                        AppRoutes.contractScreen,
                        extra: ContractScreenArguments(contractId: contractId),
                      );
                    },
                  ),
                ],
              ),
            );
          }, childCount: payments.length),
        ),
      ],
    );
  }

  String _getTranslatedStatus(String statusName) {
    switch (statusName.toLowerCase()) {
      case 'succeeded':
        return LocaleKeys.dashboardStatusSucceeded.tr();
      case 'pending':
        return LocaleKeys.dashboardStatusPending.tr();
      case 'failed':
        return LocaleKeys.dashboardStatusFailed.tr();
      case 'refunded':
        return LocaleKeys.dashboardStatusRefunded.tr();
      default:
        return statusName;
    }
  }

  Color _getPaymentStatusColor(EnumItem status) {
    switch (status.name.toLowerCase()) {
      case 'succeeded':
        return AppColors.success;
      case 'pending':
        return AppColors.pending;
      case 'failed':
        return AppColors.error;
      case 'refunded':
        return AppColors.grey;
      default:
        return AppColors.grey;
    }
  }
}
