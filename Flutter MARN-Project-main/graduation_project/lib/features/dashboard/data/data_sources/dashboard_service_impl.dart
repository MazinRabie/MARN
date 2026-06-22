import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/core/services/api_service.dart';
import 'package:MARN/core/utilities/api_endpoints.dart';
import 'package:MARN/features/dashboard/data/data_sources/dashboard_service.dart';
import 'package:MARN/features/dashboard/data/models/owner_dashboard_model.dart';
import 'package:MARN/features/dashboard/data/models/renter_dashboard_model.dart';

class DashboardServiceImpl implements DashboardService {
  final ApiService apiService;

  DashboardServiceImpl({required this.apiService});
  @override
  Future<RenterDashboardModel> getRenterDashboardStats() async {
    return await handleRequest(() async {
      final response = await apiService.get(
        endPoint: ApiEndPoints.profileRenterDashboard,
      );
      if (response.statusCode == 200) {
        return RenterDashboardModel.fromJson(response.data['data']);
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<OwnerDashboardModel> getOwnerDashboardStats() async {
    return await handleRequest(() async {
      final response = await apiService.get(
        endPoint: ApiEndPoints.profileOwnerDashboard,
      );
      if (response.statusCode == 200) {
        return OwnerDashboardModel.fromJson(response.data['data']);
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }
}
