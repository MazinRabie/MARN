import 'package:MARN/features/dashboard/data/models/owner_dashboard_model.dart';
import 'package:MARN/features/dashboard/data/models/renter_dashboard_model.dart';

abstract class DashboardService {
  Future<OwnerDashboardModel> getOwnerDashboardStats();
  Future<RenterDashboardModel> getRenterDashboardStats();
}