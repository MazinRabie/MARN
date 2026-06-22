import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/main_layout/data/data_sources/roommate_service.dart';
import 'package:MARN/features/main_layout/domain/entities/roommate_match_entity.dart';
import 'package:MARN/features/main_layout/domain/repositories/roommate_repo.dart';
import 'package:dartz/dartz.dart';

class RoommateRepoImpl implements RoommateRepo {
  final RoommateService roommateService;

  RoommateRepoImpl({required this.roommateService});

  @override
  Future<Either<Failure, List<RoommateMatchEntity>>> getRoommateMatches({
    int limit = 30,
  }) async {
    try {
      final result = await roommateService.getRoommateMatches(limit: limit);
      return Right(result);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
