import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/main_layout/domain/entities/roommate_match_entity.dart';
import 'package:dartz/dartz.dart';

abstract class RoommateRepo {
  Future<Either<Failure, List<RoommateMatchEntity>>> getRoommateMatches({
    int limit = 30,
  });
}
