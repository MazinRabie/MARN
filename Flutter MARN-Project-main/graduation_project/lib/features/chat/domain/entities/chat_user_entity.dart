class ChatUserEntity {
  final String id;
  final bool isDeleted;
  final String userName;
  final String? profileImage;
  bool isOnline;
  int unreadCount;
  LastMessageEntity? lastMessage;

  ChatUserEntity({
    required this.id,
    required this.isDeleted,
    required this.userName,
    required this.profileImage,
    required this.isOnline,
    required this.unreadCount,
    required this.lastMessage,
  });
}

class LastMessageEntity {
  String content;
  String sentAt;
  bool isMine;

  LastMessageEntity({
    required this.content,
    required this.sentAt,
    required this.isMine,
  });
}
