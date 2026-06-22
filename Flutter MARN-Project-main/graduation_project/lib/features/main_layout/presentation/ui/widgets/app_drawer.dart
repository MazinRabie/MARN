import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_setting_drawer_item.dart';
import 'package:MARN/core/widgets/profile_image_widget.dart';
import 'package:MARN/core/widgets/status_badge_widget.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MARN/features/property/presentation/state_management/cubit/property_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<PropertyCubit, PropertyState>(
        buildWhen: (previous, current) {
          return current is PropertyBecomeOwnerSuccess;
        },
        builder: (context, propertyState) {
          bool becomeOwner = propertyState is PropertyBecomeOwnerSuccess;
          return BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                bool isOwner = state.profileEntity.isOwner;

                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Header
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        UserAccountsDrawerHeader(
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                          ),
                          accountName: Text(
                            state.profileEntity.fullName.trim(),
                            style: AppTextStyles.headlineSmall,
                          ),
                          accountEmail: Text(
                            state.profileEntity.email.trim(),
                            style: AppTextStyles.bodyMedium,
                          ),
                          currentAccountPicture: ProfileImageWidget(
                            imagePath: state.profileEntity.profileImage,
                          ),
                        ),
                        StatusBadgeWidget(
                          status: state.profileEntity.accountStatus,
                        ),
                      ],
                    ),
                    // Items
                    BuildSettingDrawerItem(
                      icon: Icons.person,
                      title: LocaleKeys.mainLayoutDrawerShowProfile.tr(),
                      route: AppRoutes.profileScreen,
                    ),
                    if (isOwner || becomeOwner) ...[
                      BuildSettingDrawerItem(
                        icon: Icons.list,
                        title: LocaleKeys.mainLayoutDrawerMyProperties.tr(),
                        route: AppRoutes.myPropertiesScreen,
                      ),
                      BuildSettingDrawerItem(
                        icon: Icons.home_work,
                        title: LocaleKeys.mainLayoutDrawerOwnerDashboard.tr(),
                        route: AppRoutes.ownerDashboardScreen,
                      ),
                    ],
                    BuildSettingDrawerItem(
                      icon: Icons.favorite,
                      title: LocaleKeys.mainLayoutDrawerFavorites.tr(),
                      route: AppRoutes.favoritesPropertyManageScreen,
                    ),
                    BuildSettingDrawerItem(
                      icon: Icons.add,
                      title: LocaleKeys.mainLayoutDrawerAddProperty.tr(),
                      route: AppRoutes.addPropertyManageScreen,
                    ),
                    // BuildSettingDrawerItem(
                    //   icon: Icons.description,
                    //   title: "Contracts",
                    //   route: AppRoutes.blankScreen,
                    // ),
                    BuildSettingDrawerItem(
                      icon: Icons.settings,
                      title: LocaleKeys.mainLayoutDrawerSettings.tr(),
                      route: AppRoutes.settingScreen,
                    ),
                  ],
                );
              } else {
                return buildLoading();
              }
            },
          );
        },
      ),
    );
  }
}
