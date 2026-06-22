import 'package:MARN/features/chat/domain/entities/chat_message_entity.dart';
import 'package:MARN/core/widgets/date_formatter.dart';

class ChatMessageModel extends ChatMessageEntity {
  ChatMessageModel({
    required super.id,
    required super.senderId,
    required super.senderName,
    required super.receiverId,
    required super.receiverName,
    required super.content,
    required super.sentAt,
    required super.isRead,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      receiverId: json['receiverId'],
      receiverName: json['receiverName'],
      content: json['content'],
      sentAt: DateFormatter.formatString(json['sentAt']),
      isRead: json['isRead'],
    );
  }

  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      id: id,
      senderId: senderId,
      senderName: senderName,
      receiverId: receiverId,
      receiverName: receiverName,
      content: content,
      sentAt: sentAt,
      isRead: isRead,
    );
  }
}
