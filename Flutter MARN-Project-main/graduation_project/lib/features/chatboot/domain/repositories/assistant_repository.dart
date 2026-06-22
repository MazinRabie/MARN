import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/chatboot/domain/entities/assistant_message_entity.dart';
import 'package:MARN/features/chatboot/domain/entities/assistant_session_entity.dart';
import 'package:MARN/features/chatboot/data/data_sources/assistant_service.dart';
import 'package:dartz/dartz.dart';

abstract class AssistantRepository {
  Future<Either<Failure, SendMessageResponse>> sendMessage({
    required String? sessionId,
    required String content,
  });

  Future<Either<Failure, List<AssistantSessionEntity>>> getSessions();

  Future<Either<Failure, List<AssistantMessageEntity>>> getSessionMessages({
    required String sessionId,
  });

  Future<Either<Failure, AssistantSessionEntity>> renameSession({
    required String sessionId,
    required String sessionName,
  });
}
