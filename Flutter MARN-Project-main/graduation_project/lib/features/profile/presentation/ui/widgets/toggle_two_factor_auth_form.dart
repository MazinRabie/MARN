import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/custom_text_form_field.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_setting_cubit.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToggleTwoFactorAuthForm extends StatefulWidget {
  final bool isTwoFactorEnabled;
  const ToggleTwoFactorAuthForm({super.key, required this.isTwoFactorEnabled});

  @override
  State<ToggleTwoFactorAuthForm> createState() =>
      _ToggleTwoFactorAuthFormState();
}

class _ToggleTwoFactorAuthFormState extends State<ToggleTwoFactorAuthForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController passwordController;
  bool obscurePassword = true;

  late bool isTwoFactorAuthenticationEnabled;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    isTwoFactorAuthenticationEnabled = widget.isTwoFactorEnabled;
  }

  @override
  void didUpdateWidget(covariant ToggleTwoFactorAuthForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isTwoFactorEnabled != widget.isTwoFactorEnabled) {
      isTwoFactorAuthenticationEnabled = widget.isTwoFactorEnabled;
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
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
            Text(
              LocaleKeys.profileToggle2faSecurityLayer.tr(),
              style: AppTextStyles.headlineSmall,
            ),

            const SizedBox(height: 8),

            Text(
              isTwoFactorAuthenticationEnabled
                  ? LocaleKeys.profileToggle2faEnabledSubtitle.tr()
                  : LocaleKeys.profileToggle2faDisabledSubtitle.tr(),
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 18),

            /// Password Field
            CustomTextFormField(
              type: CustomTextFormFieldType.password,
              controller: passwordController,
              labelText: LocaleKeys.profileToggle2faPasswordLabel.tr(),
              hintText: LocaleKeys.profileToggle2faPasswordHint.tr(),
            ),

            const SizedBox(height: 20),

            CustomGeneralButton(
              text: isTwoFactorAuthenticationEnabled 
                  ? LocaleKeys.profileButtonsDisable.tr() 
                  : LocaleKeys.profileButtonsEnable.tr(),
              backgroundColor: isTwoFactorAuthenticationEnabled
                  ? AppColors.errorSoft
                  : AppColors.successSoft,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<ProfileSettingCubit>().toggleTwoFactorAuth(
                    password: passwordController.text,
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
