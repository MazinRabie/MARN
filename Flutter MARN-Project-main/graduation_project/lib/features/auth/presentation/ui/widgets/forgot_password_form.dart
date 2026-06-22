import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/custom_text_form_field.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/features/auth/presentation/state_management/cubit/auth_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomGeneralContainer(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Text(LocaleKeys.authForgotPasswordFormTitle.tr(), style: AppTextStyles.headlineMedium),

            const SizedBox(height: 8),

            Text(
              LocaleKeys.authForgotPasswordFormSubtitle.tr(),
              style: AppTextStyles.bodySmall,
            ),

            const SizedBox(height: 30),

            /// EMAIL
            CustomTextFormField(
              type: CustomTextFormFieldType.email,
              controller: emailController,
              labelText: LocaleKeys.authPlaceholdersEmailAddress.tr(),
              hintText: LocaleKeys.authPlaceholdersEmailHint.tr(),
            ),

            const SizedBox(height: 20),

            /// SIGN IN BUTTON
            CustomGeneralButton(
              text: LocaleKeys.authButtonsSendResetLink.tr(),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthCubit>().forgotPassword(
                    email: emailController.text,
                  );
                }
              },
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: ShapeDecoration(
                color: AppColors.primary.withAlpha(30),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1.6,
                    color: AppColors.primary.withAlpha(60),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.authForgotPasswordInfoValidity.tr(),
                    style: AppTextStyles.bodyBold,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    LocaleKeys.authForgotPasswordInfoSecure.tr(),
                    style: AppTextStyles.bodyBold,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    LocaleKeys.authForgotPasswordInfoAccess.tr(),
                    style: AppTextStyles.bodyBold,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Text(
                  LocaleKeys.authForgotPasswordRememberPassword.tr(),
                  style: AppTextStyles.bodySmall,
                ),
                InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: Text(LocaleKeys.authButtonsSignIn.tr(), style: AppTextStyles.bodyBold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
