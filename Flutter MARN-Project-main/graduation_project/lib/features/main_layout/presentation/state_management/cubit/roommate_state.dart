part of 'roommate_cubit.dart';

abstract class RoommateState {}

class RoommateInitial extends RoommateState {}

class RoommateLoading extends RoommateState {}

class RoommateSuccess extends RoommateState {
  final List<RoommateMatchEntity> matches;
  RoommateSuccess({required this.matches});
}

class RoommateFailure extends RoommateState {
  final String errorMessage;
  RoommateFailure({required this.errorMessage});
}
