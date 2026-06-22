import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/widgets/build_appbar.dart';
import 'package:MARN/core/widgets/build_footer.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/features/auth/presentation/state_management/cubit/auth_cubit.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/features/auth/presentation/ui/widgets/reset_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  final String token;
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.token,
  });
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthLoading) {
                    isLoading = true;
                  } else if (state is StopLoading) {
                    isLoading = false;
                  } else if (state is ResetPasswordSuccess) {
                    isLoading = false;
                    buildSnackBar(
                      context,
                      message: state.response,
                      icon: Icons.check_circle_outline,
                      bgColor: AppColors.primary,
                    );
                    context.go(AppRoutes.loginScreen);
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
                      ResetPasswordForm(email: email, token: token),
                      Center(
                        child: isLoading
                            ? buildLoading()
                            : const SizedBox.shrink(),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              const BuildFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
