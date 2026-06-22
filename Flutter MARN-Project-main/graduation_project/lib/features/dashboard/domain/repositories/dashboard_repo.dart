import 'package:dartz/dartz.dart';
import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/dashboard/domain/entities/dashboard_entity.dart';

abstract class DashboardRepo {
  Future<Either<Failure, OwnerDashboardEntity>> getOwnerDashboardStats();
  Future<Either<Failure, RenterDashboardEntity>> getRenterDashboardStats();
}
