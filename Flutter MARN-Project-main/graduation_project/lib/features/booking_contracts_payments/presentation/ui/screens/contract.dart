import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/app_bar_widget.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/features/booking_contracts_payments/domain/entities/contract_entity.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/ui/widgets/contract_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/booking_contract_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class ContractScreen extends StatefulWidget {
  final int contractId;
  const ContractScreen({super.key, required this.contractId});

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  ContractDetailsEntity? contract;

  @override
  void initState() {
    super.initState();
    context.read<BookingContractCubit>().getContract(
      contractId: widget.contractId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      appBar: appBarWidget(context),
      body: BlocConsumer<BookingContractCubit, BookingContractState>(
        listener: (context, state) {
          if (state is GetContractSuccess) {
            setState(() {
              contract = state.contract;
            });
          }
          if (state is GetContractFailure) {
            buildSnackBar(context, message: state.errorMessage, isError: true);
          }
          if (state is GetContractPdfSuccess) {
            buildSnackBar(
              context,
              message: LocaleKeys.contractsStatusPdfDownloadSuccess.tr(),
              isError: false,
            );
          }
          if (state is GetContractPdfFailure) {
            buildSnackBar(context, message: state.errorMessage, isError: true);
          }
          if (state is GetContractProofSuccess) {
            buildSnackBar(
              context,
              message: LocaleKeys.contractsStatusProofDownloadSuccess.tr(),
              isError: false,
            );
          }
          if (state is GetContractProofFailure) {
            buildSnackBar(context, message: state.errorMessage, isError: true);
          }
          if (state is VerifyContractSuccess) {
            final matchStr = state.contract.match
                ? LocaleKeys.contractsStatusMatched.tr()
                : LocaleKeys.contractsStatusNotMatched.tr();
            final statusStr = state.contract.status.displayName.isNotEmpty
                ? state.contract.status.displayName
                : state.contract.status.name;
            buildSnackBar(
              context,
              message: LocaleKeys.contractsDialogsVerificationResult.tr(namedArgs: {
                "match": matchStr,
                "status": statusStr,
                "message": state.contract.message,
              }),
              isError: !state.contract.match,
            );
          }
          if (state is VerifyContractFailure) {
            buildSnackBar(context, message: state.errorMessage, isError: true);
          }
        },
        builder: (context, state) {
          if (contract == null) {
            return buildLoading();
          }

          final isLoadingOverlay = state is GetContractPdfLoading ||
              state is GetContractProofLoading ||
              state is VerifyContractLoading;

          return Stack(
            children: [
              ContractViewWidget(contract: contract!),
              if (isLoadingOverlay)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: buildLoading(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
