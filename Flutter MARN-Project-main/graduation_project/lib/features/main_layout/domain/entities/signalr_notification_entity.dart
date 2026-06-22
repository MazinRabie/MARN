import 'package:MARN/core/enums/models/enum_item.dart';

abstract class SignalrNotificationEntity {
  final EnumItem? type;
  final String title;
  final String body;
  final EnumItem? actionType;
  final String? actionId;

  SignalrNotificationEntity({
    this.type,
    required this.title,
    required this.body,
    this.actionType,
    this.actionId,
  });
}
