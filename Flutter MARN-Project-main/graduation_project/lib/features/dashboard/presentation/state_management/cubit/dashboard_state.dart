part of 'dashboard_cubit.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}
final class OwnerDashboardLoading extends DashboardState {}

final class OwnerDashboardFailure extends DashboardState {
  final String errorMessage;
  OwnerDashboardFailure({required this.errorMessage});
}

final class OwnerDashboardLoaded extends DashboardState {
  final OwnerDashboardEntity dashboardStats;
  OwnerDashboardLoaded({required this.dashboardStats});
}


final class RenterDashboardLoading extends DashboardState {}

final class RenterDashboardFailure extends DashboardState {
  final String errorMessage;
  RenterDashboardFailure({required this.errorMessage});
}

final class RenterDashboardLoaded extends DashboardState {
  final RenterDashboardEntity dashboardStats;
  RenterDashboardLoaded({required this.dashboardStats});
}
