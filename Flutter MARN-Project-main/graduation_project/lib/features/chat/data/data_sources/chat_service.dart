import 'package:MARN/features/chat/data/models/chat_user_model.dart';

abstract class ChatService {
  Future<List<UserChatModel>> getUsers();
  Future<List<UserChatModel>> searchUsers({required String query});
}
