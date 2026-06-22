import 'dart:io';
import 'package:flutter/services.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/date_formatter.dart';
import 'package:MARN/core/widgets/status_badge_widget.dart';
import 'package:MARN/features/booking_contracts_payments/domain/entities/contract_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/booking_contract_cubit.dart';
import 'package:file_picker/file_picker.dart' as fp;
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class ContractViewWidget extends StatefulWidget {
  final ContractDetailsEntity contract;

  const ContractViewWidget({super.key, required this.contract});

  @override
  State<ContractViewWidget> createState() => _ContractViewWidgetState();
}

class _ContractViewWidgetState extends State<ContractViewWidget> {
  File? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          LocaleKeys.contractsPlaceholdersInstructions.tr(),
          style: AppTextStyles.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        _buildContractStatus(),
        const SizedBox(height: 16),
        _buildContractDetails(context),
        const SizedBox(height: 16),
        _buildBlockchainInfo(),
        const SizedBox(height: 16),
        _buildDownloadPdfContract(context),
        const SizedBox(height: 16),
        _buildDownloadProofContract(context),
        const SizedBox(height: 16),
        _buildUploadContract(context),
        const SizedBox(height: 16),
        _buildImportantNotes(),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildContractStatus() {
    return CustomGeneralContainer(
      margin: EdgeInsets.zero,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.description, color: AppColors.warning),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.contractsStatusTitle.tr(),
                style: AppTextStyles.titleMedium,
              ),
              Text(
                LocaleKeys.contractsStatusAwaitingSignatures.tr(),
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
          const Spacer(),
          StatusBadgeWidget(status: widget.contract.contractStatus),
        ],
      ),
    );
  }

  Widget _buildContractDetails(BuildContext context) {
    return CustomGeneralContainer(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.contractsPlaceholdersDetailsTitle.tr(),
            style: AppTextStyles.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.contractsPlaceholdersIdLabel.tr(),
                      style: AppTextStyles.labelSmall,
                    ),
                    Text(
                      widget.contract.contractId.toString(),
                      style: AppTextStyles.titleSmall,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.contractsPlaceholdersDurationLabel.tr(),
                      style: AppTextStyles.labelSmall,
                    ),
                    Text(
                      widget.contract.duration,
                      style: AppTextStyles.titleSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoContainer(
            icon: Icons.business,
            title: LocaleKeys.contractsPlaceholdersPropertyLabel.tr(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contract.propertyInfo.name,
                  style: AppTextStyles.titleSmall,
                ),
                Text(
                  '${widget.contract.propertyInfo.streetAddress}, ${widget.contract.propertyInfo.city}, ${widget.contract.propertyInfo.governorate.displayName}',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  LocaleKeys.contractsPlaceholdersPricePerDuration.tr(
                    namedArgs: {
                      "price": widget.contract.propertyInfo.price.toString(),
                      "duration": widget.contract.propertyInfo.rentalDuration,
                    },
                  ),
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildInfoContainer(
                icon: Icons.person_outline,
                title: LocaleKeys.contractsPlaceholdersTenantLabel.tr(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.contract.renterInfo.fullName,
                      style: AppTextStyles.titleSmall,
                    ),
                    Text(
                      widget.contract.renterInfo.email,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              _buildInfoContainer(
                icon: Icons.person_outline,
                title: LocaleKeys.contractsPlaceholdersOwnerLabel.tr(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.contract.ownerInfo.fullName,
                      style: AppTextStyles.titleSmall,
                    ),
                    Text(
                      widget.contract.ownerInfo.email,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoContainer(
            icon: Icons.calendar_today,
            title: LocaleKeys.contractsPlaceholdersRentalPeriodLabel.tr(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.contractsPlaceholdersStartDateLabel.tr(),
                      style: AppTextStyles.labelSmall,
                    ),
                    Text(
                      DateFormatter.formatContract(widget.contract.startDate!),
                      style: AppTextStyles.titleSmall,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.contractsPlaceholdersEndDateLabel.tr(),
                      style: AppTextStyles.labelSmall,
                    ),
                    Text(
                      DateFormatter.formatContract(widget.contract.endDate!),
                      style: AppTextStyles.titleSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.contractsPlaceholdersTotalValueLabel.tr(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                    Text(
                      LocaleKeys.contractsPlaceholdersTotalValueAmount.tr(
                        namedArgs: {
                          "amount": widget.contract.totalContractValue
                              .toString(),
                        },
                      ),
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoContainer({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(minHeight: 100),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey.withValues(alpha: .2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.labelMedium),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildDownloadPdfContract(BuildContext context) {
    final isPending =
        widget.contract.contractStatus.name.toLowerCase() == 'pending';
    return CustomGeneralContainer(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.contractsButtonsDownloadContractTitle.tr(),
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey.withValues(alpha: .2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (isPending ? AppColors.grey : AppColors.primary)
                            .withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.picture_as_pdf,
                        color: isPending ? AppColors.grey : AppColors.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        LocaleKeys.contractsPlaceholdersRentalAgreementPdf.tr(),
                        style: AppTextStyles.titleSmall.copyWith(
                          color: isPending ? AppColors.grey : null,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isPending
                      ? LocaleKeys.contractsStatusDownloadDisabledPending.tr()
                      : LocaleKeys.contractsPlaceholdersDownloadDesc.tr(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isPending ? AppColors.grey : null,
                  ),
                ),
                const SizedBox(height: 12),
                CustomGeneralButton(
                  text: LocaleKeys.contractsButtonsDownloadContract.tr(),
                  icon: Icons.download,
                  onPressed: isPending
                      ? null
                      : () {
                          context.read<BookingContractCubit>().getContractPdf(
                            contractId: widget.contract.contractId,
                          );
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadProofContract(BuildContext context) {
    final isPending =
        widget.contract.contractStatus.name.toLowerCase() == 'pending';
    return CustomGeneralContainer(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.contractsButtonsDownloadProofTitle.tr(),
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey.withValues(alpha: .2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (isPending ? AppColors.grey : AppColors.primary)
                            .withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.picture_as_pdf,
                        color: isPending ? AppColors.grey : AppColors.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        LocaleKeys.contractsPlaceholdersProofFile.tr(),
                        style: AppTextStyles.titleSmall.copyWith(
                          color: isPending ? AppColors.grey : null,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isPending
                      ? LocaleKeys.contractsStatusProofDisabledPending.tr()
                      : LocaleKeys.contractsPlaceholdersProofDesc.tr(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isPending ? AppColors.grey : null,
                  ),
                ),
                const SizedBox(height: 12),
                CustomGeneralButton(
                  text: LocaleKeys.contractsButtonsDownloadProof.tr(),
                  icon: Icons.download,
                  onPressed: isPending
                      ? null
                      : () {
                          context.read<BookingContractCubit>().getContractProof(
                            contractId: widget.contract.contractId,
                          );
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadContract(BuildContext context) {
    final status = widget.contract.contractStatus.name.toLowerCase();
    final anchoringStatus = widget.contract.anchoringStatus.name.toLowerCase();
    final isActive = status == 'active' || status == 'expired';
    final isAnchored = anchoringStatus == 'anchored';
    final canUpload = isActive && isAnchored;
    String descriptionText;
    if (!isAnchored) {
      descriptionText = LocaleKeys.contractsStatusPendingAnchoring.tr();
    } else if (!isActive) {
      descriptionText = LocaleKeys.contractsStatusUploadDisabledPending.tr();
    } else {
      descriptionText = LocaleKeys.contractsPlaceholdersUploadDesc.tr();
    }

    return CustomGeneralContainer(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.contractsButtonsVerifyContractTitle.tr(),
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 16),
          Text(
            descriptionText,
            style: AppTextStyles.bodySmall.copyWith(
              color: !canUpload ? AppColors.grey : null,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: !canUpload
                ? null
                : () async {
                    fp.FilePickerResult? result = await fp.FilePicker.pickFiles(
                      type: fp.FileType.custom,
                      allowedExtensions: ['pdf'],
                    );

                    if (result != null && result.files.single.path != null) {
                      setState(() {
                        _selectedFile = File(result.files.single.path!);
                      });
                    }
                  },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: !canUpload
                      ? AppColors.grey.withValues(alpha: .2)
                      : AppColors.grey.withValues(alpha: .5),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.upload_file,
                    size: 48,
                    color: !canUpload
                        ? AppColors.grey.withValues(alpha: .5)
                        : (_selectedFile != null
                              ? AppColors.primary
                              : AppColors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    !canUpload
                        ? (!isAnchored
                              ? LocaleKeys.contractsStatusPendingAnchoring.tr()
                              : LocaleKeys.contractsStatusUploadDisabledLabel
                                    .tr())
                        : (_selectedFile != null
                              ? LocaleKeys.contractsPlaceholdersSelectedFile.tr(
                                  namedArgs: {
                                    "fileName": _selectedFile!.path
                                        .split('/')
                                        .last
                                        .split('\\')
                                        .last,
                                  },
                                )
                              : LocaleKeys.contractsPlaceholdersClickToUpload
                                    .tr()),
                    style: AppTextStyles.titleSmall.copyWith(
                      color: !canUpload ? AppColors.grey : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    _selectedFile != null
                        ? LocaleKeys.contractsPlaceholdersPdfFormat.tr()
                        : LocaleKeys.contractsPlaceholdersPdfFormatOnly.tr(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: !canUpload
                          ? AppColors.grey.withValues(alpha: .5)
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          CustomGeneralButton(
            text: LocaleKeys.contractsButtonsSubmitContract.tr(),
            onPressed: (!canUpload || _selectedFile == null)
                ? null
                : () {
                    context.read<BookingContractCubit>().verifyContract(
                      contractId: widget.contract.contractId,
                      file: _selectedFile!,
                    );
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNotes() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6), // Light yellow background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.contractsPlaceholdersImportantNotesTitle.tr(),
            style: AppTextStyles.titleMedium.copyWith(
              color: const Color(0xFF8D6E63),
            ),
          ),
          const SizedBox(height: 12),
          _buildBulletPoint(
            LocaleKeys.contractsPlaceholdersNoteReadCarefully.tr(),
          ),
          _buildBulletPoint(
            LocaleKeys.contractsPlaceholdersNoteBothParties.tr(),
          ),
          _buildBulletPoint(LocaleKeys.contractsPlaceholdersNoteKeepCopy.tr()),
          _buildBulletPoint(
            LocaleKeys.contractsPlaceholdersNoteContactSupport.tr(),
          ),
          _buildBulletPoint(
            LocaleKeys.contractsPlaceholdersNoteEffectiveDate.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF8D6E63),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF8D6E63),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockchainInfo() {
    final hasTxId =
        widget.contract.transactionId != null &&
        widget.contract.transactionId!.isNotEmpty;
    final hasMerkle =
        widget.contract.merkleRoot != null &&
        widget.contract.merkleRoot!.isNotEmpty;

    final bool isAnchored = widget.contract.isAnchoredToBlockChain;
    final Color statusColor = isAnchored
        ? AppColors.success
        : AppColors.warning;
    final String statusText = isAnchored
        ? LocaleKeys.contractsBlockchainAnchored.tr()
        : LocaleKeys.contractsBlockchainNotAnchored.tr();

    return CustomGeneralContainer(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  children: [
                    Text(
                      LocaleKeys.contractsBlockchainTitle.tr(),
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        statusText,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildDetailRow(
            label: LocaleKeys.contractsBlockchainStatus.tr(),
            value: widget.contract.anchoringStatus.displayName.isNotEmpty
                ? widget.contract.anchoringStatus.displayName
                : widget.contract.anchoringStatus.name,
            icon: Icons.info_outline,
          ),

          if (hasTxId) ...[
            const SizedBox(height: 12),
            _buildHashRow(
              label: LocaleKeys.contractsBlockchainTxId.tr(),
              value: widget.contract.transactionId!,
              icon: Icons.receipt_long_outlined,
            ),
          ],

          if (hasMerkle) ...[
            const SizedBox(height: 12),
            _buildHashRow(
              label: LocaleKeys.contractsBlockchainMerkleRoot.tr(),
              value: widget.contract.merkleRoot!,
              icon: Icons.hub_outlined,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(icon, size: 16, color: AppColors.primary.withOpacity(0.7)),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHashRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary.withOpacity(0.7)),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.copy,
                  size: 16,
                  color: AppColors.primary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                },
              ),
            ],
          ),
          const SizedBox(height: 6),
          SelectableText(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontFamily: 'monospace',
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
