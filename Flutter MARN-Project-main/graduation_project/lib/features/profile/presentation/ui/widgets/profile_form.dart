import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/routes/routes.dart';
import 'package:MARN/core/services/shared_preferences_helper.dart';
import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/enums/utils/enum_helper.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/app_bar_widget.dart';
import 'package:MARN/core/widgets/profile_image_widget.dart';
import 'package:MARN/features/profile/domain/entities/profile_entity.dart';
import 'package:MARN/features/property/presentation/ui/widgets/property_card.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/show_report_dialog.dart';
import 'package:MARN/core/widgets/status_badge_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MARN/core/widgets/top_bounce_only_scroll_physics.dart';

class ProfileForm extends StatelessWidget {
  final ProfileEntity profileEntity;
  final bool isMyProfile;

  const ProfileForm({
    super.key,
    required this.profileEntity,
    required this.isMyProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      appBar: appBarWidget(
        context,
        actions:
            profileEntity.id !=
                SharedPreferencesHelper.getString(LocalStorageVariables.userId)
            ? [
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == "ChatWith") {
                      context.push(
                        AppRoutes.chatScreen,
                        extra: ChatScreenArguments(userId: profileEntity.id),
                      );
                    } else if (value == "Report") {
                      showReportDialog(
                        context,
                        reportableType:
                            EnumHelper.getEnum(
                              context,
                              EnumType.reportableTypes,
                            )?.firstWhere(
                              (e) => e.name.toLowerCase() == 'user',
                              orElse: () => EnumItem(
                                id: 0,
                                name: 'user',
                                displayName: 'User',
                              ),
                            ) ??
                            EnumItem(id: 0, name: 'user', displayName: 'User'),
                        reportableTargetId: profileEntity.id,
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "ChatWith",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(LocaleKeys.profileMenuChat.tr()),
                          const Icon(Icons.chat),
                        ],
                      ),
                    ),

                    PopupMenuItem(
                      value: "Report",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(LocaleKeys.profileMenuReport.tr()),
                          const Icon(Icons.report),
                        ],
                      ),
                    ),
                  ],
                ),
              ]
            : [],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          if (isMyProfile) {
            await context.read<ProfileCubit>().getMyProfile();
          } else {
            await context.read<ProfileCubit>().getUserProfile(
              userId: profileEntity.id,
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            physics: const TopBounceOnlyScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
            ),
            child: CustomGeneralContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ProfileImageWidget(
                              imagePath: profileEntity.profileImage,
                              radius: 100,
                            ),
                            if (isMyProfile)
                              Positioned(
                                bottom: 0,
                                child: StatusBadgeWidget(
                                  status: profileEntity.accountStatus,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          profileEntity.fullName,
                          style: AppTextStyles.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          profileEntity.email,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                        if (profileEntity.isOwner) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    LocaleKeys.profileStatisticsReviewsCount.tr(
                                      args: [
                                        (profileEntity.averageRating ?? 0)
                                            .toStringAsFixed(1),
                                        (profileEntity.ratingsCount ?? 0)
                                            .toStringAsFixed(1),
                                      ],
                                    ),
                                    style: AppTextStyles.labelLarge,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.house,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    LocaleKeys.profileStatisticsPropertiesCount
                                        .tr(
                                          args: [
                                            (profileEntity.ownedPropertiesCount ??
                                                    0)
                                                .toString(),
                                          ],
                                        ),
                                    style: AppTextStyles.labelLarge,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
          
                  // Info
                  if (profileEntity.bio != null &&
                      profileEntity.bio!.isNotEmpty) ...[
                    _buildSectionTitle(LocaleKeys.profileSectionsAboutMe.tr()),
                    const SizedBox(height: 8),
                    Text(profileEntity.bio!, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 24),
                  ],
          
                  _buildSectionTitle(LocaleKeys.profileSectionsGeneralInfo.tr()),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.cake,
                    LocaleKeys.profileInfoDob.tr(),
                    profileEntity.dateOfBirth?.split('T').first ??
                        LocaleKeys.profileInfoNa.tr(),
                  ),
                  _buildInfoRow(
                    Icons.person_outline,
                    LocaleKeys.profileInfoGender.tr(),
                    profileEntity.gender.displayName,
                  ),
                  _buildInfoRow(
                    Icons.public,
                    LocaleKeys.profileInfoCountry.tr(),
                    profileEntity.country.displayName,
                  ),
                  _buildInfoRow(
                    Icons.calendar_today,
                    LocaleKeys.profileInfoMemberSince.tr(),
                    profileEntity.memberSince.split('T').first,
                  ),
          
                  if (profileEntity.roommatePreferencesEnabled) ...[
                    const SizedBox(height: 24),
                    _buildSectionTitle(
                      LocaleKeys.profileSectionsRoommatePreferences.tr(),
                    ),
                    if (profileEntity.matchingPercentage != null) ...[
                      const SizedBox(height: 8),
                      _buildRoommateMatchingSection(context),
                    ],
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.smoking_rooms,
                      LocaleKeys.profileInfoSmoking.tr(),
                      profileEntity.smoking == true
                          ? LocaleKeys.profileInfoYes.tr()
                          : LocaleKeys.profileInfoNo.tr(),
                    ),
                    _buildInfoRow(
                      Icons.pets,
                      LocaleKeys.profileInfoPets.tr(),
                      profileEntity.pets == true
                          ? LocaleKeys.profileInfoYes.tr()
                          : LocaleKeys.profileInfoNo.tr(),
                    ),
                    _buildInfoRow(
                      Icons.nights_stay,
                      LocaleKeys.profileInfoSleepSchedule.tr(),
                      profileEntity.sleepSchedule.displayName.isNotEmpty
                          ? profileEntity.sleepSchedule.displayName
                          : LocaleKeys.profileInfoNa.tr(),
                    ),
                    _buildInfoRow(
                      Icons.school,
                      LocaleKeys.profileInfoEducationLevel.tr(),
                      profileEntity.educationLevel.displayName.isNotEmpty
                          ? profileEntity.educationLevel.displayName
                          : LocaleKeys.profileInfoNa.tr(),
                    ),
                    _buildInfoRow(
                      Icons.book,
                      LocaleKeys.profileInfoFieldOfStudy.tr(),
                      profileEntity.fieldOfStudy.displayName.isNotEmpty
                          ? profileEntity.fieldOfStudy.displayName
                          : LocaleKeys.profileInfoNa.tr(),
                    ),
                    _buildInfoRow(
                      Icons.volume_up,
                      LocaleKeys.profileInfoNoiseTolerance.tr(),
                      profileEntity.noiseTolerance?.toString() ??
                          LocaleKeys.profileInfoNa.tr(),
                    ),
                    _buildInfoRow(
                      Icons.people,
                      LocaleKeys.profileInfoGuestsFrequency.tr(),
                      profileEntity.guestsFrequency.displayName.isNotEmpty
                          ? profileEntity.guestsFrequency.displayName
                          : LocaleKeys.profileInfoNa.tr(),
                    ),
                    _buildInfoRow(
                      Icons.work,
                      LocaleKeys.profileInfoWorkSchedule.tr(),
                      profileEntity.workSchedule.displayName.isNotEmpty
                          ? profileEntity.workSchedule.displayName
                          : LocaleKeys.profileInfoNa.tr(),
                    ),
                    _buildInfoRow(
                      Icons.share,
                      LocaleKeys.profileInfoSharingLevel.tr(),
                      profileEntity.sharingLevel.displayName.isNotEmpty
                          ? profileEntity.sharingLevel.displayName
                          : LocaleKeys.profileInfoNa.tr(),
                    ),
                    _buildInfoRow(
                      Icons.attach_money,
                      LocaleKeys.profileInfoBudgetRange.tr(),
                      LocaleKeys.profileRoommateBudgetValue.tr(
                        args: [
                          (profileEntity.budgetRangeMin ?? 0).toString(),
                          (profileEntity.budgetRangeMax ?? 0).toString(),
                        ],
                      ),
                    ),
                  ],
          
                  if (profileEntity.ownedProperties != null &&
                      profileEntity.ownedProperties!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildSectionTitle(LocaleKeys.profileSectionsProperties.tr()),
                    const SizedBox(height: 16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: profileEntity.ownedProperties!.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final property = profileEntity.ownedProperties![index];
                        return PropertyCard(property: property, index: index);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                Text(value, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoommateMatchingSection(BuildContext context) {
    final score = profileEntity.matchingPercentage ?? 0.0;
    final scoreColor = score >= 80
        ? AppColors.success
        : (score >= 50 ? AppColors.warning : AppColors.error);

    return CustomGeneralContainer(
      margin: EdgeInsets.zero,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: scoreColor.withOpacity(0.3), width: 3),
            ),
            child: CircleAvatar(
              radius: 26,
              backgroundColor: scoreColor.withOpacity(0.1),
              child: Text(
                "${score.toStringAsFixed(0)}%",
                style: AppTextStyles.titleMedium.copyWith(
                  color: scoreColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.roommateCompatibility.tr(),
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  score >= 80
                      ? LocaleKeys.roommateCompatibilityHigh.tr()
                      : (score >= 50
                            ? LocaleKeys.roommateCompatibilityMedium.tr()
                            : LocaleKeys.roommateCompatibilityLow.tr()),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
