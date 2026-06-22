import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/custom_text_form_field.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/features/auth/presentation/state_management/cubit/auth_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({
    super.key,
    required this.email,
    required this.token,
  });
  final String email;
  final String token;
  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  @override
  void dispose() {
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
            Text(LocaleKeys.authResetPasswordTitle.tr(), style: AppTextStyles.headlineMedium),

            const SizedBox(height: 8),

            Text(
              LocaleKeys.authResetPasswordSubtitle.tr(args: [widget.email]),
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 30),

            /// NEW PASSWORD
            CustomTextFormField(
              type: CustomTextFormFieldType.password,
              controller: passwordController,
              labelText: LocaleKeys.authPlaceholdersPassword.tr(),
              hintText: LocaleKeys.authPlaceholdersCreatePasswordHint.tr(),
            ),

            const SizedBox(height: 6),

            /// CONFIRM PASSWORD
            const SizedBox(height: 6),

            CustomTextFormField(
              type: CustomTextFormFieldType.password,
              controller: confirmPasswordController,
              labelText: LocaleKeys.authPlaceholdersConfirmPassword.tr(),
              hintText: LocaleKeys.authPlaceholdersConfirmPasswordHint.tr(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.authValidationConfirmPasswordRequired.tr();
                }
                if (value != passwordController.text) {
                  return LocaleKeys.authValidationPasswordsDoNotMatch.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: 25),
            CustomGeneralButton(
              text: LocaleKeys.authButtonsResetPassword.tr(),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthCubit>().resetPassword(
                    email: widget.email,
                    token: widget.token,
                    newPassword: passwordController.text,
                    confirmPassword: confirmPasswordController.text,
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
