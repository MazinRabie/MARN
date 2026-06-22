import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/app_bar_widget.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/features/auth/presentation/state_management/cubit/auth_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ConfirmEmailScreen extends StatefulWidget {
  final String userId;
  final String token;

  const ConfirmEmailScreen({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().confirmEmail(
        userId: widget.userId,
        token: widget.token,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.transparent,
      appBar: appBarWidget(context),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is ConfirmEmailSuccess) {
              buildSnackBar(context, message: state.response);
              context.go(AppRoutes.loginScreen);
            }
          },
          builder: (context, state) {
            return Center(
              child: CustomGeneralContainer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cancel_outlined,
                      size: 80,
                      color: state is AuthError
                          ? AppColors.error
                          : AppColors.pending,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      state is AuthError
                          ? LocaleKeys.commonSomethingWentWrong.tr()
                          : LocaleKeys.commonPleaseWait.tr(),
                      style: AppTextStyles.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    if (state is AuthError) ...[
                      Text(
                        "${state.errorMessage}\n ${LocaleKeys.authConfirmEmailPleaseLoginAgain.tr()}",
                        style: AppTextStyles.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
