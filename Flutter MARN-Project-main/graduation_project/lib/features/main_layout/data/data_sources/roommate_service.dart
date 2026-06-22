import 'package:MARN/features/main_layout/data/models/roommate_match_model.dart';

abstract class RoommateService {
  Future<List<RoommateMatchModel>> getRoommateMatches({int limit = 30});
}
