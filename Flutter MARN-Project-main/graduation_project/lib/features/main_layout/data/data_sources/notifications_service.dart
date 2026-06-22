import 'package:MARN/features/main_layout/data/models/notification_model.dart';
import 'package:MARN/features/main_layout/data/models/signalr_notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationService {
  Future<List<NotificationModel>> getNotifications();
  Future<void> initAndSyncFCMToken();
  Future<void> deleteFCMToken();
  Future<void> handelNotification(
    void Function(RemoteMessage) handleRemoteMessage,
  );

  ///signalR
  Future<void> connect();
  Future<void> disconnect();
  Stream<SignalrNotificationModel> get signalrNotificationStream;
  Future<void> markAllNotificationsAsRead();
  Future<void> markNotificationAsRead(int id);
}
