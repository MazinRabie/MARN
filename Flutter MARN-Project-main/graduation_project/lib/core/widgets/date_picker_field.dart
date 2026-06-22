import 'package:MARN/core/widgets/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class DatePickerField extends StatefulWidget {
  final String hintText;
  final String? labelText;
  final DateTime? initialValue;
  final void Function(DateTime)? onDateSelected;
  final bool isRequired;
  final String? requiredMessage;

  const DatePickerField({
    super.key,
    required this.hintText,
    required this.labelText,
    this.onDateSelected,
    this.initialValue,
    this.isRequired = false,
    this.requiredMessage,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime? selectedDate;
  String? formattedDate;

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != null) {
      selectedDate = widget.initialValue;
      formattedDate = DateFormat('dd-MM-yyyy').format(widget.initialValue!);
    }
  }

  @override
  void didUpdateWidget(covariant DatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != null) {
      selectedDate = widget.initialValue;
      formattedDate = DateFormat('dd-MM-yyyy').format(widget.initialValue!);
    }
  }

  Future<void> _pickDate(FormFieldState<DateTime> state) async {
    if (!mounted) return;

    DateTime now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      useRootNavigator: true,
      initialDate: selectedDate ?? DateTime(now.year - 20),
      firstDate: DateTime(now.year - 120),
      lastDate: DateTime(now.year - 13),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormatter.arabicToEnglish(DateFormat('dd-MM-yyyy').format(picked));
      });

      state.didChange(picked);

      widget.onDateSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: selectedDate,
      validator: (value) {
        if (widget.isRequired && value == null) {
          return widget.requiredMessage ??
              LocaleKeys.validationRequiredField.tr();
        }
        return null;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labelText != null)
              Text(widget.labelText!, style: AppTextStyles.bodyLarge),

            const SizedBox(height: 8),

            InkWell(
              onTap: () => _pickDate(state),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: state.hasError ? Colors.red : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: AppColors.border),

                    const SizedBox(width: 12),

                    Expanded(
                      child: formattedDate != null
                          ? Text(formattedDate!, style: AppTextStyles.bodyLarge)
                          : Text(
                              widget.hintText,
                              style: AppTextStyles.bodyHint,
                            ),
                    ),
                  ],
                ),
              ),
            ),

            if (state.hasError) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
