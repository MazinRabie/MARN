import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/core/widgets/build_toster.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/enum_select_field.dart.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/booking_contract_cubit.dart';
import 'package:MARN/features/property/presentation/ui/widgets/smart_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingBottomSheet extends StatefulWidget {
  final int propertyId;
  final num price;
  final EnumItem rentalUnit;

  const BookingBottomSheet({
    super.key,
    required this.propertyId,
    required this.price,
    required this.rentalUnit,
  });

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? startDate;
  String? endDate;
  EnumItem? paymentFrequency;
  List<String>? get _allowedPaymentFrequencies {
    switch (widget.rentalUnit.name.toLowerCase()) {
      case 'daily':
        return ['onetime'];
      case 'monthly':
        return ['onetime', 'monthly'];
      case 'yearly':
        return ['onetime', 'monthly', 'quarterly', 'yearly'];
      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    paymentFrequency = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingContractCubit, BookingContractState>(
      listener: (context, state) {
        if (state is CreateBookingSuccess) {
          Navigator.pop(context);
          buildToster(context, message: state.message);
        } else if (state is CreateBookingFailure) {
          Navigator.pop(context);
          buildSnackBar(context, message: state.errorMessage, isError: true);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            CustomGeneralContainer(
              margin: EdgeInsets.zero,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          LocaleKeys.propertyBookingPriceEgp.tr(
                            namedArgs: {'price': widget.price.toString()},
                          ),
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.rentalUnit.displayName,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SmartRangePicker(
                      rentalUnit: widget.rentalUnit,
                      startRequiredMessage: LocaleKeys
                          .propertyBookingStartRequired
                          .tr(),
                      endRequiredMessage: LocaleKeys.propertyBookingEndRequired
                          .tr(),
                      onChanged: ({required start, required end}) {
                        startDate = start;
                        endDate = end;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      LocaleKeys.propertyBookingSelectPaymentFrequency.tr(),
                      textAlign: TextAlign.start,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FormField<EnumItem>(
                      initialValue: paymentFrequency,
                      validator: (val) {
                        if (val == null || val == EnumItem.empty) {
                          return LocaleKeys
                              .propertyBookingSelectPaymentFrequency
                              .tr();
                        }
                        return null;
                      },
                      builder: (FormFieldState<EnumItem> state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EnumSelectField(
                              enumType: EnumType.paymentFrequencies,
                              initialValue: paymentFrequency,
                              filter: (item) {
                                final allowed = _allowedPaymentFrequencies;
                                if (allowed == null) return true;
                                return allowed.contains(
                                  item.name.toLowerCase(),
                                );
                              },
                              onChanged: (val) {
                                setState(() {
                                  paymentFrequency = val;
                                });
                                state.didChange(val);
                              },
                            ),
                            if (state.hasError) ...[
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12.0,
                                  right: 12.0,
                                ),
                                child: Text(
                                  state.errorText!,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    CustomGeneralButton(
                      text: state is CreateBookingLoading
                          ? LocaleKeys.propertyBookingStatusBooking.tr()
                          : LocaleKeys.propertyBookingConfirmBooking.tr(),
                      isLoading: state is CreateBookingLoading,
                      onPressed: state is CreateBookingLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                context.read<BookingContractCubit>().addBooking(
                                  propertyId: widget.propertyId,
                                  checkInDate: startDate!,
                                  checkOutDate: endDate!,
                                  paymentFrequency: paymentFrequency!,
                                );
                              }
                            },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
