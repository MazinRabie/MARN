import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/core/services/api_service.dart';
import 'package:MARN/core/utilities/api_endpoints.dart';
import 'package:MARN/features/main_layout/data/data_sources/roommate_service.dart';
import 'package:MARN/features/main_layout/data/models/roommate_match_model.dart';

class ApiRoommateService implements RoommateService {
  final ApiService apiService;

  ApiRoommateService({required this.apiService});

  @override
  Future<List<RoommateMatchModel>> getRoommateMatches({int limit = 30}) async {
    return await handleRequest(() async {
      final response = await apiService.get(
        endPoint: ApiEndPoints.roommateMatches,
        queryParameters: {'limit': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => RoommateMatchModel.fromJson(json)).toList();
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }
}
