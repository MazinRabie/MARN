import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/app_bar_widget.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_setting_cubit.dart';
import 'package:MARN/features/profile/presentation/ui/widgets/toggle_two_factor_auth_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToggleTwoFactorAuthScreen extends StatefulWidget {
  const ToggleTwoFactorAuthScreen({super.key});

  @override
  State<ToggleTwoFactorAuthScreen> createState() =>
      _ToggleTwoFactorAuthScreenState();
}

class _ToggleTwoFactorAuthScreenState extends State<ToggleTwoFactorAuthScreen> {
  bool? _isTwoFactorEnabled;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileSettingCubit>().getProfileSettingsInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  if (state is GetProfileSettingsInfoLoaded) {
                    setState(() {
                      _isTwoFactorEnabled =
                          state.profileSettingsEntity.twoFactorEnabled;
                    });
                  } else if (state is ToggleTwoFactorAuthSuccess) {
                    buildSnackBar(
                      context,
                      message: state.message,
                      bgColor: AppColors.primary,
                    );
                    context
                        .read<ProfileSettingCubit>()
                        .getProfileSettingsInfo();
                  } else if (state is SettingsError) {
                    buildSnackBar(
                      context,
                      message: state.errorMessage,
                      isError: true,
                    );
                  }
                },
                builder: (context, state) {
                  if (_isTwoFactorEnabled == null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Center(child: buildLoading()),
                    );
                  }

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: ToggleTwoFactorAuthForm(
                          isTwoFactorEnabled: _isTwoFactorEnabled!,
                        ),
                      ),
                      if (state is SettingsLoading)
                        Center(child: buildLoading()),
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
