import 'dart:async';
import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/chat/data/data_sources/chat_service.dart';
import 'package:dartz/dartz.dart';
import 'package:MARN/features/chat/domain/entities/chat_user_entity.dart';
import 'package:MARN/features/chat/domain/repositories/chat_repo.dart';

class ChatRepoImpl implements ChatRepo {
  final ChatService chatService;
  ChatRepoImpl({required this.chatService});
  @override
  Future<Either<Failure, List<ChatUserEntity>>> searchUsers({
    required String query,
  }) async {
    try {
      final response = await chatService.searchUsers(query: query);
      return Right(response);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<ChatUserEntity>>> getUsers() async {
    try {
      final response = await chatService.getUsers();
      return Right(response);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
