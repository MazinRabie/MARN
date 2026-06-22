import 'package:dartz/dartz.dart';
import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/dashboard/data/data_sources/dashboard_service.dart';
import 'package:MARN/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:MARN/features/dashboard/domain/repositories/dashboard_repo.dart';

class DashboardRepoImpl implements DashboardRepo {
  final DashboardService dashboardService;
  DashboardRepoImpl({required this.dashboardService});

  @override
  Future<Either<Failure, RenterDashboardEntity>>
  getRenterDashboardStats() async {
    try {
      final renterStats = await dashboardService.getRenterDashboardStats();
      return Right(renterStats);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OwnerDashboardEntity>> getOwnerDashboardStats() async {
    try {
      final ownerStats = await dashboardService.getOwnerDashboardStats();
      return Right(ownerStats);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}
