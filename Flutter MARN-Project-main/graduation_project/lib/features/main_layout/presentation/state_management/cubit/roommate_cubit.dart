import 'package:MARN/features/main_layout/domain/entities/roommate_match_entity.dart';
import 'package:MARN/features/main_layout/domain/repositories/roommate_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'roommate_state.dart';

class RoommateCubit extends Cubit<RoommateState> {
  final RoommateRepo roommateRepo;

  RoommateCubit({required this.roommateRepo}) : super(RoommateInitial());

  Future<void> getRoommateMatches({int limit = 30}) async {
    emit(RoommateLoading());
    final result = await roommateRepo.getRoommateMatches(limit: limit);
    result.fold(
      (failure) => emit(RoommateFailure(errorMessage: failure.errorMessage)),
      (matches) => emit(RoommateSuccess(matches: matches)),
    );
  }
}
