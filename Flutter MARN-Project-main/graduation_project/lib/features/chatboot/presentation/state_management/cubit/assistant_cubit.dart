import 'package:MARN/features/chatboot/domain/entities/assistant_message_entity.dart';
import 'package:MARN/features/chatboot/domain/entities/assistant_session_entity.dart';
import 'package:MARN/features/chatboot/domain/repositories/assistant_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'assistant_state.dart';

class AssistantCubit extends Cubit<AssistantState> {
  final AssistantRepository assistantRepository;

  AssistantCubit({required this.assistantRepository}) : super(AssistantInitial());

  List<AssistantSessionEntity> _sessions = [];
  List<AssistantMessageEntity> _messages = [];
  String? _currentSessionId;

  List<AssistantSessionEntity> get sessions => _sessions;
  List<AssistantMessageEntity> get messages => _messages;
  String? get currentSessionId => _currentSessionId;

  void clearSession() {
    _currentSessionId = null;
    _messages = [];
    emit(AssistantInitial());
  }

  Future<void> getSessions() async {
    emit(AssistantLoading());
    final result = await assistantRepository.getSessions();
    result.fold(
      (failure) => emit(AssistantError(errorMessage: failure.errorMessage)),
      (sessionsList) {
        _sessions = sessionsList;
        emit(AssistantSessionsLoaded(sessions: _sessions));
      },
    );
  }

  Future<void> loadSessionMessages(String sessionId) async {
    _currentSessionId = sessionId;
    emit(AssistantLoading());
    final result = await assistantRepository.getSessionMessages(sessionId: sessionId);
    result.fold(
      (failure) => emit(AssistantError(errorMessage: failure.errorMessage)),
      (messagesList) {
        _messages = messagesList;
        emit(AssistantMessagesLoaded(messages: _messages, sessionId: sessionId));
      },
    );
  }

  Future<void> sendMessage(String content) async {
    // 1. Instantly append user message locally
    final userMsg = AssistantMessageEntity(
      role: 'user',
      content: content,
      createdAt: DateTime.now(),
    );
    _messages = [..._messages, userMsg];
    
    // Emit loaded state with user message and a pending assistant message placeholder
    final pendingAssistantMsg = AssistantMessageEntity(
      role: 'assistant',
      content: '',
      createdAt: DateTime.now(),
      pending: true,
    );
    emit(AssistantMessagesLoaded(
      messages: [..._messages, pendingAssistantMsg],
      sessionId: _currentSessionId ?? '',
    ));

    final result = await assistantRepository.sendMessage(
      sessionId: _currentSessionId,
      content: content,
    );

    result.fold(
      (failure) {
        // Mark message as failed
        emit(AssistantError(errorMessage: failure.errorMessage));
        // Keep user message but remove pending
        emit(AssistantMessagesLoaded(
          messages: _messages,
          sessionId: _currentSessionId ?? '',
        ));
      },
      (response) {
        _currentSessionId = response.sessionId;
        final assistantMsg = response.assistantMessage;
        _messages = [..._messages, assistantMsg];
        emit(AssistantMessagesLoaded(messages: _messages, sessionId: response.sessionId));
        
        // Refresh sessions list
        getSessions();
      },
    );
  }

  Future<void> renameSession({
    required String sessionId,
    required String sessionName,
  }) async {
    emit(AssistantLoading());
    final result = await assistantRepository.renameSession(
      sessionId: sessionId,
      sessionName: sessionName,
    );

    result.fold(
      (failure) => emit(AssistantError(errorMessage: failure.errorMessage)),
      (updatedSession) {
        // Update session in list, preserving lastMessagePreview and lastMessageAt
        final index = _sessions.indexWhere((s) => s.sessionId == sessionId);
        if (index != -1) {
          final newSessions = List<AssistantSessionEntity>.from(_sessions);
          newSessions[index] = newSessions[index].copyWith(
            sessionName: updatedSession.sessionName,
            updatedAt: updatedSession.updatedAt,
            lastMessagePreview: updatedSession.lastMessagePreview ?? _sessions[index].lastMessagePreview,
            lastMessageAt: updatedSession.lastMessageAt ?? _sessions[index].lastMessageAt,
          );
          _sessions = newSessions; // Change the list reference to force rebuilds
        }
        emit(AssistantSessionRenamed(session: _sessions[index]));
        emit(AssistantSessionsLoaded(sessions: List.from(_sessions)));
      },
    );
  }
}
