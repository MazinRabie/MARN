import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/enums/utils/enum_helper.dart';
import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/features/auth/presentation/state_management/cubit/auth_cubit.dart';
import 'package:MARN/features/auth/presentation/ui/widgets/sub_widgets/all_social_button.dart';
import 'package:MARN/core/widgets/custom_text_form_field.dart';
import 'package:MARN/core/widgets/custom_divider.dart';
import 'package:MARN/core/widgets/date_picker_field.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/features/auth/presentation/ui/widgets/sub_widgets/error_message.dart';
import 'package:MARN/core/widgets/general_box_option.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:MARN/core/widgets/date_formatter.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool termsAndServices = false;
  EnumItem? selectedGender;
  String selectedBirthdate = "";

  @override
  Widget build(BuildContext context) {
    return CustomGeneralContainer(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Text(
              LocaleKeys.authSignUpFormTitle.tr(),
              style: AppTextStyles.headlineMedium,
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                Text(
                  LocaleKeys.authSignUpAlreadyHaveAccount.tr(),
                  style: AppTextStyles.bodySmall,
                ),
                InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: Text(
                    LocaleKeys.authButtonsSignIn.tr(),
                    style: AppTextStyles.bodyBold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// FIRST NAME
            CustomTextFormField(
              type: CustomTextFormFieldType.name,
              controller: firstNameController,
              labelText: LocaleKeys.authPlaceholdersFirstName.tr(),
              hintText: LocaleKeys.authPlaceholdersFirstNameHint.tr(),
            ),

            const SizedBox(height: 6),

            /// Last name
            CustomTextFormField(
              type: CustomTextFormFieldType.name,
              controller: lastNameController,
              labelText: LocaleKeys.authPlaceholdersLastName.tr(),
              hintText: LocaleKeys.authPlaceholdersLastNameHint.tr(),
            ),

            const SizedBox(height: 6),

            /// EMAIL
            CustomTextFormField(
              type: CustomTextFormFieldType.email,
              controller: emailController,
              labelText: LocaleKeys.authPlaceholdersEmailAddress.tr(),
              hintText: LocaleKeys.authPlaceholdersEmailHint.tr(),
            ),

            const SizedBox(height: 6),

            /// PASSWORD
            CustomTextFormField(
              type: CustomTextFormFieldType.password,
              controller: passwordController,
              labelText: LocaleKeys.authPlaceholdersPassword.tr(),
              hintText: LocaleKeys.authPlaceholdersCreatePasswordHint.tr(),
              helperText: LocaleKeys.authValidationPasswordHelper.tr(),
            ),

            const SizedBox(height: 6),

            /// CONFIRM PASSWORD
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

            const SizedBox(height: 6),

            /// GENDER
            Text(
              LocaleKeys.authPlaceholdersGender.tr(),
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GeneralBoxOption(
                  label: LocaleKeys.authSignUpMale.tr(),
                  icon: Icons.male,
                  isMultiple: true,
                  isSelected: selectedGender?.id == 1,
                  onTap: () {
                    setState(() {
                      // Updated gender selection using findById for reliability
                      selectedGender = EnumHelper.findById(
                        context,
                        EnumType.gender,
                        1,
                      );
                    });
                  },
                ),
                GeneralBoxOption(
                  label: LocaleKeys.authSignUpFemale.tr(),
                  icon: Icons.female,
                  isMultiple: true,
                  isSelected: selectedGender?.id == 2,
                  onTap: () {
                    setState(() {
                      selectedGender = EnumHelper.findById(
                        context,
                        EnumType.gender,
                        2,
                      );
                    });
                  },
                ),
              ],
            ),
            selectedGender == null
                ? ErrorMessage(
                    message: LocaleKeys.authValidationGenderRequired.tr(),
                  )
                : const SizedBox(),

            const SizedBox(height: 6),
            DatePickerField(
              labelText: LocaleKeys.authPlaceholdersBirthDate.tr(),
              hintText: LocaleKeys.authPlaceholdersBirthDateHint.tr(),
              onDateSelected: (date) {
                setState(() {
                  // Ensure numeric date uses English digits
                  selectedBirthdate = DateFormatter.arabicToEnglish(
                    DateFormat('yyyy-MM-dd').format(date),
                  );
                });
              },
            ),
            selectedBirthdate.isEmpty
                ? ErrorMessage(
                    message: LocaleKeys.authValidationBirthDateRequired.tr(),
                  )
                : const SizedBox(),
            const SizedBox(height: 6),

            /// Terms and services
            Row(
              children: [
                Checkbox(
                  value: termsAndServices,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() {
                      termsAndServices = value!;
                    });
                  },
                ),
                Expanded(
                  child: Wrap(
                    children: [
                      Text(
                        LocaleKeys.authSignUpAgreeTo.tr(),
                        style: AppTextStyles.bodyLarge,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go(AppRoutes.termsOfUseScreen);
                        },
                        child: Text(
                          LocaleKeys.authSignUpTermsOfService.tr(),
                          style: AppTextStyles.bodyBold,
                        ),
                      ),
                      Text(
                        LocaleKeys.authSignUpAnd.tr(),
                        style: AppTextStyles.bodyLarge,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go(AppRoutes.privacyPolicyScreen);
                        },
                        child: Text(
                          LocaleKeys.authSignUpPrivacyPolicy.tr(),
                          style: AppTextStyles.bodyBold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            !termsAndServices
                ? ErrorMessage(
                    message: LocaleKeys.authValidationAcceptTermsRequired.tr(),
                  )
                : const SizedBox(),
            const SizedBox(height: 6),

            /// SIGN UP BUTTON
            CustomGeneralButton(
              text: LocaleKeys.authButtonsSignUp.tr(),
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    termsAndServices &&
                    selectedGender != null &&
                    selectedBirthdate != "") {
                  context.read<AuthCubit>().register(
                    firstName: firstNameController.text.trim(),
                    lastName: lastNameController.text.trim(),
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    confirmPassword: confirmPasswordController.text.trim(),
                    gender: selectedGender!,
                    dateOfBirth: selectedBirthdate,
                  );
                }
              },
            ),

            const SizedBox(height: 6),

            /// DIVIDER
            CustomDivider(text: LocaleKeys.authLoginOrContinueWith.tr()),

            const SizedBox(height: 6),

            /// SOCIAL BUTTONS
            const AllSocialButtons(),
          ],
        ),
      ),
    );
  }
}
