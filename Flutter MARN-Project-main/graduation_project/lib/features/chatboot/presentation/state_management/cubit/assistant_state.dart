part of 'assistant_cubit.dart';

@immutable
sealed class AssistantState {}

final class AssistantInitial extends AssistantState {}

final class AssistantLoading extends AssistantState {}

final class AssistantSessionsLoaded extends AssistantState {
  final List<AssistantSessionEntity> sessions;
  AssistantSessionsLoaded({required this.sessions});
}

final class AssistantMessagesLoaded extends AssistantState {
  final List<AssistantMessageEntity> messages;
  final String sessionId;
  AssistantMessagesLoaded({required this.messages, required this.sessionId});
}

final class AssistantError extends AssistantState {
  final String errorMessage;
  AssistantError({required this.errorMessage});
}

final class AssistantSessionRenamed extends AssistantState {
  final AssistantSessionEntity session;
  AssistantSessionRenamed({required this.session});
}
