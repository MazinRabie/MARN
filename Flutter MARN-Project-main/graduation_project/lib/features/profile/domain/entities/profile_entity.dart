import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/features/property/domain/entities/card/viewer_property_card_entity.dart';

abstract class ProfileEntity {
  final String id;
  final String fullName;
  final String email;
  final String? profileImage;
  final EnumItem accountStatus;
  final String? dateOfBirth;
  final EnumItem gender;
  final EnumItem country;
  final String memberSince;
  final String? bio;

  // Owner Data
  final bool isOwner;
  final num? averageRating;
  final int? ratingsCount;
  final int? ownedPropertiesCount;
  final List<ViewerPropertyCardEntity>? ownedProperties;

  // Roommate Preferences
  final bool roommatePreferencesEnabled;
  final bool? smoking;
  final bool? pets;
  final EnumItem sleepSchedule;
  final EnumItem educationLevel;
  final EnumItem fieldOfStudy;
  final int? noiseTolerance;
  final EnumItem guestsFrequency;
  final EnumItem workSchedule;
  final EnumItem sharingLevel;
  final num? budgetRangeMin;
  final num? budgetRangeMax;

  // Roommate Matches
  final double? matchingPercentage;
  final List<String>? topMatchingTraits;
  final List<String>? mismatchedTraits;
  final List<String>? dealbreakersFound;

  ProfileEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profileImage,
    required this.accountStatus,
    required this.dateOfBirth,
    required this.gender,
    required this.country,
    required this.memberSince,
    required this.bio,
    required this.isOwner,
    required this.averageRating,
    required this.ratingsCount,
    required this.ownedPropertiesCount,
    required this.ownedProperties,
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
    this.matchingPercentage,
    this.topMatchingTraits,
    this.mismatchedTraits,
    this.dealbreakersFound,
  });
}
