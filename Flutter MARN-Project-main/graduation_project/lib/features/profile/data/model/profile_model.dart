import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/widgets/buildImage_url.dart';
import 'package:MARN/features/profile/domain/entities/profile_entity.dart';
import 'package:MARN/features/property/data/models/viewer_property_card_model.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.profileImage,
    required super.accountStatus,
    required super.dateOfBirth,
    required super.gender,
    required super.country,
    required super.memberSince,
    required super.bio,
    required super.isOwner,
    required super.averageRating,
    required super.ratingsCount,
    required super.ownedPropertiesCount,
    required super.ownedProperties,
    required super.roommatePreferencesEnabled,
    required super.smoking,
    required super.pets,
    required super.sleepSchedule,
    required super.educationLevel,
    required super.fieldOfStudy,
    required super.noiseTolerance,
    required super.guestsFrequency,
    required super.workSchedule,
    required super.sharingLevel,
    required super.budgetRangeMin,
    required super.budgetRangeMax,
    super.matchingPercentage,
    super.topMatchingTraits,
    super.mismatchedTraits,
    super.dealbreakersFound,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return ProfileModel(
      id: data['id'],
      fullName: data['fullName'],
      email: data['email'],
      profileImage: buildImageUrl(data['profileImage']),
      accountStatus: EnumItem.resolve(
        EnumType.accountStatuses,
        data['accountStatus'],
      ),
      dateOfBirth: data['dateOfBirth'],
      gender: EnumItem.resolve(EnumType.gender, data['gender']),
      country: EnumItem.resolve(EnumType.countries, data['country']),
      memberSince: data['memberSince'],
      bio: data['bio'],
      isOwner: data['isOwner'],
      averageRating: data['averageRating'],
      ratingsCount: data['ratingsCount'],
      ownedPropertiesCount: data['ownedPropertiesCount'],
      ownedProperties: data['ownedProperties'] != null
          ? (data['ownedProperties'] as List)
                .map((e) => ViewerPropertyCardModel.fromJson(e))
                .toList()
          : [],
      roommatePreferencesEnabled: data['roommatePreferencesEnabled'],
      smoking: data['smoking'],
      pets: data['pets'],
      sleepSchedule: EnumItem.resolve(
        EnumType.sleepSchedules,
        data['sleepSchedule'],
      ),
      educationLevel: EnumItem.resolve(
        EnumType.educationLevels,
        data['educationLevel'],
      ),
      fieldOfStudy: EnumItem.resolve(
        EnumType.fieldsOfStudy,
        data['fieldOfStudy'],
      ),
      noiseTolerance: data['noiseTolerance'],
      guestsFrequency: EnumItem.resolve(
        EnumType.guestsFrequencies,
        data['guestsFrequency'],
      ),
      workSchedule: EnumItem.resolve(
        EnumType.workSchedules,
        data['workSchedule'],
      ),
      sharingLevel: EnumItem.resolve(
        EnumType.sharingLevels,
        data['sharingLevel'],
      ),
      budgetRangeMin: data['budgetRangeMin'],
      budgetRangeMax: data['budgetRangeMax'],
      matchingPercentage:
          (data['matchingPercentage'] ?? data['MatchingPercentage'] as num?)
              ?.toDouble(),
      topMatchingTraits: data['topMatchingTraits'] != null
          ? List<String>.from(data['topMatchingTraits'])
          : null,
      mismatchedTraits: data['mismatchedTraits'] != null
          ? List<String>.from(data['mismatchedTraits'])
          : null,
      dealbreakersFound: data['dealbreakersFound'] != null
          ? List<String>.from(data['dealbreakersFound'])
          : null,
    );
  }
}
