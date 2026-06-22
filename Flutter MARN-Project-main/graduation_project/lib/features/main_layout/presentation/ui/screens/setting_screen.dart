import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/app_bar_widget.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_setting_drawer_item.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/core/widgets/custom_divider.dart';
import 'package:MARN/core/widgets/my_show_dialog.dart';
import 'package:MARN/core/localization/language_manager.dart';
import 'package:MARN/features/auth/presentation/state_management/cubit/auth_cubit.dart';
import 'package:MARN/features/main_layout/presentation/state_management/cubit/notification_cubit.dart';
import 'package:MARN/features/chat/presentation/state_management/cubit/message_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isArabic = false;

  @override
  void initState() {
    super.initState();
    final saved = LanguageManager.getSavedLanguage();
    _isArabic = saved == 'ar';
  }

  Future<void> _onLanguageToggle(bool value) async {
    final newLang = value ? 'ar' : 'en';
    setState(() => _isArabic = value);
    await LanguageManager.changeLanguage(context, newLang);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.transparent,
      appBar: appBarWidget(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          child: ListView(
            children: [
              CustomDivider(text: LocaleKeys.mainLayoutSettingsAccount.tr()),
              BuildSettingDrawerItem(
                icon: Icons.person,
                title: LocaleKeys.mainLayoutSettingsEditProfile.tr(),
                route: AppRoutes.editProfileScreen,
              ),
              BuildSettingDrawerItem(
                icon: Icons.lock,
                title: LocaleKeys.mainLayoutSettingsChangePassword.tr(),
                route: AppRoutes.changePasswordScreen,
              ),
              CustomDivider(
                text: LocaleKeys.mainLayoutSettingsPreferences.tr(),
              ),
              BuildSettingDrawerItem(
                icon: Icons.person_2,
                title: LocaleKeys.mainLayoutSettingsRoommatePreferences.tr(),
                route: AppRoutes.editRoommatePreferencesScreen,
              ),
              // const CustomDivider(text: "Appearance"),
              // BuildSettingDrawerItem(
              //   icon: Icons.dark_mode,
              //   title: "Theme",
              //   route: AppRoutes.blankScreen,
              // ),
              CustomDivider(text: LocaleKeys.mainLayoutSettingsSecurity.tr()),
              BuildSettingDrawerItem(
                icon: Icons.security,
                title: LocaleKeys.mainLayoutSettingsTwoFactorAuth.tr(),
                route: AppRoutes.toggleTwoFactorAuthScreen,
              ),
              BuildSettingDrawerItem(
                icon: Icons.description,
                title: LocaleKeys.mainLayoutSettingsIdentityVerification.tr(),
                route: AppRoutes.identityVerificationScreen,
              ),
              CustomDivider(text: LocaleKeys.mainLayoutSettingsLanguage.tr()),
              SwitchListTile(
                value: _isArabic,
                title: Text(LocaleKeys.mainLayoutSettingsArabicLanguage.tr()),
                subtitle: Text(_isArabic ? 'عربي' : 'English'),
                secondary: const Icon(Icons.language),
                onChanged: _onLanguageToggle,
              ),
              CustomDivider(
                text: LocaleKeys.mainLayoutSettingsHelpSupport.tr(),
              ),
              BuildSettingDrawerItem(
                icon: Icons.info,
                title: LocaleKeys.mainLayoutSettingsAboutMarn.tr(),
                route: AppRoutes.aboutMarnScreen,
              ),
              BuildSettingDrawerItem(
                icon: Icons.help,
                title: LocaleKeys.mainLayoutSettingsHowItWorks.tr(),
                route: AppRoutes.howItWorksScreen,
              ),
              BuildSettingDrawerItem(
                icon: Icons.question_answer,
                title: LocaleKeys.mainLayoutSettingsFaq.tr(),
                route: AppRoutes.faqScreen,
              ),
              BuildSettingDrawerItem(
                icon: Icons.privacy_tip,
                title: LocaleKeys.mainLayoutSettingsPrivacyPolicy.tr(),
                route: AppRoutes.privacyPolicyScreen,
              ),
              BuildSettingDrawerItem(
                icon: Icons.description,
                title: LocaleKeys.mainLayoutSettingsTermsOfUse.tr(),
                route: AppRoutes.termsOfUseScreen,
              ),
              BuildSettingDrawerItem(
                icon: Icons.contact_mail,
                title: LocaleKeys.mainLayoutSettingsContact.tr(),
                route: AppRoutes.contactScreen,
              ),
              const Divider(),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is LogoutSuccess) {
                    context.go(AppRoutes.loginScreen);
                    buildSnackBar(
                      context,
                      message: state.response,
                      isError: false,
                      bgColor: AppColors.primary,
                    );
                  } else if (state is DeleteAccountSuccess) {
                    context.go(AppRoutes.loginScreen);
                    buildSnackBar(
                      context,
                      message: state.response,
                      isError: false,
                      bgColor: AppColors.primary,
                    );
                  } else if (state is AuthError) {
                    buildSnackBar(
                      context,
                      message: state.errorMessage,
                      isError: true,
                    );
                  }
                },
                builder: (context, state) {
                  return state is AuthLoading
                      ? buildLoading()
                      : Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.logout),
                              title: Text(
                                LocaleKeys.mainLayoutSettingsLogout.tr(),
                              ),
                              onTap: () async {
                                await context.read<MessageCubit>().disconnect();
                                
                                await context.read<NotificationCubit>().disconnect();
                                
                                context
                                    .read<NotificationCubit>()
                                    .deleteFCMToken();
                                
                                context.read<AuthCubit>().logout();
                                
                              },
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.delete,
                                color: AppColors.error,
                              ),
                              title: Text(
                                LocaleKeys.mainLayoutSettingsDeleteAccount.tr(),
                                style: const TextStyle(color: AppColors.error),
                              ),
                              onTap: () {
                                myShowDialog(
                                  context,
                                  title: LocaleKeys
                                      .mainLayoutSettingsDeleteAccountConfirmTitle
                                      .tr(),
                                  content: LocaleKeys
                                      .mainLayoutSettingsDeleteAccountConfirmContent
                                      .tr(),
                                  confirmText: LocaleKeys
                                      .mainLayoutSettingsDelete
                                      .tr(),
                                  onConfirm: () async {
                                    await context.read<MessageCubit>().disconnect();
                                    await context
                                        .read<NotificationCubit>()
                                        .disconnect();
                                    context
                                        .read<NotificationCubit>()
                                        .deleteFCMToken();
                                    context.read<AuthCubit>().deleteAccount();
                                  },
                                );
                              },
                            ),
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
