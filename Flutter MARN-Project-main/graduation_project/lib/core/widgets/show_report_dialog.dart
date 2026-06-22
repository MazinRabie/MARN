import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/services/report_service.dart';
import 'package:MARN/core/services/service_locator.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class ReportDialog extends StatefulWidget {
  final EnumItem reportableType;
  final String reportableTargetId;

  const ReportDialog({
    super.key,
    required this.reportableType,
    required this.reportableTargetId,
  });

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final TextEditingController _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedReason;
  bool _isLoading = false;

  List<String> get _predefinedReasons {
    if (widget.reportableType.name.toLowerCase() == 'property') {
      return [
        LocaleKeys.reportInaccurateListing.tr(),
        LocaleKeys.reportFraudulentListing.tr(),
        LocaleKeys.reportSuspiciousHost.tr(),
        LocaleKeys.reportOther.tr(),
      ];
    } else {
      return [
        LocaleKeys.reportHarassment.tr(),
        LocaleKeys.reportSpam.tr(),
        LocaleKeys.reportHateSpeech.tr(),
        LocaleKeys.reportInappropriateContent.tr(),
        LocaleKeys.reportOther.tr(),
      ];
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    final selection = _selectedReason;
    final otherText = _reasonController.text.trim();

    if (selection == null && otherText.isEmpty) {
      buildSnackBar(
        context,
        message: LocaleKeys.reportPleaseSelectReason.tr(),
        isError: true,
      );
      return;
    }

    final finalReason = [
      if (selection != null) selection,
      if (otherText.isNotEmpty) otherText,
    ].join(': ');

    setState(() {
      _isLoading = true;
    });

    try {
      final reportService = getIt<ReportService>();
      final response = await reportService.submitReport(
        reportableType: widget.reportableType,
        reportableTargetId: widget.reportableTargetId,
        reason: finalReason,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          Navigator.pop(context);
          buildSnackBar(
            context,
            message:
                response.data["message"] ??
                LocaleKeys.commonSave
                    .tr(), // Using something general if fallback is needed, though response handles success
            isError: false,
          );
        }
      } else {
        throw Exception(
          LocaleKeys.reportFailedWithStatus.tr(
            args: [response.statusCode.toString()],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        buildSnackBar(
          context,
          message: LocaleKeys.commonSomethingWentWrong.tr(),
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.errorContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.report_gmailerrorred_rounded,
                        color: AppColors.error,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        LocaleKeys.reportReportTarget.tr(
                          args: [
                            widget.reportableType.displayName.isNotEmpty
                                ? widget.reportableType.displayName
                                : widget.reportableType.name,
                          ],
                        ),
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.reportPleaseSelectReason.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _predefinedReasons.map((reason) {
                    final isSelected = _selectedReason == reason;
                    return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedReason = null; // deselect if clicked again
                          } else {
                            _selectedReason = reason;
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.errorContainer
                              : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.errorSoft
                                : AppColors.divider,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          reason,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isSelected
                                ? AppColors.error
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Text(
                  LocaleKeys.reportPleaseSelectReason.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: _reasonController,
                  hintText: LocaleKeys.reportPleaseSelectReason.tr(),
                  type: CustomTextFormFieldType.text,
                  validator: (value) {
                    final isOtherSelected =
                        _selectedReason == LocaleKeys.reportOther.tr();
                    if (isOtherSelected &&
                        (value == null || value.trim().isEmpty)) {
                      return LocaleKeys.reportPleaseSelectReason.tr();
                    }
                    return null;
                  },
                  maxLines: 4,
                  minLines: 2,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.pop(context),
                        child: Text(
                          LocaleKeys.commonCancel.tr(),
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomGeneralButton(
                        text: LocaleKeys.commonSave.tr(),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _submitReport();
                          }
                        },
                        isLoading: _isLoading,
                        backgroundColor: AppColors.error,
                        textColor: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showReportDialog(
  BuildContext context, {
  required EnumItem reportableType,
  required String reportableTargetId,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => ReportDialog(
      reportableType: reportableType,
      reportableTargetId: reportableTargetId,
    ),
  );
}
