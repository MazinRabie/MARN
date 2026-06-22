import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/routes/routes.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/profile_image_widget.dart';
import 'package:MARN/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/booking_contract_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:go_router/go_router.dart';

class BookingRequestCard extends StatefulWidget {
  final dynamic request;

  const BookingRequestCard({super.key, required this.request});

  @override
  State<BookingRequestCard> createState() => _BookingRequestCardState();
}

class _BookingRequestCardState extends State<BookingRequestCard> {
  OwnerPendingBookingRequestEntity? ownerRequest;
  RenterPendingBookingRequestEntity? renterRequest;
  bool isDeleted = false;

  String? _displayName(EnumItem? item) {
    if (item == null) return null;
    return item.displayName.isNotEmpty ? item.displayName : item.name;
  }

  @override
  void initState() {
    super.initState();

    if (widget.request is OwnerPendingBookingRequestEntity) {
      ownerRequest = widget.request;
    }

    if (widget.request is RenterPendingBookingRequestEntity) {
      renterRequest = widget.request;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isDeleted) {
      return const SizedBox.shrink();
    }
    return CustomGeneralContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProfileImageWidget(
                imagePath:
                    ownerRequest?.renterProfileImage ??
                    renterRequest?.ownerProfileImage,
                radius: 30,
              ),
              const SizedBox(width: 8),
              Text(
                ownerRequest?.renterName ?? renterRequest!.ownerName,
                style: AppTextStyles.titleMedium,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.message, color: AppColors.primary),
                onPressed: () {
                  context.read<BookingContractCubit>().startChat(
                    bookingId:
                        ownerRequest?.bookingRequestId ??
                        renterRequest!.bookingRequestId,
                    chatUserId:
                        ownerRequest?.renterId ?? renterRequest!.ownerId,
                  );
                },
              ),
            ],
          ),
          Text(
            ownerRequest?.propertyTitle ?? renterRequest!.propertyTitle,
            style: AppTextStyles.bodyLarge,
          ),
          Text(
            LocaleKeys.dashboardManagementPaymentFrequency.tr(
              namedArgs: {
                'frequency':
                    _displayName(ownerRequest?.paymentFrequency) ??
                    _displayName(renterRequest?.paymentFrequency) ??
                    '',
              },
            ),
          ),
          Text(
            LocaleKeys.dashboardManagementDatesRange.tr(
              namedArgs: {
                'start':
                    ownerRequest?.startDate.toString().split(' ')[0] ??
                    renterRequest!.startDate.toString().split(' ')[0],
                'end':
                    ownerRequest?.endDate.toString().split(' ')[0] ??
                    renterRequest!.endDate.toString().split(' ')[0],
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomGeneralButton(
                  text: LocaleKeys.dashboardButtonsShowProperty.tr(),
                  onPressed: () {
                    context.push(
                      AppRoutes.viewPropertyDetailsScreen,
                      extra: ViewPropertyDetailsScreenArguments(
                        id:
                            ownerRequest?.propertyId ??
                            renterRequest!.propertyId,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              CustomGeneralButton(
                onPressed: () async {
                  await context.read<BookingContractCubit>().cancelBooking(
                    bookingId:
                        ownerRequest?.bookingRequestId ??
                        renterRequest!.bookingRequestId,
                  );

                  setState(() {
                    isDeleted = true;
                  });
                },
                text: ownerRequest != null
                    ? LocaleKeys.dashboardButtonsDecline.tr()
                    : LocaleKeys.dashboardButtonsCancel.tr(),
                backgroundColor: AppColors.surface,
                borderColor: AppColors.primary,
                textColor: AppColors.primary,
                isWidthLessThanDefault: true,
              ),
            ],
          ),

          if (ownerRequest != null) ...[
            const SizedBox(height: 16),
            CustomGeneralButton(
              onPressed: () async {
                await context.read<BookingContractCubit>().createContract(
                  bookingRequestId: ownerRequest!.bookingRequestId,
                );
                setState(() {
                  isDeleted = true;
                });
              },
              text: LocaleKeys.dashboardButtonsAccept.tr(),
            ),
          ],
        ],
      ),
    );
  }
}
