import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/widgets/status_badge_widget.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/date_formatter.dart';
import 'package:MARN/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/sub_widgets/dashboard_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/booking_contract_cubit.dart';
import 'package:MARN/core/routes/routes.dart';

class ContractsListSection<T> extends StatelessWidget {
  final String title;
  final List<T> contracts;
  final bool isOwner;

  const ContractsListSection({
    super.key,
    required this.title,
    required this.contracts,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    if (contracts.isEmpty) {
      return const SliverToBoxAdapter();
    }

    return SliverMainAxisGroup(
      slivers: [
        DashboardSectionHeader(title: title),

        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final contract = contracts[index];

            final contractStatus = isOwner
                ? (contract as OwnerContractCardEntity).contractStatus
                : (contract as RenterContractCardEntity).contractStatus;

            final propertyTitle = isOwner
                ? (contract as OwnerContractCardEntity).propertyTitle
                : (contract as RenterContractCardEntity).propertyTitle;

            final propertyId = isOwner
                ? (contract as OwnerContractCardEntity).propertyId
                : (contract as RenterContractCardEntity).propertyId;

            final expiryDate = isOwner
                ? (contract as OwnerContractCardEntity).expiryDate
                : (contract as RenterContractCardEntity).expiryDate;

            final contractId = isOwner
                ? (contract as OwnerContractCardEntity).contractId
                : (contract as RenterContractCardEntity).contractId;

            final userName = isOwner
                ? (contract as OwnerContractCardEntity).renterName
                : (contract as RenterContractCardEntity).ownerName;

            final userId = isOwner
                ? (contract as OwnerContractCardEntity).renterId
                : (contract as RenterContractCardEntity).ownerId;

            return CustomGeneralContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,

                    title: Row(
                      children: [
                        StatusBadgeWidget(status: contractStatus),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            propertyTitle,
                            style: AppTextStyles.titleMedium,
                          ),
                        ),

                        IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () {
                            context.push(
                              AppRoutes.viewPropertyDetailsScreen,
                              extra: ViewPropertyDetailsScreenArguments(
                                id: propertyId,
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 16,
                              color: AppColors.primary,
                            ),

                            const SizedBox(width: 4),

                            Expanded(
                              child: Text(
                                isOwner
                                    ? LocaleKeys.dashboardManagementRenterLabel
                                          .tr(namedArgs: {'name': userName})
                                    : LocaleKeys.dashboardManagementOwnerLabel
                                          .tr(namedArgs: {'name': userName}),
                              ),
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.chat,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              onPressed: () {
                                context.push(
                                  AppRoutes.chatScreen,
                                  extra: ChatScreenArguments(userId: userId),
                                );
                              },
                            ),
                          ],
                        ),

                        Text(
                          LocaleKeys.dashboardManagementExpiryDate.tr(
                            namedArgs: {
                              'date': DateFormatter.formatContract(expiryDate),
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (contractStatus.name.toLowerCase() == 'pending') ...[
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: CustomGeneralButton(
                            text: LocaleKeys.dashboardButtonsCancel.tr(),
                            onPressed: () {
                              context
                                  .read<BookingContractCubit>()
                                  .cancelContract(contractId: contractId);
                            },
                            backgroundColor: AppColors.surface,
                            borderColor: AppColors.primary,
                            textColor: AppColors.primary,
                          ),
                        ),
                        if (!isOwner) ...[
                          Expanded(
                            child: CustomGeneralButton(
                              text: LocaleKeys.dashboardButtonsSign.tr(),
                              onPressed: () {
                                context
                                    .read<BookingContractCubit>()
                                    .signContract(contractId: contractId);
                              },
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 8),
                  ],

                  CustomGeneralButton(
                    text: LocaleKeys.dashboardButtonsContractDetails.tr(),
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
          }, childCount: contracts.length),
        ),
      ],
    );
  }
}
