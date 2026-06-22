import 'package:MARN/core/enums/models/enum_item.dart';

abstract class ProfileSettingsEntity {
  // Basic Info
  final String id;
  final String email;
  final String? phoneNumber;
  final String firstName;
  final String lastName;
  final String? dateOfBirth;
  final EnumItem language;
  final String? profileImage;
  final EnumItem gender;
  final EnumItem country;
  final String? bio;
  final bool twoFactorEnabled;

  // Verification Info
  final String? frontIdPhoto;
  final String? backIdPhoto;
  final String? arabicAddress;
  final String? arabicFullName;
  final String? nationalIDNumber;

  // Roommate Preferences
  final bool roommatePreferencesEnabled;
  final bool? smoking;
  final bool? pets;
  final EnumItem? sleepSchedule;
  final EnumItem? educationLevel;
  final EnumItem? fieldOfStudy;
  final int? noiseTolerance;
  final EnumItem? guestsFrequency;
  final EnumItem? workSchedule;
  final EnumItem? sharingLevel;
  final num? budgetRangeMin;
  final num? budgetRangeMax;

  // Importance levels
  final int? smokingImportance;
  final int? petsImportance;
  final int? sleepImportance;
  final int? educationImportance;
  final int? fieldOfStudyImportance;
  final int? noiseToleranceImportance;
  final int? guestsFrequencyImportance;
  final int? workScheduleImportance;
  final int? sharingLevelImportance;
  final int? budgetImportance;

  ProfileSettingsEntity({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.language,
    required this.profileImage,
    required this.gender,
    required this.country,
    required this.bio,
    required this.twoFactorEnabled,
    required this.frontIdPhoto,
    required this.backIdPhoto,
    required this.arabicAddress,
    required this.arabicFullName,
    required this.nationalIDNumber,
    required this.roommatePreferencesEnabled,
    required this.smoking,
    required this.pets,
    required this.sleepSchedule,
    required this.educationLevel,
    required this.fieldOfStudy,
    required this.noiseTolerance,
    required this.guestsFrequency,
    required this.workSchedule,
    required this.sharingLevel,
    required this.budgetRangeMin,
    required this.budgetRangeMax,
    required this.smokingImportance,
    required this.petsImportance,
    required this.sleepImportance,
    required this.educationImportance,
    required this.fieldOfStudyImportance,
    required this.noiseToleranceImportance,
    required this.guestsFrequencyImportance,
    required this.workScheduleImportance,
    required this.sharingLevelImportance,
    required this.budgetImportance,
  });
}
