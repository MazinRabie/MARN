part of 'notification_cubit.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class GetNotificationsLoading extends NotificationState {}

final class GetNotificationsSuccess extends NotificationState {
  final List<NotificationEntity> notifications;
  GetNotificationsSuccess({required this.notifications});
}

final class GetNotificationsFailure extends NotificationState {
  final String errorMessage;
  GetNotificationsFailure({required this.errorMessage});
}

final class ListenToNotification extends NotificationState {
  final SignalrNotificationEntity notification;
  ListenToNotification({required this.notification});
}

