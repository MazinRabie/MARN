part of 'profile_setting_cubit.dart';

@immutable
sealed class ProfileSettingState {}

final class ProfileSettingInitial extends ProfileSettingState {}

final class SettingsLoading extends ProfileSettingState {}

final class SettingsError extends ProfileSettingState {
  final String errorMessage;
  SettingsError({required this.errorMessage});
}

final class ChangePasswordSuccess extends ProfileSettingState {
  final String message;
  ChangePasswordSuccess({required this.message});
}

final class ToggleTwoFactorAuthSuccess extends ProfileSettingState {
  final String message;
  ToggleTwoFactorAuthSuccess({required this.message});
}

final class GetProfileSettingsInfoLoaded extends ProfileSettingState {
  final ProfileSettingsEntity profileSettingsEntity;
  GetProfileSettingsInfoLoaded({required this.profileSettingsEntity});
}

final class EditBasicProfileSuccess extends ProfileSettingState {
  final String message;
  EditBasicProfileSuccess({required this.message});
}

final class EditIdentityProfileSuccess extends ProfileSettingState {
  final String message;
  EditIdentityProfileSuccess({required this.message});
}

final class EditProfileRoommatePreferencesSuccess extends ProfileSettingState {
  final String message;
  EditProfileRoommatePreferencesSuccess({required this.message});
}