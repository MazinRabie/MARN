import 'package:MARN/features/static_screens/data/models/static_card_model.dart';

class AboutMarnData {
  final String missionText;
  final List<StaticCardModel> values;
  final List<StaticCardModel> team;

  const AboutMarnData({
    required this.missionText,
    required this.values,
    required this.team,
  });
}
