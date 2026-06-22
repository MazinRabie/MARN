import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/app_bar_widget.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/features/chat/presentation/ui/screens/list_chats_screen.dart';
import 'package:MARN/features/main_layout/presentation/state_management/cubit/notification_cubit.dart';
import 'package:MARN/features/dashboard/presentation/ui/screens/renter_dash_board_screen.dart';
import 'package:MARN/features/main_layout/presentation/ui/screens/home_screen.dart';
import 'package:MARN/features/main_layout/presentation/ui/screens/roommate_screen.dart';
import 'package:MARN/features/main_layout/presentation/ui/screens/notification_screen.dart';
import 'package:MARN/features/main_layout/presentation/ui/widgets/app_drawer.dart';
import 'package:MARN/features/main_layout/presentation/ui/widgets/bottom_nav_bar.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MARN/features/chat/presentation/state_management/cubit/message_cubit.dart';
import 'package:go_router/go_router.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key, this.initialIndex = 1});
  final int initialIndex;

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  late int currentIndex;
  late List<Widget> pages;
  late MessageCubit messageCubit;
  late NotificationCubit notificationCubit;
  late ProfileCubit profileCubit;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    messageCubit = context.read<MessageCubit>();
    notificationCubit = context.read<NotificationCubit>();
    profileCubit = context.read<ProfileCubit>();
    profileCubit.getMyProfileFromLocalStorage();
    profileCubit.getMyProfile();
    messageCubit.connect();
    notificationCubit.connect();
    notificationCubit.initAndSyncFCMToken();
    notificationCubit.listenToNewNotification(context);
    notificationCubit.handelNotification((message) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotificationScreen()),
      );
    });
    pages = [
      RenterDashBoardScreen(),
      HomeScreen(),
      RoommateScreen(),
      ListChatsScreen(),
    ];
  }

  @override
  void dispose() {
    // messageCubit.disconnect();
    // notificationCubit.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.transparent,
      drawer: AppDrawer(),
      appBar: appBarWidget(
        context,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
            icon: Stack(
              children: [
                Icon(Icons.notifications_none),
                BlocBuilder<NotificationCubit, NotificationState>(
                  builder: (context, state) {
                    return notificationCubit.unreadNotificationsCount > 0
                        ? Positioned(
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return buildLoading();
          } else if (state is ProfileLoaded) {
            return SafeArea(child: pages[currentIndex]);
          } else if (state is ProfileError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return SafeArea(child: pages[currentIndex]);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          context.push(AppRoutes.chatBootScreen);
        },
        child: const Icon(Icons.smart_toy),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}
