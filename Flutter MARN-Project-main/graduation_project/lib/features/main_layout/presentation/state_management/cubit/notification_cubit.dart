import 'dart:async';
import 'package:MARN/features/main_layout/domain/entities/notification_entity.dart';
import 'package:MARN/features/main_layout/domain/entities/signalr_notification_entity.dart';
import 'package:MARN/features/main_layout/domain/repositories/notification_repo.dart';
import 'package:MARN/features/main_layout/presentation/ui/widgets/notification_toster.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({required this.notificationRepo})
    : super(NotificationInitial());
  final NotificationRepo notificationRepo;
  List<NotificationEntity> notifications = [];
  int unreadNotificationsCount = 0;

  void getNotifications() async {
    emit(GetNotificationsLoading());
    final result = await notificationRepo.getNotifications();
    result.fold(
      (failure) {
        emit(GetNotificationsFailure(errorMessage: failure.errorMessage));
      },
      (notifications) {
        this.notifications = notifications;
        emit(GetNotificationsSuccess(notifications: notifications));
      },
    );
  }

  void initAndSyncFCMToken() async {
    final result = await notificationRepo.initAndSyncFCMToken();
    result.fold((failure) {
      emit(GetNotificationsFailure(errorMessage: failure.errorMessage));
    }, (_) {});
  }

  void deleteFCMToken() async {
    final result = await notificationRepo.deleteFCMToken();
    result.fold((failure) {
      emit(GetNotificationsFailure(errorMessage: failure.errorMessage));
    }, (_) {});
  }

  void handelNotification(
    void Function(RemoteMessage) handleRemoteMessage,
  ) async {
    final result = await notificationRepo.handelNotification(
      handleRemoteMessage,
    );
    result.fold((failure) {
      emit(GetNotificationsFailure(errorMessage: failure.errorMessage));
    }, (_) {});
  }

  void connect() async {
    final result = await notificationRepo.connect();
    result.fold((failure) {
      emit(GetNotificationsFailure(errorMessage: failure.errorMessage));
    }, (_) {});
  }

  void markAllNotificationsAsRead() async {
    final result = await notificationRepo.markAllNotificationsAsRead();
    result.fold(
      (failure) {
        emit(GetNotificationsFailure(errorMessage: failure.errorMessage));
      },
      (_) {
        unreadNotificationsCount = 0;
      },
    );
  }

  void markNotificationAsRead(int id) async {
    final result = await notificationRepo.markNotificationAsRead(id);
    result.fold(
      (failure) {
        emit(GetNotificationsFailure(errorMessage: failure.errorMessage));
      },
      (_) {
        unreadNotificationsCount--;
      },
    );
  }

  StreamSubscription? _newNotificationSubscription;
  void listenToNewNotification(BuildContext context) {
    _newNotificationSubscription?.cancel();
    _newNotificationSubscription = notificationRepo.signalrNotificationStream
        .listen((notification) {
          if (isClosed) return;
          unreadNotificationsCount++;
          notificationToster(
            context,
            notification: notification,
          );
          emit(ListenToNotification(notification: notification));
        });
  }

  Future<void> disconnect() async {
    await notificationRepo.disconnect();
    await _newNotificationSubscription?.cancel();
  }
}
