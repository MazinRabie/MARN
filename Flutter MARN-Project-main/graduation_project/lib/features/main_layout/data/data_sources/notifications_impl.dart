import 'dart:async';

import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/core/services/api_service.dart';
import 'package:MARN/core/services/shared_preferences_helper.dart';
import 'package:MARN/core/utilities/api_endpoints.dart';
import 'package:MARN/core/utilities/api_keys.dart';
import 'package:MARN/features/main_layout/data/models/notification_model.dart';
import 'package:MARN/features/main_layout/data/data_sources/notifications_service.dart';
import 'package:MARN/features/main_layout/data/models/signalr_notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:signalr_netcore/signalr_client.dart';

class NotificationsServiceImpl implements NotificationService {
  final ApiService apiService;
  HubConnection? connection;

  NotificationsServiceImpl({required this.apiService});
  @override
  Future<List<NotificationModel>> getNotifications() async {
    return await handleRequest(() async {
      var response = await apiService.get(
        endPoint: ApiEndPoints.getNotifications,
      );
      if (response.statusCode == 200) {
        return List<NotificationModel>.from(
          response.data["data"].map((x) => NotificationModel.fromJson(x)),
        );
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<void> initAndSyncFCMToken() async {
    await handleRequest(() async {
      final status = await FirebaseMessaging.instance.requestPermission();
      if (status.authorizationStatus != AuthorizationStatus.authorized) return;

      Future<void> sendToken(String token) async {
        print("token fcm: $token");
        final response = await apiService.post(
          endPoint: ApiEndPoints.saveFCM,
          body: {"token": token},
        );
        if (response.statusCode != 200) {
          throw ServerFailure.fromResponse(response.statusCode!, response.data);
        }
      }

      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await sendToken(token);
      }

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        await sendToken(newToken);
      });
    });
  }

  @override
  Future<void> deleteFCMToken() async {
    await handleRequest(() async {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;

      final response = await apiService.delete(
        endPoint: ApiEndPoints.removeFCM,
        body: {"token": token},
      );

      if (response.statusCode != 200) {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<void> handelNotification(
    void Function(RemoteMessage) handleRemoteMessage,
  ) async {
    Future<void> handleBackgroundMessage() async {
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        handleRemoteMessage(message);
      });
    }

    Future<void> handleTerminatedMessage() async {
      RemoteMessage? initialMessage = await FirebaseMessaging.instance
          .getInitialMessage();

      if (initialMessage != null) {
        handleRemoteMessage(initialMessage);
      }
    }

    handleBackgroundMessage();
    handleTerminatedMessage();
  }

  // ================= CONNECT =================
  final _notificationController =
      StreamController<SignalrNotificationModel>.broadcast();
  @override
  Stream<SignalrNotificationModel> get signalrNotificationStream =>
      _notificationController.stream;

  @override
  Future<void> connect() async {
    if (connection != null &&
        connection!.state == HubConnectionState.Connected) {
      return;
    }
    try {
      connection = HubConnectionBuilder()
          .withUrl(
            ApiKeys.signalrNotificationUrl,
            options: HttpConnectionOptions(
              accessTokenFactory: () async {
                final token = SharedPreferencesHelper.getString(
                  LocalStorageVariables.token,
                );
                if (token == null || token.isEmpty) {
                  throw Failure(errorMessage: "Unauthorized user");
                }
                return token;
              },
            ),
          )
          .withAutomaticReconnect()
          .build();
      if (connection!.state != HubConnectionState.Connected) {
        await connection!.start();
      }

      connection!.on("ReceiveNotification", (data) {
        try {
          if (data == null || data.isEmpty) return;
          final raw = data.first;
          if (raw is! Map) return;
          final map = Map<String, dynamic>.from(raw);
          if (map['data'] is Map) {
            map['data'] = Map<String, dynamic>.from(map['data']);
          }
          final notification = SignalrNotificationModel.fromSignalR(map);
          _notificationController.add(notification);
        } catch (e) {
          print("ReceiveNotification error $e");
        }
      });
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure(errorMessage: e.toString());
    }
  }

  @override
  Future<void> disconnect() async {
    await connection?.stop();
    connection = null;
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    if (connection!.state != HubConnectionState.Connected) {
      await connect();
    }
    try {
      await connection!.send("MarkAllNotificationsAsRead");
    } catch (e) {
      throw Failure(errorMessage: e.toString());
    }
  }

  @override
  Future<void> markNotificationAsRead(int id) async {
    if (connection!.state != HubConnectionState.Connected) {
      await connect();
    }
    try {
      await connection!.send("MarkNotificationAsRead", args: [id]);
    } catch (e) {
      throw Failure(errorMessage: e.toString());
    }
  }
}
