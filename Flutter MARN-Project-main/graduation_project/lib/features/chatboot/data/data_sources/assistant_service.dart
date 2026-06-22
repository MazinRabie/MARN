import 'package:MARN/features/chatboot/data/models/assistant_message_model.dart';
import 'package:MARN/features/chatboot/data/models/assistant_session_model.dart';

class SendMessageResponse {
  final String sessionId;
  final AssistantMessageModel assistantMessage;

  SendMessageResponse({
    required this.sessionId,
    required this.assistantMessage,
  });
}

abstract class AssistantService {
  Future<SendMessageResponse> sendMessage({
    required String? sessionId,
    required String content,
  });

  Future<List<AssistantSessionModel>> getSessions();

  Future<List<AssistantMessageModel>> getSessionMessages({
    required String sessionId,
  });

  Future<AssistantSessionModel> renameSession({
    required String sessionId,
    required String sessionName,
  });
}
