import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/chat/domain/entities/chat_message_entity.dart';
import 'package:dartz/dartz.dart';

abstract class MessageRepo {
  // signalr calls
  Future<Either<Failure, void>> connect();
  Future<Either<Failure, void>> disconnect();
  // api calls
  Future<Either<Failure, List<ChatMessageEntity>>> getChatHistory(
    String otherUserId,
  );
  // hub calls
  Future<Either<Failure, void>> sendMessage({
    required String receiverId,
    required String content,
  });
  Future<Either<Failure, void>> markChatAsRead({required String otherUserId});
  Future<Either<Failure, void>> activeChatWith({required String otherUserId});
  Future<Either<Failure, void>> leaveActiveChat({required String otherUserId});
  Stream<ChatMessageEntity> get messageStream;
  Stream<Map<String, String>> get userOnlineStream;
}
