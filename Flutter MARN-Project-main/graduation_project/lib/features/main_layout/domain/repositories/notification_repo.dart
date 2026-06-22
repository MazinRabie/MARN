import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/main_layout/domain/entities/notification_entity.dart';
import 'package:MARN/features/main_layout/domain/entities/signalr_notification_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationRepo {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, void>> initAndSyncFCMToken();
  Future<Either<Failure, void>> deleteFCMToken();
  Future<Either<Failure, void>> handelNotification(
    void Function(RemoteMessage) handleRemoteMessage,
  );
  
  ///signalR
  Future<Either<Failure, void>> connect();
  Future<Either<Failure, void>> disconnect();
  Stream<SignalrNotificationEntity> get signalrNotificationStream;
  Future<Either<Failure, void>> markAllNotificationsAsRead();
  Future<Either<Failure, void>> markNotificationAsRead(int id);
}
