import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/chat/data/data_sources/message_service.dart';
import 'package:MARN/features/chat/domain/entities/chat_message_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:MARN/features/chat/domain/repositories/message_repo.dart';

class MessageRepoImpl implements MessageRepo {
  final MessageService messageService;
  MessageRepoImpl({required this.messageService});

  @override
  Stream<ChatMessageEntity> get messageStream =>
      messageService.messageStream.map((m) => m.toEntity());

  @override
  Stream<Map<String, String>> get userOnlineStream => messageService.userOnlineStream;

  // signalr calls
  @override
  Future<Either<Failure, void>> connect() async {
    try {
      await messageService.connect();
      return right(null);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, void>> disconnect() async {
    try {
      await messageService.disconnect();
      return right(null);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required String receiverId,
    required String content,
  }) async {
    try {
      await messageService.sendMessage(
        receiverId: receiverId,
        content: content,
      );
      return right(null);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, void>> markChatAsRead({
    required String otherUserId,
  }) async {
    try {
      await messageService.markChatAsRead(otherUserId: otherUserId);
      return right(null);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> activeChatWith({
    required String otherUserId,
  }) async {
    try {
      await messageService.activeChatWith(otherUserId: otherUserId);
      return right(null);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> leaveActiveChat({
    required String otherUserId,
  }) async {
    try {
      await messageService.leaveActiveChat(otherUserId: otherUserId);
      return right(null);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  // api calls
  @override
  Future<Either<Failure, List<ChatMessageEntity>>> getChatHistory(
    String otherUserId,
  ) async {
    try {
      final response = await messageService.getChatHistory(otherUserId);
      return Right(response);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
