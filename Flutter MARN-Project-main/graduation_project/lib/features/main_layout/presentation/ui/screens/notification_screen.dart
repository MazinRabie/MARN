import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/app_bar_widget.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/features/main_layout/presentation/state_management/cubit/notification_cubit.dart';
import 'package:MARN/features/main_layout/presentation/ui/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      appBar: appBarWidget(
        context,
        actions: [
          IconButton(
            onPressed: () {
              context.read<NotificationCubit>().markAllNotificationsAsRead();
              context.read<NotificationCubit>().getNotifications();
            },
            icon: Icon(Icons.mark_email_read_rounded),
          ),
        ],
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is GetNotificationsFailure) {
            buildSnackBar(context, message: state.errorMessage, isError: true);
          }
        },
        builder: (context, state) {
          if (state is GetNotificationsSuccess) {
            return Stack(
              alignment: Alignment.center,
              children: [
                ListView.builder(
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = state.notifications[index];
                    return NotificationCard(notification: notification);
                  },
                ),
              ],
            );
          }
          return buildLoading();
        },
      ),
    );
  }
}
