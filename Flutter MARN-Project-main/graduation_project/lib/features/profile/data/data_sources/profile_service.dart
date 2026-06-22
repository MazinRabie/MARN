import 'dart:io';
import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/features/profile/data/model/profile_model.dart';
import 'package:MARN/features/profile/data/model/profile_settings_model.dart';

abstract class ProfileService {
  Future<ProfileModel> getMyProfile();

  Future<ProfileModel> getMyProfileFromLocalStorage();

  Future<ProfileModel> getUserProfile({required String userId});

  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });

  Future<String> toggleTwoFactorAuth({required String password});

  Future<ProfileSettingsModel> getProfileSettingsInfo();

  Future<ProfileSettingsModel> getProfileSettingsInfoFromLocalStorage();

  Future<String> editBasicProfile({
    required String firstName,
    required String lastName,
    required String? phoneNumber,
    required DateTime? dateOfBirth,
    required EnumItem gender,
    required EnumItem language,
    required EnumItem country,
    required String? bio,
    required File? profileImage,
  });

  Future<String> editIdentityProfile({
    required File frontIdImage,
    required File backIdImage,
    required String nationalIDNumber,
    required String arabicFullName,
    required String arabicAddress,
  });

  Future<String> editProfileRoommatePreferences({
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
  });
}
