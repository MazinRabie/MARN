import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/features/main_layout/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    required super.type,
    required super.title,
    required super.body,
    required super.actionType,
    super.actionId,
    required super.isRead,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      type: json['type'] != null
          ? EnumItem.resolve(EnumType.notificationTypes, json['type'])
          : null,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      actionType: json['actionType'] != null
          ? EnumItem.resolve(
              EnumType.notificationActionTypes,
              json['actionType'],
            )
          : null,
      actionId: json['actionId']?.toString(),
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
