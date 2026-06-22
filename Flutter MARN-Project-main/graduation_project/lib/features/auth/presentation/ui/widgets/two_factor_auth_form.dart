import 'package:MARN/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/custom_icon.dart';
import 'package:MARN/features/auth/presentation/state_management/cubit/auth_cubit.dart';
import 'package:MARN/features/auth/presentation/ui/widgets/sub_widgets/otp_fields.dart';
import 'package:MARN/features/auth/presentation/ui/widgets/sub_widgets/otp_timer.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TwoFactorAuthForm extends StatefulWidget {
  final String email;
  final String password;
  final bool rememberMe;
  const TwoFactorAuthForm({
    super.key,
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  @override
  State<TwoFactorAuthForm> createState() => _TwoFactorAuthFormState();
}

class _TwoFactorAuthFormState extends State<TwoFactorAuthForm> {
  String code = "";
  @override
  Widget build(BuildContext context) {
    return CustomGeneralContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomIcon(iconData: Icons.mail_outline),
          const SizedBox(height: 24),

          /// Title
          Text(LocaleKeys.authOtpTitle.tr(), style: AppTextStyles.headlineMedium),

          const SizedBox(height: 8),

          /// Subtitle
          Text(LocaleKeys.authOtpSubtitle.tr(), style: AppTextStyles.bodySmall),

          const SizedBox(height: 4),

          Text(widget.email, style: AppTextStyles.bodyMedium),

          const SizedBox(height: 28),

          /// Instruction
          Text(LocaleKeys.authOtpEnterCode.tr(), style: AppTextStyles.bodyBold),

          const SizedBox(height: 16),

          /// OTP Fields
          OtpFields(
            onCodeChanged: (code) {
              this.code = code.trim();
            },
          ),

          const SizedBox(height: 20),

          /// Resend timer
          OtpTimer(
            onTimerEnd: () {
              context.read<AuthCubit>().login(
                email: widget.email,
                password: widget.password,
                rememberMe: widget.rememberMe,
                context: context,
              );
            },
          ),

          const SizedBox(height: 20),

          /// Button
          CustomGeneralButton(
            text: LocaleKeys.authButtonsVerifyAndContinue.tr(),
            onPressed: () {
              context.read<AuthCubit>().loginWithTwoFactorCode(
                email: widget.email,
                code: code,
                rememberMe: widget.rememberMe,
              );
            },
          ),

          const SizedBox(height: 24),

          /// Footer
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            children: [
              Text(LocaleKeys.authOtpDidNotReceiveCode.tr(), style: AppTextStyles.bodyLarge),
              InkWell(
                onTap: () {},
                child: Text(LocaleKeys.authOtpContactSupport.tr(), style: AppTextStyles.bodyBold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
