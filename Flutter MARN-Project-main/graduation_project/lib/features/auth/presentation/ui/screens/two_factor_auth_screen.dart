import 'package:MARN/core/widgets/build_appbar.dart';
import 'package:MARN/core/widgets/build_footer.dart';
import 'package:MARN/features/auth/presentation/ui/widgets/two_factor_auth_form.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TwoFactorAuthScreen extends StatelessWidget {
  final String email;
  final String password;
  final bool rememberMe;
  const TwoFactorAuthScreen({
    super.key,
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildAppBar(context),
              TwoFactorAuthForm(
                email: email,
                password: password,
                rememberMe: rememberMe,
              ),
              const BuildFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
