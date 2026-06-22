part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final ProfileEntity profileEntity;
  ProfileLoaded({required this.profileEntity});
}

final class ProfileError extends ProfileState {
  final String errorMessage;

  ProfileError({required this.errorMessage});
}

final class GetUserProfileLoading extends ProfileState {}

final class GetUserProfileLoaded extends ProfileState {
  final ProfileEntity userProfileEntity;
  GetUserProfileLoaded({required this.userProfileEntity});
}

final class GetUserProfileError extends ProfileState {
  final String errorMessage;

  GetUserProfileError({required this.errorMessage});
}
