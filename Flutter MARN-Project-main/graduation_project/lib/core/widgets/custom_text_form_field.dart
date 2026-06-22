import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

enum CustomTextFormFieldType { email, name, password, text, number }

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData? prefixIcon;
  final String? labelText;
  final String? helperText;
  final CustomTextFormFieldType type;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int? minLines;
  final String? initialValue;
  final TextInputAction? textInputAction;

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.hintText,
    this.labelText,
    required this.type,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.maxLines,
    this.minLines,
    this.initialValue,
    this.textInputAction,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool obscureText;

  @override
  void initState() {
    obscureText = widget.type == CustomTextFormFieldType.password
        ? true
        : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.labelText != null
            ? Text(widget.labelText!, style: AppTextStyles.bodyLarge)
            : const SizedBox(),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          textInputAction: widget.textInputAction,
          keyboardType: switch (widget.type) {
            CustomTextFormFieldType.email => TextInputType.emailAddress,
            CustomTextFormFieldType.name => TextInputType.text,
            CustomTextFormFieldType.password => TextInputType.visiblePassword,
            CustomTextFormFieldType.text => TextInputType.text,
            CustomTextFormFieldType.number => TextInputType.phone,
          },
          obscureText: obscureText,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          maxLines: widget.maxLines ?? 1,
          minLines: widget.minLines ?? 1,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyles.bodyHint,
            helper: widget.helperText != null
                ? Text(widget.helperText!, style: AppTextStyles.metadata)
                : null,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: AppColors.border)
                : switch (widget.type) {
                    CustomTextFormFieldType.email => Icon(
                      Icons.email_outlined,
                      color: AppColors.border,
                    ),
                    CustomTextFormFieldType.name => Icon(
                      Icons.person_outline,
                      color: AppColors.border,
                    ),
                    CustomTextFormFieldType.password => Icon(
                      Icons.lock_outline,
                      color: AppColors.border,
                    ),
                    CustomTextFormFieldType.text => null,
                    CustomTextFormFieldType.number => Icon(
                      Icons.phone,
                      color: AppColors.border,
                    ),
                  },
            suffixIcon: widget.type == CustomTextFormFieldType.password
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
            filled: true,
            fillColor: AppColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          validator: switch (widget.type) {
            CustomTextFormFieldType.email =>
              widget.validator ??
                  (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.validationEmailRequired.tr();
                    }
                    if (!RegExp(
                      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                    ).hasMatch(value)) {
                      return LocaleKeys.validationInvalidEmail.tr();
                    }
                    return null;
                  },
            CustomTextFormFieldType.name =>
              widget.validator ??
                  (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.validationFieldIsRequired.tr(args: [widget.labelText ?? ""]);
                    }
                    if (value.length < 2 || value.length > 50) {
                      return LocaleKeys.validationFieldLengthBetween2And50.tr(args: [widget.labelText ?? ""]);
                    }
                    return null;
                  },
            CustomTextFormFieldType.password =>
              widget.validator ??
                  (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.validationPasswordRequired.tr();
                    }
                    if (!value.contains(RegExp(r"[A-Z]"))) {
                      return LocaleKeys.validationPasswordUppercase.tr();
                    }

                    if (!value.contains(RegExp(r"[a-z]"))) {
                      return LocaleKeys.validationPasswordLowercase.tr();
                    }

                    if (!value.contains(RegExp(r"[0-9]"))) {
                      return LocaleKeys.validationPasswordNumber.tr();
                    }

                    if (value.length < 6) {
                      return LocaleKeys.validationPasswordMinLength.tr();
                    }
                    return null;
                  },
            CustomTextFormFieldType.text => widget.validator,
            CustomTextFormFieldType.number => widget.validator,
          },
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
