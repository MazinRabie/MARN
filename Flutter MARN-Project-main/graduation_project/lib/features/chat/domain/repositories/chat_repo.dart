import 'package:MARN/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:MARN/features/chat/domain/entities/chat_user_entity.dart';

abstract class ChatRepo {
  Future<Either<Failure, List<ChatUserEntity>>> searchUsers({
    required String query,
  });
  Future<Either<Failure, List<ChatUserEntity>>> getUsers();
}
