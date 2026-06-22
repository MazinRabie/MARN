import 'package:MARN/core/widgets/app_bar_widget.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_setting_cubit.dart';
import 'package:MARN/features/profile/presentation/ui/widgets/change_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.transparent,
      appBar: appBarWidget(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              BlocConsumer<ProfileSettingCubit, ProfileSettingState>(
                listener: (context, state) {
                  if (state is ChangePasswordSuccess) {
                    buildSnackBar(
                      context,
                      message: state.message,
                      isError: false,
                    );
                    Navigator.pop(context);
                  } else if (state is SettingsError) {
                    buildSnackBar(
                      context,
                      message: state.errorMessage,
                      isError: true,
                    );
                  }
                  isLoading = state is SettingsLoading;
                },
                builder: (context, state) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(child: const ChangePasswordForm()),
                      if (isLoading) Center(child: buildLoading()),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
