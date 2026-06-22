import 'dart:async';
import 'package:MARN/features/chat/domain/entities/chat_message_entity.dart';
import 'package:MARN/features/chat/domain/entities/chat_user_entity.dart';
import 'package:MARN/features/chat/domain/repositories/chat_repo.dart';
import 'package:MARN/features/chat/domain/repositories/message_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final MessageRepo messageRepo;
  final ChatRepo chatRepo;
  String? activeChatUserId;

  MessageCubit({required this.messageRepo, required this.chatRepo})
    : super(MessageInitial());
  Future<void> connect() async {
    var result = await messageRepo.connect();
    result.fold(
      (failure) => emit(MessageFailure(errorMessage: failure.errorMessage)),
      (_) => null,
    );
  }

  Future<void> getChatHistory(String otherUserId) async {
    emit(MessageLoading());
    var result = await messageRepo.getChatHistory(otherUserId);
    result.fold(
      (failure) => emit(MessageFailure(errorMessage: failure.errorMessage)),
      (messages) {
        emit(HistoryLoaded(messages: messages));
      },
    );
  }

  Future<void> searchUsers({required String query}) async {
    emit(ChatLoading());
    var result = await chatRepo.searchUsers(query: query);
    result.fold(
      (failure) {
        emit(ChatFailure(errorMessage: failure.errorMessage));
      },
      (users) {
        emit(SearchLoaded(users: users));
      },
    );
  }

  Future<void> getUsers() async {
    var result = await chatRepo.getUsers();
    result.fold(
      (failure) {
        emit(ChatFailure(errorMessage: failure.errorMessage));
      },
      (users) {
        emit(GetUsersLoaded(users: users));
      },
    );
  }

  Future<void> sendMessage({
    required String receiverId,
    required String content,
  }) async {
    var result = await messageRepo.sendMessage(
      receiverId: receiverId,
      content: content,
    );
    result.fold(
      (_) => emit(MessageSentFailed()),
      (_) => emit(MessageSentSuccess()),
    );
  }

  Future<void> activeChatWith({required String otherUserId}) async {
    activeChatUserId = otherUserId;
    await messageRepo.activeChatWith(otherUserId: otherUserId);
  }

  Future<void> leaveActiveChat({required String otherUserId}) async {
    activeChatUserId = null;
    await messageRepo.leaveActiveChat(otherUserId: otherUserId);
  }

  Future<void> markChatAsRead({required String otherUserId}) async {
    await messageRepo.markChatAsRead(otherUserId: otherUserId);
    emit(MarMessageAsReadSuccess(otherUserId: otherUserId));
  }

  StreamSubscription? _messageSubscription;
  void listenToNewMessages() {
    _messageSubscription?.cancel();
    _messageSubscription = messageRepo.messageStream.listen((message) {
      if (isClosed) return;
      emit(ListenToMessages(message: message));
    });
  }

  StreamSubscription? _userOnlineSubscription;
  void listenToUserOnline() {
    _userOnlineSubscription?.cancel();
    _userOnlineSubscription = messageRepo.userOnlineStream.listen((userStatus) {
      if (isClosed) return;
      emit(ListenToUserOnline(userStatus: userStatus));
    });
  }

  Future<void> disconnect() async {
    await messageRepo.disconnect();
    await _messageSubscription?.cancel();
    await _userOnlineSubscription?.cancel();
  }
}
