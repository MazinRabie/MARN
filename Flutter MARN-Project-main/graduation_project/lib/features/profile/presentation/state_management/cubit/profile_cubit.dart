import 'package:MARN/features/profile/domain/entities/profile_entity.dart';
import 'package:MARN/features/profile/domain/repositories/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());

  final ProfileRepo profileRepo;

  Future<void> getMyProfile() async {
    emit(ProfileLoading());
    var result = await profileRepo.getMyProfile();
    result.fold(
      (failure) {
        emit(ProfileError(errorMessage: failure.errorMessage));
      },
      (profileEntity) {
        emit(ProfileLoaded(profileEntity: profileEntity));
      },
    );
  }

  Future<void> getMyProfileFromLocalStorage() async {
    emit(ProfileLoading());
    var result = await profileRepo.getMyProfileFromLocalStorage();
    result.fold(
      (failure) {
        emit(ProfileError(errorMessage: failure.errorMessage));
      },
      (profileEntity) {
        emit(ProfileLoaded(profileEntity: profileEntity));
      },
    );
  }

  Future<void> getUserProfile({required String userId}) async {
    emit(GetUserProfileLoading());
    var result = await profileRepo.getUserProfile(userId: userId);
    result.fold(
      (failure) {
        emit(GetUserProfileError(errorMessage: failure.errorMessage));
      },
      (userProfileEntity) {
        emit(GetUserProfileLoaded(userProfileEntity: userProfileEntity));
      },
    );
  }
}
