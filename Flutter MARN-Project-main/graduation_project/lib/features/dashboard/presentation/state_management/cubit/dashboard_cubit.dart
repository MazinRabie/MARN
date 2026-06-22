import 'package:MARN/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:MARN/features/dashboard/domain/repositories/dashboard_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({required this.dashboardRepo}) : super(DashboardInitial());
  final DashboardRepo dashboardRepo;

  Future<void> getOwnerDashboardStats() async {
    emit(OwnerDashboardLoading());
    final result = await dashboardRepo.getOwnerDashboardStats();
    result.fold(
      (failure) =>
          emit(OwnerDashboardFailure(errorMessage: failure.errorMessage)),
      (dashboardStats) =>
          emit(OwnerDashboardLoaded(dashboardStats: dashboardStats)),
    );
  }

  Future<void> getRenterDashboardStats() async {
    emit(RenterDashboardLoading());
    final result = await dashboardRepo.getRenterDashboardStats();
    result.fold(
      (failure) =>
          emit(RenterDashboardFailure(errorMessage: failure.errorMessage)),
      (dashboardStats) =>
          emit(RenterDashboardLoaded(dashboardStats: dashboardStats)),
    );
  }
}
