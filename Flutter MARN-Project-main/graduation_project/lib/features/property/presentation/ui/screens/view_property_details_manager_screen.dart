import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/booking_contract_cubit.dart';
import 'package:MARN/features/property/presentation/state_management/cubit/property_cubit.dart';
import 'package:MARN/features/property/presentation/ui/screens/view_property_details_screen.dart';
import 'package:MARN/features/static_screens/presentation/screens/error404_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewPropertyDetailsManagerScreen extends StatefulWidget {
  final int id;

  const ViewPropertyDetailsManagerScreen({super.key, required this.id});

  @override
  State<ViewPropertyDetailsManagerScreen> createState() =>
      _ViewPropertyDetailsManagerScreenState();
}

class _ViewPropertyDetailsManagerScreenState
    extends State<ViewPropertyDetailsManagerScreen> {
  void getPropertyDetails() {
    context.read<PropertyCubit>().getPropertyDetails(propertyId: widget.id);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPropertyDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BookingContractCubit, BookingContractState>(
          listener: (context, state) {
            if (state is CreateBookingSuccess ||
                state is CreateContractSuccess ||
                state is CancelContractSuccess) {
              getPropertyDetails();
            } else if (state is CreateContractFailure) {
              buildSnackBar(context, message: state.errorMessage, isError: true);
            } else if (state is CancelContractFailure) {
              buildSnackBar(context, message: state.errorMessage, isError: true);
            }
          },
        ),

        BlocListener<PropertyCubit, PropertyState>(
          listener: (context, state) {
            if (state is PropertyGetPropertyDetailsFailure) {
              buildSnackBar(
                context,
                message: state.errorMessage,
                isError: true,
              );
            }
          },
        ),
      ],

      child: BlocBuilder<PropertyCubit, PropertyState>(
        buildWhen: (previous, current) {
          return current is PropertyGetPropertyDetailsLoading ||
              current is PropertyGetPropertyDetailsSuccess ||
              current is PropertyGetPropertyDetailsFailure;
        },
        builder: (context, state) {
          if (state is PropertyGetPropertyDetailsSuccess) {
            return ViewPropertyDetailsScreen(property: state.property);
          }

          if (state is PropertyGetPropertyDetailsFailure) {
            return Error404Screen();
          }

          return buildLoading();
        },
      ),
    );
  }
}
