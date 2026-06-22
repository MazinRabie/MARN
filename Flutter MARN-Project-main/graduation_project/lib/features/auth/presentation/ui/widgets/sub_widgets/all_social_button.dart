import 'package:MARN/features/auth/presentation/state_management/cubit/auth_cubit.dart';
import 'package:MARN/features/auth/presentation/ui/widgets/sub_widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

class AllSocialButtons extends StatelessWidget {
  const AllSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SocialButton(
          icon: Icons.g_mobiledata,
          text: LocaleKeys.authSocialGoogle.tr(),
          onPressed: () {
            context.read<AuthCubit>().googleSignIn();
          },
        ),
      ],
    );
  }
}
