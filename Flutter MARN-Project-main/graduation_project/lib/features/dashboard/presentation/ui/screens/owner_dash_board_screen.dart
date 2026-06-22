import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/app_bar_widget.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/features/dashboard/presentation/state_management/cubit/dashboard_cubit.dart';
import 'package:MARN/features/dashboard/presentation/ui/widgets/owner_dash_board_form.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/booking_contract_cubit.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/payment_cubit.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/payment_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnerDashBoardScreen extends StatefulWidget {
  const OwnerDashBoardScreen({super.key});

  @override
  State<OwnerDashBoardScreen> createState() => _OwnerDashBoardScreenState();
}

class _OwnerDashBoardScreenState extends State<OwnerDashBoardScreen> {
  void loadDashboard() {
    context.read<DashboardCubit>().getOwnerDashboardStats();
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
    return Scaffold(
      backgroundColor: AppColors.transparent,
      appBar: appBarWidget(context),
      body: MultiBlocListener(
        listeners: [
          BlocListener<DashboardCubit, DashboardState>(
            listener: (context, state) {
              if (state is OwnerDashboardFailure) {
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
              if (state is CreateContractSuccess ||
                  state is CancelContractSuccess) {
                loadDashboard();
              } else if (state is CreateContractFailure) {
                buildSnackBar(
                  context,
                  message: state.errorMessage,
                  isError: true,
                );
              } else if (state is CancelContractFailure) {
                buildSnackBar(
                  context,
                  message: state.errorMessage,
                  isError: true,
                );
              }
            },
          ),
          BlocListener<PaymentCubit, PaymentState>(
            listener: (context, state) async {
              if (state is PaymentLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              } else if (state is ConnectSuccess) {
                Navigator.of(context, rootNavigator: true).pop();
                final uri = Uri.parse(state.url);
                try {
                  final launched = await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                  if (!launched && context.mounted) {
                    buildSnackBar(
                      context,
                      message: LocaleKeys.dashboardStripeSetupLaunchError.tr(),
                      isError: true,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    buildSnackBar(
                      context,
                      message: LocaleKeys.dashboardStripeSetupError.tr(namedArgs: {'error': e.toString()}),
                      isError: true,
                    );
                  }
                }
              } else if (state is WithdrawSuccess) {
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
            return current is OwnerDashboardLoaded ||
                current is OwnerDashboardLoading ||
                current is OwnerDashboardFailure;
          },
          builder: (context, state) {
            if (state is OwnerDashboardLoaded) {
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  loadDashboard();
                },
                child: OwnerDashBoardForm(dashboardStats: state.dashboardStats),
              );
            }

            return buildLoading();
          },
        ),
      ),
    );
  }
}
