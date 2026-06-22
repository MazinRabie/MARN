import 'package:MARN/features/static_screens/data/models/static_card_model.dart';

class HowItWorksData {
  final List<StaticCardModel> forTenants;
  final List<StaticCardModel> forOwners;
  final List<StaticCardModel> whyChooseUs;

  const HowItWorksData({
    required this.forTenants,
    required this.forOwners,
    required this.whyChooseUs,
  });
}
