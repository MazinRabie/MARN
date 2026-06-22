import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/custom_divider.dart';
import 'package:MARN/core/widgets/enum_select_field.dart.dart';
import 'package:MARN/core/widgets/custom_text_form_field.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/app_bar_widget.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_setting_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class EditRoommatePreferencesScreen extends StatefulWidget {
  const EditRoommatePreferencesScreen({super.key});

  @override
  State<EditRoommatePreferencesScreen> createState() =>
      _EditRoommatePreferencesScreenState();
}

class _EditRoommatePreferencesScreenState
    extends State<EditRoommatePreferencesScreen> {
  late final GlobalKey<FormState> _formKey;

  bool smoking = false;
  bool pets = false;
  int noiseTolerance = 0;
  bool roommatePreferencesEnabled = false;
  int budgetRangeMin = 1000;
  int budgetRangeMax = 1000000000;

  EnumItem selectedEducationLevel = EnumItem.empty;
  EnumItem selectedFieldOfStudy = EnumItem.empty;
  EnumItem selectedGuestsFrequency = EnumItem.empty;
  EnumItem selectedSleepSchedule = EnumItem.empty;
  EnumItem selectedSharingLevel = EnumItem.empty;
  EnumItem selectedWorkSchedule = EnumItem.empty;

  int smokingImportance = 3;
  int petsImportance = 3;
  int sleepImportance = 3;
  int educationImportance = 3;
  int fieldOfStudyImportance = 3;
  int noiseToleranceImportance = 3;
  int guestsFrequencyImportance = 3;
  int workScheduleImportance = 3;
  int sharingLevelImportance = 3;
  int budgetImportance = 3;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileSettingCubit>().getProfileSettingsInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      appBar: appBarWidget(
        context,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
              // style: IconButton.styleFrom(
              //   backgroundColor: AppColors.successSoft,
              // ),
              // icon: const Icon(Icons.check, color: AppColors.white90),
              icon: const Icon(Icons.save_outlined),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context
                      .read<ProfileSettingCubit>()
                      .editProfileRoommatePreferences(
                        roommatePreferencesEnabled: roommatePreferencesEnabled,
                        smoking: smoking,
                        pets: pets,
                        sleepSchedule: selectedSleepSchedule,
                        educationLevel: selectedEducationLevel,
                        fieldOfStudy: selectedFieldOfStudy,
                        noiseTolerance: noiseTolerance,
                        guestsFrequency: selectedGuestsFrequency,
                        workSchedule: selectedWorkSchedule,
                        sharingLevel: selectedSharingLevel,
                        budgetRangeMin: budgetRangeMin,
                        budgetRangeMax: budgetRangeMax,
                        smokingImportance: smokingImportance,
                        petsImportance: petsImportance,
                        sleepImportance: sleepImportance,
                        educationImportance: educationImportance,
                        fieldOfStudyImportance: fieldOfStudyImportance,
                        noiseToleranceImportance: noiseToleranceImportance,
                        guestsFrequencyImportance: guestsFrequencyImportance,
                        workScheduleImportance: workScheduleImportance,
                        sharingLevelImportance: sharingLevelImportance,
                        budgetImportance: budgetImportance,
                      );
                }
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<ProfileSettingCubit, ProfileSettingState>(
          listener: (context, state) {
            if (state is GetProfileSettingsInfoLoaded) {
              final data = state.profileSettingsEntity;
              roommatePreferencesEnabled = data.roommatePreferencesEnabled;
              budgetRangeMax = data.budgetRangeMax?.toInt() ?? 1000000000;
              budgetRangeMin = data.budgetRangeMin?.toInt() ?? 1000;
              smoking = data.smoking ?? false;
              pets = data.pets ?? false;
              noiseTolerance = data.noiseTolerance ?? 0;
              selectedEducationLevel = data.educationLevel ?? EnumItem.empty;
              selectedFieldOfStudy = data.fieldOfStudy ?? EnumItem.empty;
              selectedGuestsFrequency = data.guestsFrequency ?? EnumItem.empty;
              selectedSleepSchedule = data.sleepSchedule ?? EnumItem.empty;
              selectedSharingLevel = data.sharingLevel ?? EnumItem.empty;
              selectedWorkSchedule = data.workSchedule ?? EnumItem.empty;

              smokingImportance = data.smokingImportance ?? 3;
              petsImportance = data.petsImportance ?? 3;
              sleepImportance = data.sleepImportance ?? 3;
              educationImportance = data.educationImportance ?? 3;
              fieldOfStudyImportance = data.fieldOfStudyImportance ?? 3;
              noiseToleranceImportance = data.noiseToleranceImportance ?? 3;
              guestsFrequencyImportance = data.guestsFrequencyImportance ?? 3;
              workScheduleImportance = data.workScheduleImportance ?? 3;
              sharingLevelImportance = data.sharingLevelImportance ?? 3;
              budgetImportance = data.budgetImportance ?? 3;
            }
            if (state is SettingsError) {
              buildSnackBar(
                context,
                message: state.errorMessage,
                isError: true,
              );
            }
            if (state is EditProfileRoommatePreferencesSuccess) {
              buildSnackBar(context, message: state.message, isError: false);
              context.read<ProfileCubit>().getMyProfile();
            }
          },
          builder: (context, state) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: SingleChildScrollView(
                    child: CustomGeneralContainer(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                LocaleKeys.profileRoommateVisibilityTitle.tr(),
                                style: AppTextStyles.bodyLarge,
                              ),
                              subtitle: Text(
                                LocaleKeys.profileRoommateVisibilitySubtitle.tr(),
                                style: AppTextStyles.bodySmall,
                              ),
                              value: roommatePreferencesEnabled,
                              onChanged: (value) {
                                setState(() {
                                  roommatePreferencesEnabled = value;
                                });
                              },
                            ),
                  
                            const SizedBox(height: 10),
                            CustomDivider(
                              text: LocaleKeys.profileRoommateBudgetRange.tr(),
                            ),
                            const SizedBox(height: 10),
                  
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextFormField(
                                    type: CustomTextFormFieldType.number,
                                    prefixIcon: Icons.money,
                                    hintText: LocaleKeys.profileRoommateMinBudget
                                        .tr(),
                                    labelText: LocaleKeys.profileRoommateMinBudget
                                        .tr(),
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return LocaleKeys
                                            .profileValidationMinBudgetRequired
                                            .tr();
                                      }
                                      return null;
                                    },
                                    initialValue: budgetRangeMin.toString(),
                                    onChanged: (val) {
                                      setState(() {
                                        budgetRangeMin = int.tryParse(val) ?? 0;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: CustomTextFormField(
                                    type: CustomTextFormFieldType.number,
                                    prefixIcon: Icons.money,
                                    labelText: LocaleKeys.profileRoommateMaxBudget
                                        .tr(),
                                    hintText: LocaleKeys.profileRoommateMaxBudget
                                        .tr(),
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return LocaleKeys
                                            .profileValidationMaxBudgetRequired
                                            .tr();
                                      }
                                      return null;
                                    },
                                    initialValue: budgetRangeMax.toString(),
                                    onChanged: (val) {
                                      setState(() {
                                        budgetRangeMax = int.tryParse(val) ?? 0;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _ImportanceRating(
                              value: budgetImportance,
                              onChanged: (val) =>
                                  setState(() => budgetImportance = val),
                            ),
                  
                            const SizedBox(height: 10),
                            CustomDivider(
                              text: LocaleKeys.profileRoommatePreferencesLifestyle
                                  .tr(),
                            ),
                            const SizedBox(height: 10),
                  
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    LocaleKeys.profileRoommateSmokingLabel.tr(),
                                    style: AppTextStyles.bodyLarge,
                                  ),
                                  Icon(
                                    smoking
                                        ? Icons.smoking_rooms
                                        : Icons.smoke_free,
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                smoking
                                    ? LocaleKeys.profileRoommateISmoke.tr()
                                    : LocaleKeys.profileRoommateNonSmoker.tr(),
                                style: AppTextStyles.bodySmall,
                              ),
                              value: smoking,
                              onChanged: (value) {
                                setState(() {
                                  smoking = value;
                                });
                              },
                            ),
                            const SizedBox(height: 5),
                            _ImportanceRating(
                              value: smokingImportance,
                              onChanged: (val) =>
                                  setState(() => smokingImportance = val),
                            ),
                  
                            const SizedBox(height: 10),
                  
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    LocaleKeys.profileRoommatePetsLabel.tr(),
                                    style: AppTextStyles.bodyLarge,
                                  ),
                                  Icon(pets ? Icons.pets : Icons.block),
                                ],
                              ),
                              subtitle: Text(
                                pets
                                    ? LocaleKeys.profileRoommatePetFriendly.tr()
                                    : LocaleKeys.profileRoommateNotPetFriendly
                                          .tr(),
                                style: AppTextStyles.bodySmall,
                              ),
                              value: pets,
                              onChanged: (value) {
                                setState(() {
                                  pets = value;
                                });
                              },
                            ),
                            const SizedBox(height: 5),
                            _ImportanceRating(
                              value: petsImportance,
                              onChanged: (val) =>
                                  setState(() => petsImportance = val),
                            ),
                  
                            const SizedBox(height: 10),
                  
                            EnumSelectField(
                              labelText: LocaleKeys.profileInfoSleepSchedule.tr(),
                              enumType: EnumType.sleepSchedules,
                              initialValue: selectedSleepSchedule,
                              onChanged: (value) {
                                if (value != null) selectedSleepSchedule = value;
                              },
                            ),
                            const SizedBox(height: 5),
                            _ImportanceRating(
                              value: sleepImportance,
                              onChanged: (val) =>
                                  setState(() => sleepImportance = val),
                            ),
                  
                            const SizedBox(height: 10),
                            CustomDivider(
                              text: LocaleKeys.profileRoommateEducation.tr(),
                            ),
                            const SizedBox(height: 10),
                  
                            EnumSelectField(
                              labelText: LocaleKeys.profileRoommateEducationLevel
                                  .tr(),
                              enumType: EnumType.educationLevels,
                              initialValue: selectedEducationLevel,
                              onChanged: (value) {
                                if (value != null) selectedEducationLevel = value;
                              },
                            ),
                            const SizedBox(height: 5),
                            _ImportanceRating(
                              value: educationImportance,
                              onChanged: (val) =>
                                  setState(() => educationImportance = val),
                            ),
                  
                            const SizedBox(height: 10),
                  
                            EnumSelectField(
                              labelText: LocaleKeys.profileRoommateFieldOfStudy
                                  .tr(),
                              enumType: EnumType.fieldsOfStudy,
                              initialValue: selectedFieldOfStudy,
                              onChanged: (value) {
                                if (value != null) selectedFieldOfStudy = value;
                              },
                            ),
                            const SizedBox(height: 5),
                            _ImportanceRating(
                              value: fieldOfStudyImportance,
                              onChanged: (val) =>
                                  setState(() => fieldOfStudyImportance = val),
                            ),
                  
                            const SizedBox(height: 10),
                            CustomDivider(
                              text: LocaleKeys.profileRoommateSocialWork.tr(),
                            ),
                            const SizedBox(height: 10),
                  
                            Row(
                              children: [
                                Text(
                                  LocaleKeys.profileRoommateNoiseTolerance.tr(),
                                  style: AppTextStyles.bodyLarge,
                                ),
                              ],
                            ),
                  
                            const SizedBox(height: 8),
                  
                            Slider(
                              value: noiseTolerance.toDouble().clamp(1.0, 5.0),
                              min: 1,
                              max: 5,
                              divisions: 4,
                              label: noiseTolerance.clamp(1, 5).toString(),
                              activeColor: AppColors.primary,
                              inactiveColor: AppColors.border,
                              onChanged: (value) {
                                setState(() {
                                  noiseTolerance = value.toInt();
                                });
                              },
                            ),
                            const SizedBox(height: 5),
                            _ImportanceRating(
                              value: noiseToleranceImportance,
                              onChanged: (val) =>
                                  setState(() => noiseToleranceImportance = val),
                            ),
                  
                            const SizedBox(height: 10),
                  
                            EnumSelectField(
                              labelText: LocaleKeys.profileRoommateGuestsFrequency
                                  .tr(),
                              enumType: EnumType.guestsFrequencies,
                              initialValue: selectedGuestsFrequency,
                              onChanged: (value) {
                                if (value != null) {
                                  selectedGuestsFrequency = value;
                                }
                              },
                            ),
                            const SizedBox(height: 5),
                            _ImportanceRating(
                              value: guestsFrequencyImportance,
                              onChanged: (val) =>
                                  setState(() => guestsFrequencyImportance = val),
                            ),
                  
                            const SizedBox(height: 10),
                  
                            EnumSelectField(
                              labelText: LocaleKeys.profileRoommateSharingLevel
                                  .tr(),
                              enumType: EnumType.sharingLevels,
                              initialValue: selectedSharingLevel,
                              onChanged: (value) {
                                if (value != null) selectedSharingLevel = value;
                              },
                            ),
                            const SizedBox(height: 5),
                            _ImportanceRating(
                              value: sharingLevelImportance,
                              onChanged: (val) =>
                                  setState(() => sharingLevelImportance = val),
                            ),
                  
                            const SizedBox(height: 10),
                  
                            EnumSelectField(
                              labelText: LocaleKeys.profileRoommateWorkSchedule
                                  .tr(),
                              enumType: EnumType.workSchedules,
                              initialValue: selectedWorkSchedule,
                              onChanged: (value) {
                                if (value != null) selectedWorkSchedule = value;
                              },
                            ),
                            const SizedBox(height: 5),
                            _ImportanceRating(
                              value: workScheduleImportance,
                              onChanged: (val) =>
                                  setState(() => workScheduleImportance = val),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                if (state is SettingsLoading) Center(child: buildLoading()),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ImportanceRating extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _ImportanceRating({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.profileRoommateImportance.tr(),
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final starValue = index + 1;
            final isSelected = starValue <= value;
            return GestureDetector(
              onTap: () => onChanged(starValue),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Center(
                  child: Text(
                    starValue.toString(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isSelected ? AppColors.white : AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
