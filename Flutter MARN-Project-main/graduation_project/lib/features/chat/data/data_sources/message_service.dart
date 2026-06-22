import 'package:MARN/features/chat/data/models/chat_message_model.dart';

abstract class MessageService {
  // hub connection
  Future<void> connect();
  Future<void> disconnect();
  // api calls
  Future<List<ChatMessageModel>> getChatHistory(String otherUserId);
  // hub actions
  Future<void> sendMessage({
    required String receiverId,
    required String content,
  });
  Future<void> activeChatWith({required String otherUserId});
  Future<void> markChatAsRead({required String otherUserId});
  Future<void> leaveActiveChat({required String otherUserId});
  Stream<ChatMessageModel> get messageStream;
  Stream<Map<String, String>> get userOnlineStream;
}
