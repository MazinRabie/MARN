import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/features/main_layout/domain/entities/signalr_notification_entity.dart';

class SignalrNotificationModel extends SignalrNotificationEntity {
  SignalrNotificationModel({
    super.type,
    required super.title,
    required super.body,
    super.actionType,
    super.actionId,
  });

  factory SignalrNotificationModel.fromSignalR(Map<String, dynamic> json) {
    return SignalrNotificationModel(
      type: (json['type'] ?? json['Type']) != null
          ? EnumItem.resolve(
              EnumType.notificationTypes,
              json['type'] ?? json['Type'],
            )
          : null,
      title: json['title'] ?? json['Title'] ?? '',
      body: json['body'] ?? json['Body'] ?? '',
      actionType: (json['actionType'] ?? json['ActionType']) != null
          ? EnumItem.resolve(
              EnumType.notificationActionTypes,
              json['actionType'] ?? json['ActionType'],
            )
          : null,
      actionId: (json['actionId'] ?? json['ActionId'])?.toString(),
    );
  }
}
