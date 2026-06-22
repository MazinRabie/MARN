import 'dart:io';

import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/features/profile/domain/entities/profile_settings_entity.dart';
import 'package:MARN/features/profile/domain/repositories/profile_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'profile_setting_state.dart';

class ProfileSettingCubit extends Cubit<ProfileSettingState> {
  ProfileSettingCubit({required this.profileRepo})
    : super(ProfileSettingInitial());

  final ProfileRepo profileRepo;

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    emit(SettingsLoading());
    var result = await profileRepo.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );
    result.fold(
      (failure) {
        emit(SettingsError(errorMessage: failure.errorMessage));
      },
      (message) {
        emit(ChangePasswordSuccess(message: message));
      },
    );
  }

  Future<void> toggleTwoFactorAuth({required String password}) async {
    emit(SettingsLoading());
    var result = await profileRepo.toggleTwoFactorAuth(password: password);
    result.fold(
      (failure) {
        emit(SettingsError(errorMessage: failure.errorMessage));
      },
      (message) {
        emit(ToggleTwoFactorAuthSuccess(message: message));
      },
    );
  }

  Future<void> getProfileSettingsInfo() async {
    emit(SettingsLoading());
    var result = await profileRepo.getProfileSettingsInfo();
    result.fold(
      (failure) {
        emit(SettingsError(errorMessage: failure.errorMessage));
      },
      (profileSettingsEntity) {
        emit(
          GetProfileSettingsInfoLoaded(
            profileSettingsEntity: profileSettingsEntity,
          ),
        );
      },
    );
  }

  Future<void> getProfileSettingsInfoFromLocalStorage() async {
    emit(SettingsLoading());
    var result = await profileRepo.getProfileSettingsInfoFromLocalStorage();
    result.fold(
      (failure) {
        emit(SettingsError(errorMessage: failure.errorMessage));
      },
      (profileSettingsEntity) {
        emit(
          GetProfileSettingsInfoLoaded(
            profileSettingsEntity: profileSettingsEntity,
          ),
        );
      },
    );
  }

  Future<void> editBasicProfile({
    required String firstName,
    required String lastName,
    required String? phoneNumber,
    required DateTime? dateOfBirth,
    required EnumItem gender,
    required EnumItem language,
    required EnumItem country,
    required String? bio,
    required File? profileImage,
  }) async {
    emit(SettingsLoading());
    var result = await profileRepo.editBasicProfile(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      gender: gender,
      language: language,
      country: country,
      bio: bio,
      profileImage: profileImage,
    );
    result.fold(
      (failure) {
        emit(SettingsError(errorMessage: failure.errorMessage));
      },
      (message) {
        emit(EditBasicProfileSuccess(message: message));
      },
    );
  }

  Future<void> editIdentityProfile({
    required File frontIdImage,
    required File backIdImage,
    required String nationalIDNumber,
    required String arabicFullName,
    required String arabicAddress,
  }) async {
    emit(SettingsLoading());
    var result = await profileRepo.editIdentityProfile(
      frontIdImage: frontIdImage,
      backIdImage: backIdImage,
      nationalIDNumber: nationalIDNumber,
      arabicFullName: arabicFullName,
      arabicAddress: arabicAddress,
    );
    result.fold(
      (failure) {
        emit(SettingsError(errorMessage: failure.errorMessage));
      },
      (message) {
        emit(EditIdentityProfileSuccess(message: message));
      },
    );
  }

  Future<void> editProfileRoommatePreferences({
    required bool roommatePreferencesEnabled,
    required bool? smoking,
    required bool? pets,
    required EnumItem? sleepSchedule,
    required EnumItem? educationLevel,
    required EnumItem? fieldOfStudy,
    required int? noiseTolerance,
    required EnumItem? guestsFrequency,
    required EnumItem? workSchedule,
    required EnumItem? sharingLevel,
    required num? budgetRangeMin,
    required num? budgetRangeMax,
    required int? smokingImportance,
    required int? petsImportance,
    required int? sleepImportance,
    required int? educationImportance,
    required int? fieldOfStudyImportance,
    required int? noiseToleranceImportance,
    required int? guestsFrequencyImportance,
    required int? workScheduleImportance,
    required int? sharingLevelImportance,
    required int? budgetImportance,
  }) async {
    emit(SettingsLoading());
    var result = await profileRepo.editProfileRoommatePreferences(
      roommatePreferencesEnabled: roommatePreferencesEnabled,
      smoking: smoking,
      pets: pets,
      sleepSchedule: sleepSchedule,
      educationLevel: educationLevel,
      fieldOfStudy: fieldOfStudy,
      noiseTolerance: noiseTolerance,
      guestsFrequency: guestsFrequency,
      workSchedule: workSchedule,
      sharingLevel: sharingLevel,
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
    result.fold(
      (failure) {
        emit(SettingsError(errorMessage: failure.errorMessage));
      },
      (message) {
        emit(EditProfileRoommatePreferencesSuccess(message: message));
      },
    );
  }
}
