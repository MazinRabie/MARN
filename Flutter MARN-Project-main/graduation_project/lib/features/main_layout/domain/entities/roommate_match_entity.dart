import 'package:MARN/core/enums/models/enum_item.dart';

class RoommateMatchEntity {
  final String userId;
  final String fullName;
  final String? profileImage;
  final double compatibilityScore;
  final EnumItem searchStatus;
  final String badge;
  final List<String> topMatchingTraits;
  final List<String> mismatchedTraits;
  final List<String> dealbreakersFound;

  RoommateMatchEntity({
    required this.userId,
    required this.fullName,
    this.profileImage,
    required this.compatibilityScore,
    required this.searchStatus,
    required this.badge,
    required this.topMatchingTraits,
    required this.mismatchedTraits,
    required this.dealbreakersFound,
  });
}
