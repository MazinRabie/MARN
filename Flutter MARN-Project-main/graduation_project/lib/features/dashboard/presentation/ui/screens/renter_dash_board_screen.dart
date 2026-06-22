import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/features/dashboard/presentation/state_management/cubit/dashboard_cubit.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/renter_dash_board_form.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/booking_contract_cubit.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/payment_cubit.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RenterDashBoardScreen extends StatefulWidget {
  const RenterDashBoardScreen({super.key});

  @override
  State<RenterDashBoardScreen> createState() => _RenterDashBoardScreenState();
}

class _RenterDashBoardScreenState extends State<RenterDashBoardScreen> {
  void loadDashboard() {
    context.read<DashboardCubit>().getRenterDashboardStats();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DashboardCubit, DashboardState>(
          listener: (context, state) {
            if (state is RenterDashboardFailure) {
              buildSnackBar(
                context,
                message: state.errorMessage,
                isError: true,
              );
            }
          },
        ),
        BlocListener<BookingContractCubit, BookingContractState>(
          listener: (context, state) {
            if (state is CancelContractSuccess ||
                state is SignContractSuccess) {
              loadDashboard();
            } else if (state is CancelContractFailure) {
              buildSnackBar(
                context,
                message: state.errorMessage,
                isError: true,
              );
            } else if (state is SignContractFailure) {
              buildSnackBar(
                context,
                message: state.errorMessage,
                isError: true,
              );
            }
          },
        ),
        BlocListener<PaymentCubit, PaymentState>(
          listener: (context, state) {
            if (state is PaymentLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            } else if (state is PaymentSuccess) {
              Navigator.of(context, rootNavigator: true).pop();
              buildSnackBar(context, message: state.message, isError: false);
              loadDashboard();
            } else if (state is PaymentFailure) {
              Navigator.of(context, rootNavigator: true).pop();
              buildSnackBar(
                context,
                message: state.errorMessage,
                isError: true,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<DashboardCubit, DashboardState>(
        buildWhen: (previous, current) {
          return current is RenterDashboardLoaded ||
              current is RenterDashboardLoading ||
              current is RenterDashboardFailure;
        },
        builder: (context, state) {
          if (state is RenterDashboardLoaded) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                loadDashboard();
              },
              child: RenterDashBoardForm(dashboardStats: state.dashboardStats),
            );
          }

          return buildLoading();
        },
      ),
    );
  }
}
