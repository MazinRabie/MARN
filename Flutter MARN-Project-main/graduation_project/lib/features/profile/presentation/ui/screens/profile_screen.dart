import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/features/profile/domain/entities/profile_entity.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_cubit.dart';
import 'package:MARN/features/profile/presentation/ui/widgets/profile_form.dart';
import 'package:MARN/features/static_screens/presentation/screens/error404_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;
  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileEntity? profileEntity;
  bool isMe = false;
  @override
  void initState() {
    super.initState();
    if (widget.userId != null && widget.userId!.isNotEmpty) {
      context.read<ProfileCubit>().getUserProfile(userId: widget.userId!);
      isMe = false;
    } else {
      context.read<ProfileCubit>().getMyProfileFromLocalStorage();
      isMe = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          profileEntity = state.profileEntity;
        } else if (state is GetUserProfileLoaded) {
          profileEntity = state.userProfileEntity;
        } else if (state is GetUserProfileError) {
          buildSnackBar(context, message: state.errorMessage, isError: true);
        }
      },
      builder: (context, state) {
        if (state is GetUserProfileError) {
          return const Error404Screen();
        } else if ((state is ProfileLoaded || state is GetUserProfileLoaded) &&
            profileEntity != null) {
          return ProfileForm(profileEntity: profileEntity!, isMyProfile: isMe);
        } else if (state is ProfileLoading || state is GetUserProfileLoading) {
          return Center(child: buildLoading());
        } else {
          return Center(child: buildLoading());
        }
      },
    );
  }
}
