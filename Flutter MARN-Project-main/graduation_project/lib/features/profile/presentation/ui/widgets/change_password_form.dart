import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/custom_text_form_field.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_setting_cubit.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController currentPasswordController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  bool obscureCurrentPassword = true;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    currentPasswordController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomGeneralContainer(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Text(LocaleKeys.profileChangePasswordTitle.tr(), style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            Text(LocaleKeys.profileChangePasswordSubtitle.tr(), style: AppTextStyles.bodySmall),
            const SizedBox(height: 30),

            /// CURRENT PASSWORD
            CustomTextFormField(
              type: CustomTextFormFieldType.password,
              controller: currentPasswordController,
              labelText: LocaleKeys.profileChangePasswordCurrentPassword.tr(),
              hintText: LocaleKeys.profileChangePasswordCurrentPasswordHint.tr(),
            ),

            const SizedBox(height: 6),

            /// NEW PASSWORD
            CustomTextFormField(
              type: CustomTextFormFieldType.password,
              controller: passwordController,
              labelText: LocaleKeys.profileChangePasswordNewPassword.tr(),
              hintText: LocaleKeys.profileChangePasswordNewPasswordHint.tr(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.profileValidationPasswordRequired.tr();
                }
                if (!value.contains(RegExp(r"[A-Z]"))) {
                  return LocaleKeys.profileValidationPasswordUppercase.tr();
                }

                if (!value.contains(RegExp(r"[a-z]"))) {
                  return LocaleKeys.profileValidationPasswordLowercase.tr();
                }

                if (!value.contains(RegExp(r"[0-9]"))) {
                  return LocaleKeys.profileValidationPasswordNumber.tr();
                }

                if (value.length < 6) {
                  return LocaleKeys.profileValidationPasswordMinLength.tr();
                }

                if (value == currentPasswordController.text) {
                  return LocaleKeys.profileValidationPasswordSameAsCurrent.tr();
                }

                return null;
              },
            ),

            const SizedBox(height: 6),

            /// CONFIRM PASSWORD
            CustomTextFormField(
              type: CustomTextFormFieldType.password,
              controller: confirmPasswordController,
              labelText: LocaleKeys.profileChangePasswordConfirmPassword.tr(),
              hintText: LocaleKeys.profileChangePasswordConfirmPasswordHint.tr(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.profileValidationConfirmPasswordRequired.tr();
                }
                if (value != passwordController.text) {
                  return LocaleKeys.profileValidationPasswordsDoNotMatch.tr();
                }
                return null;
              },
            ),

            const SizedBox(height: 25),

            CustomGeneralButton(
              text: LocaleKeys.profileButtonsChangePasswordButton.tr(),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  BlocProvider.of<ProfileSettingCubit>(context).changePassword(
                    currentPassword: currentPasswordController.text,
                    newPassword: passwordController.text,
                    newPasswordConfirmation: confirmPasswordController.text,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
