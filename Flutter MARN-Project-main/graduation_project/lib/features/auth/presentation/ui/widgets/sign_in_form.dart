import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/features/auth/presentation/state_management/cubit/auth_cubit.dart';
import 'package:MARN/features/auth/presentation/ui/widgets/sub_widgets/all_social_button.dart';
import 'package:MARN/core/widgets/custom_text_form_field.dart';
import 'package:MARN/core/widgets/custom_divider.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool rememberMe = false;
  @override
  Widget build(BuildContext context) {
    return CustomGeneralContainer(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Text(LocaleKeys.authLoginFormTitle.tr(), style: AppTextStyles.headlineMedium),

            const SizedBox(height: 8),

            Row(
              children: [
                Text(LocaleKeys.authLoginNoAccount.tr(), style: AppTextStyles.bodySmall),
                InkWell(
                  onTap: () {
                    context.push(AppRoutes.signUpScreen);
                  },
                  child: Text(LocaleKeys.authButtonsSignUp.tr(), style: AppTextStyles.bodyBold),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// EMAIL
            CustomTextFormField(
              type: CustomTextFormFieldType.email,
              controller: emailController,
              labelText: LocaleKeys.authPlaceholdersEmailAddress.tr(),
              hintText: LocaleKeys.authPlaceholdersEmailHint.tr(),
            ),

            const SizedBox(height: 20),

            /// Forgot PASSWORD
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LocaleKeys.authPlaceholdersPassword.tr(), style: AppTextStyles.bodyLarge),
                InkWell(
                  onTap: () {
                    context.push(AppRoutes.forgotPasswordScreen);
                  },
                  child: Text(
                    LocaleKeys.authLoginForgotPasswordLink.tr(),
                    style: AppTextStyles.bodyBold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // PASSWORD
            CustomTextFormField(
              type: CustomTextFormFieldType.password,
              controller: passwordController,
              hintText: LocaleKeys.authPlaceholdersPasswordHint.tr(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.validationPasswordRequired.tr();
                }
                if (value.length < 6) {
                  return LocaleKeys.validationPasswordMinLength.tr();
                }
                return null;
              },
            ),

            const SizedBox(height: 15),

            /// REMEMBER ME
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value!;
                    });
                  },
                ),
                Text(LocaleKeys.authLoginRememberMe.tr(), style: AppTextStyles.bodyBold),
              ],
            ),

            const SizedBox(height: 20),

            /// SIGN IN BUTTON
            CustomGeneralButton(
              text: LocaleKeys.authButtonsSignIn.tr(),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthCubit>().login(
                    email: emailController.text,
                    password: passwordController.text,
                    rememberMe: rememberMe,
                    context: context,
                  );
                }
              },
            ),

            const SizedBox(height: 25),

            /// DIVIDER
            CustomDivider(text: LocaleKeys.authLoginOrContinueWith.tr()),

            const SizedBox(height: 20),

            /// SOCIAL BUTTONS
            const AllSocialButtons(),
          ],
        ),
      ),
    );
  }
}
