import 'package:MARN/core/routes/app_routes.dart' show AppRoutes;
import 'package:MARN/core/routes/routes.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/widgets/profile_image_widget.dart';
import 'package:MARN/core/widgets/status_badge_widget.dart';
import 'package:MARN/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:MARN/features/property/domain/entities/card/owner_property_card_entity.dart';
import 'package:MARN/features/property/presentation/state_management/cubit/property_cubit.dart';
import 'package:MARN/features/property/presentation/ui/widgets/property_card_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OwnerPropertyCard extends StatelessWidget {
  final OwnerPropertyCardEntity property;
  final int index;
  const OwnerPropertyCard({
    super.key,
    required this.property,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PropertyCubit>().state;

    bool isActive = property.isActive;
    if (state is PropertyToggleActiveSuccess) {
      isActive = state.isActive;
    }

    return PropertyCardLayout(
      property: property,
      statusChip: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 2,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.successContainer
                  : AppColors.errorContainer,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              isActive ? LocaleKeys.propertyStatusActive.tr() : LocaleKeys.propertyStatusInactive.tr(),
              style: TextStyle(
                color: isActive ? AppColors.onSuccess : AppColors.error,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          StatusBadgeWidget(
            status: property.status,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            borderRadius: 100,
          ),
        ],
      ),
      extraInfoRow: [
        PropertyCardInfoItem(
          title: LocaleKeys.propertyCardViewsLabel.tr(),
          value: property.views.toString(),
          icon: Icons.remove_red_eye_outlined,
        ),
      ],
      bottomInfoRow: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.people_outline,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              LocaleKeys.propertyCardOccupied.tr(
                namedArgs: {
                  'occupied': property.occupiedPlaces.toString(),
                  'total': property.totalPlaces.toString(),
                },
              ),
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (property.activeContracts != null &&
            property.activeContracts!.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 4),
                Text(
                  LocaleKeys.propertyCardActiveContracts.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                ...property.activeContracts!.map((contract) {
                  return _propertyContracts(context, contract);
                }).toList(),
              ],
            ),
          ),
      ],
      extraActions: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              context.push(
                AppRoutes.editPropertyManageScreen,
                extra: EditPropertyScreenArguments(
                  id: property.id,
                  index: index,
                ),
              );
            },
            child: Text(LocaleKeys.propertyButtonsEdit.tr()),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _propertyContracts(
    BuildContext context,
    OwnerPropertyContractEntity contract,
  ) {
    return CustomGeneralContainer(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          ProfileImageWidget(
            radius: 20,
            imagePath: contract.renterProfileImage,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              contract.renterName,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                icon: const Icon(Icons.description_outlined, size: 20),
                color: AppColors.primary,
                onPressed: () {
                  context.push(
                    AppRoutes.contractScreen,
                    extra: ContractScreenArguments(
                      contractId: contract.contractId,
                    ),
                  );
                },
              ),
              IconButton(
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                icon: const Icon(Icons.arrow_forward_outlined, size: 20),
                onPressed: () {
                  context.push(
                    AppRoutes.profileScreen,
                    extra: ProfileScreenArguments(userId: contract.renterId),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
