import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/main_layout/data/data_sources/notifications_service.dart';
import 'package:MARN/features/main_layout/domain/entities/notification_entity.dart';
import 'package:MARN/features/main_layout/domain/entities/signalr_notification_entity.dart';
import 'package:MARN/features/main_layout/domain/repositories/notification_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationRepoImpl implements NotificationRepo {
  final NotificationService notificationService;
  NotificationRepoImpl({required this.notificationService});

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      return Right(await notificationService.getNotifications());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> initAndSyncFCMToken() async {
    try {
      await notificationService.initAndSyncFCMToken();
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFCMToken() async {
    try {
      await notificationService.deleteFCMToken();
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> handelNotification(
    void Function(RemoteMessage) handleRemoteMessage,
  ) async {
    try {
      await notificationService.handelNotification(handleRemoteMessage);
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> connect() async {
    try {
      await notificationService.connect();
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disconnect() async {
    try {
      await notificationService.disconnect();
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Stream<SignalrNotificationEntity> get signalrNotificationStream =>
      notificationService.signalrNotificationStream;

  @override
  Future<Either<Failure, void>> markAllNotificationsAsRead() async {
    try {
      await notificationService.markAllNotificationsAsRead();
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markNotificationAsRead(int id) async {
    try {
      await notificationService.markNotificationAsRead(id);
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}
