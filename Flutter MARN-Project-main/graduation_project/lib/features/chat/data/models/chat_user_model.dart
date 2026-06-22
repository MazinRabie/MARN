import 'package:MARN/core/widgets/buildImage_url.dart';
import 'package:MARN/features/chat/domain/entities/chat_user_entity.dart';
import 'package:MARN/core/widgets/date_formatter.dart';

class UserChatModel extends ChatUserEntity {
  UserChatModel({
    required super.id,
    required super.isDeleted,
    required super.userName,
    required super.profileImage,
    required super.isOnline,
    required super.unreadCount,
    required super.lastMessage,
  });

  factory UserChatModel.fromJson(Map<String, dynamic> json) {
    return UserChatModel(
      id: json['id'],
      isDeleted: json['isDeleted'],
      userName: json['userName'],
      profileImage: buildImageUrl(json['profileImage']),
      isOnline: json['isOnline'],
      unreadCount: json['unreadCount'],
      lastMessage: json['lastMessage'] != null
          ? LastMessageModel.fromJson(json['lastMessage'])
          : null,
    );
  }
}

class LastMessageModel extends LastMessageEntity {
  LastMessageModel({
    required super.content,
    required super.sentAt,
    required super.isMine,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) {
    return LastMessageModel(
      content: json['content'],
      sentAt: DateFormatter.formatString(json['sentAt']),
      isMine: json['isMine'],
    );
  }
}
