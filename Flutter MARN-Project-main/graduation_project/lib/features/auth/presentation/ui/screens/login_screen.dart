import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/routes/routes.dart';
import 'package:MARN/core/widgets/build_appbar.dart';
import 'package:MARN/core/widgets/build_footer.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/features/auth/presentation/state_management/cubit/auth_cubit.dart';
import 'package:MARN/features/auth/presentation/ui/widgets/sign_in_form.dart';
import 'package:MARN/core/widgets/build_header.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                title: LocaleKeys.authLoginHeaderTitle.tr(),
                subtitle: LocaleKeys.authLoginHeaderSubtitle.tr(),
              ),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) async {
                  if (state is AuthLoading) {
                    isLoading = true;
                  } else if (state is LoginSuccess) {
                    context.read<ProfileCubit>().getMyProfile();
                    context.go(AppRoutes.mainLayoutScreen);
                    isLoading = false;
                  } else if (state is GoogleSignInSuccess) {
                    context.read<ProfileCubit>().getMyProfile();
                    context.go(AppRoutes.mainLayoutScreen);
                    isLoading = false;
                  } else if (state is TwoFactorAuthenticationRequired) {
                    isLoading = false;
                    context.push(
                      AppRoutes.twoFactorAuthScreen,
                      extra: TwoFactorAuthArguments(
                        email: state.email,
                        password: state.password,
                        rememberMe: state.rememberMe,
                      ),
                    );
                  } else if (state is AuthError) {
                    isLoading = false;
                    buildSnackBar(
                      context,
                      message: state.errorMessage,
                      isError: true,
                    );
                  } else if (state is ResendConfirmationEmailSuccess) {
                    isLoading = false;
                    buildSnackBar(
                      context,
                      message: state.response,
                      bgColor: AppColors.primary,
                    );
                  } else if (state is StopLoading) {
                    isLoading = false;
                  }
                },
                builder: (BuildContext context, AuthState state) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      const SignInForm(),
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
