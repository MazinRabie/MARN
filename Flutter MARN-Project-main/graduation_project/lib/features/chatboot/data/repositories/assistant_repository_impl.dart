import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/chatboot/data/data_sources/assistant_service.dart';
import 'package:MARN/features/chatboot/domain/entities/assistant_message_entity.dart';
import 'package:MARN/features/chatboot/domain/entities/assistant_session_entity.dart';
import 'package:MARN/features/chatboot/domain/repositories/assistant_repository.dart';
import 'package:dartz/dartz.dart';

class AssistantRepositoryImpl implements AssistantRepository {
  final AssistantService assistantService;

  AssistantRepositoryImpl({required this.assistantService});

  @override
  Future<Either<Failure, SendMessageResponse>> sendMessage({
    required String? sessionId,
    required String content,
  }) async {
    try {
      final result = await assistantService.sendMessage(
        sessionId: sessionId,
        content: content,
      );
      return right(result);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AssistantSessionEntity>>> getSessions() async {
    try {
      final result = await assistantService.getSessions();
      return right(result);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AssistantMessageEntity>>> getSessionMessages({
    required String sessionId,
  }) async {
    try {
      final result = await assistantService.getSessionMessages(sessionId: sessionId);
      return right(result);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AssistantSessionEntity>> renameSession({
    required String sessionId,
    required String sessionName,
  }) async {
    try {
      final result = await assistantService.renameSession(
        sessionId: sessionId,
        sessionName: sessionName,
      );
      return right(result);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
