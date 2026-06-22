import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/widgets/build_appbar.dart';
import 'package:MARN/core/widgets/build_footer.dart';
import 'package:MARN/core/widgets/build_header.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/features/auth/presentation/state_management/cubit/auth_cubit.dart';
import 'package:MARN/features/auth/presentation/ui/widgets/forgot_password_form.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildAppBar(context),
              BuildHeader(
                title: LocaleKeys.authForgotPasswordHeaderTitle.tr(),
                subtitle: LocaleKeys.authForgotPasswordHeaderSubtitle.tr(),
              ),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthLoading) {
                    isLoading = true;
                  } else if (state is StopLoading) {
                    isLoading = false;
                  } else if (state is ForgotPasswordSuccess) {
                    isLoading = false;
                    buildSnackBar(
                      context,
                      message: state.response,
                      icon: Icons.check_circle_outline,
                      bgColor: AppColors.primary,
                    );
                  } else if (state is AuthError) {
                    isLoading = false;
                    buildSnackBar(
                      context,
                      message: state.errorMessage,
                      icon: Icons.error_outline,
                      isError: true,
                    );
                  }
                },
                builder: (context, state) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      const ForgotPasswordForm(),
                      Center(
                        child: isLoading
                            ? buildLoading()
                            : const SizedBox.shrink(),
                      ),
                    ],
                  );
                },
              ),
              const BuildFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
