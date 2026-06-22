class ChatMessageEntity {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final String content;
  final String sentAt;
  final bool isRead;

  ChatMessageEntity({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.content,
    required this.sentAt,
    required this.isRead,
  });
}
