part of 'message_cubit.dart';

@immutable
sealed class MessageState {}

final class MessageInitial extends MessageState {}

final class MessageLoading extends MessageState {}

final class MessageFailure extends MessageState {
  final String errorMessage;
  MessageFailure({required this.errorMessage});
}

// send message
final class MessageSentSuccess extends MessageState {}

final class MessageSentFailed extends MessageState {}

// get chat history
final class HistoryLoaded extends MessageState {
  final List<ChatMessageEntity> messages;
  HistoryLoaded({required this.messages});
}

// listen to messages
final class ListenToMessages extends MessageState {
  final ChatMessageEntity message;
  ListenToMessages({required this.message});
}

final class MarMessageAsReadSuccess extends MessageState {
  final String otherUserId;
  MarMessageAsReadSuccess({required this.otherUserId});
}


final class ListenToUserOnline extends MessageState {
  final Map<String, String> userStatus;
  ListenToUserOnline({required this.userStatus});
}

final class ChatLoading extends MessageState {}

final class SearchLoaded extends MessageState {
  final List<ChatUserEntity> users;
  SearchLoaded({required this.users});
}

final class GetUsersLoaded extends MessageState {
  final List<ChatUserEntity> users;
  GetUsersLoaded({required this.users});
}

final class ChatFailure extends MessageState {
  final String errorMessage;
  ChatFailure({required this.errorMessage});
}
