import 'package:MARN/core/enums/models/enum_item.dart';

abstract class NotificationEntity {
  final int id;
  final EnumItem? type;
  final String title;
  final String body;
  final EnumItem? actionType;
  final String? actionId;
  final bool isRead;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.actionType,
    required this.actionId,
    required this.isRead,
    required this.createdAt,
  });
}
