import 'dart:io';
import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/profile/data/data_sources/profile_service.dart';
import 'package:MARN/features/profile/domain/entities/profile_entity.dart';
import 'package:MARN/features/profile/domain/entities/profile_settings_entity.dart';
import 'package:MARN/features/profile/domain/repositories/profile_repo.dart';
import 'package:dartz/dartz.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileService profileService;

  ProfileRepoImpl({required this.profileService});

  @override
  Future<Either<Failure, ProfileEntity>> getMyProfile() async {
    try {
      ProfileEntity profileEntity = await profileService.getMyProfile();
      return right(profileEntity);
    } catch (e) {
      return left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> getMyProfileFromLocalStorage() async {
    try {
      ProfileEntity profileEntity = await profileService
          .getMyProfileFromLocalStorage();
      return right(profileEntity);
    } catch (e) {
      return left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> getUserProfile({
    required String userId,
  }) async {
    try {
      ProfileEntity userProfileEntity = await profileService.getUserProfile(
        userId: userId,
      );
      return right(userProfileEntity);
    } catch (e) {
      return left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, String>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      String message = await profileService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
      return right(message);
    } catch (e) {
      return left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, String>> toggleTwoFactorAuth({
    required String password,
  }) async {
    try {
      String message = await profileService.toggleTwoFactorAuth(
        password: password,
      );
      return right(message);
    } catch (e) {
      return left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, ProfileSettingsEntity>>
  getProfileSettingsInfo() async {
    try {
      ProfileSettingsEntity profileSettingsEntity = await profileService
          .getProfileSettingsInfo();
      return right(profileSettingsEntity);
    } catch (e) {
      return left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, ProfileSettingsEntity>>
  getProfileSettingsInfoFromLocalStorage() async {
    try {
      ProfileSettingsEntity profileSettingsEntity = await profileService
          .getProfileSettingsInfoFromLocalStorage();
      return right(profileSettingsEntity);
    } catch (e) {
      return left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, String>> editBasicProfile({
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
    try {
      String message = await profileService.editBasicProfile(
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
      return right(message);
    } catch (e) {
      return left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, String>> editIdentityProfile({
    required File frontIdImage,
    required File backIdImage,
    required String nationalIDNumber,
    required String arabicFullName,
    required String arabicAddress,
  }) async {
    try {
      String message = await profileService.editIdentityProfile(
        frontIdImage: frontIdImage,
        backIdImage: backIdImage,
        nationalIDNumber: nationalIDNumber,
        arabicFullName: arabicFullName,
        arabicAddress: arabicAddress,
      );
      return right(message);
    } catch (e) {
      return left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, String>> editProfileRoommatePreferences({
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
    try {
      String message = await profileService.editProfileRoommatePreferences(
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
      return right(message);
    } catch (e) {
      return left(e as Failure);
    }
  }
}
