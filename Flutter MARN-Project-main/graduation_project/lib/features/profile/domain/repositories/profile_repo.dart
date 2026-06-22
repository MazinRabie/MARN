import 'dart:io';

import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/profile/domain/entities/profile_entity.dart';
import 'package:MARN/features/profile/domain/entities/profile_settings_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepo {
  Future<Either<Failure, ProfileEntity>> getMyProfile();
  Future<Either<Failure, ProfileEntity>> getMyProfileFromLocalStorage();
  Future<Either<Failure, ProfileEntity>> getUserProfile({
    required String userId,
  });
  Future<Either<Failure, String>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });
  Future<Either<Failure, String>> toggleTwoFactorAuth({
    required String password,
  });
  Future<Either<Failure, ProfileSettingsEntity>> getProfileSettingsInfo();
  Future<Either<Failure, ProfileSettingsEntity>>
  getProfileSettingsInfoFromLocalStorage();
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
  });
  Future<Either<Failure, String>> editIdentityProfile({
    required File frontIdImage,
    required File backIdImage,
    required String nationalIDNumber,
    required String arabicFullName,
    required String arabicAddress,
  });
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
  });
}
