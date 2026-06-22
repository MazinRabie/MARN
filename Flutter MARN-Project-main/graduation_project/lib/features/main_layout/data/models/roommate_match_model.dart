import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/widgets/buildImage_url.dart';
import 'package:MARN/features/main_layout/domain/entities/roommate_match_entity.dart';

class RoommateMatchModel extends RoommateMatchEntity {
  RoommateMatchModel({
    required super.userId,
    required super.fullName,
    super.profileImage,
    required super.compatibilityScore,
    required super.searchStatus,
    required super.badge,
    required super.topMatchingTraits,
    required super.mismatchedTraits,
    required super.dealbreakersFound,
  });

  factory RoommateMatchModel.fromJson(Map<String, dynamic> json) {
    return RoommateMatchModel(
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      profileImage: buildImageUrl(json['profileImage']),
      compatibilityScore:
          (json['compatibilityScore'] as num?)?.toDouble() ?? 0.0,
      searchStatus: EnumItem.resolve(
        EnumType.roommateSearchStatuses,
        json['searchStatus'],
      ),
      badge: json['badge'] ?? '',
      topMatchingTraits: List<String>.from(json['topMatchingTraits'] ?? []),
      mismatchedTraits: List<String>.from(json['mismatchedTraits'] ?? []),
      dealbreakersFound: List<String>.from(json['dealbreakersFound'] ?? []),
    );
  }
}
