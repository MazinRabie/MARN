import 'dart:async';
import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/core/services/api_service.dart';
import 'package:MARN/core/services/shared_preferences_helper.dart';
import 'package:MARN/core/utilities/api_endpoints.dart';
import 'package:MARN/core/utilities/api_keys.dart';
import 'package:MARN/features/chat/data/data_sources/message_service.dart';
import 'package:MARN/features/chat/data/models/chat_message_model.dart';
import 'package:signalr_netcore/signalr_client.dart';

class MessageServiceImpl implements MessageService {
  final ApiService apiService;
  MessageServiceImpl({required this.apiService});
  HubConnection? connection;

  final _messageController = StreamController<ChatMessageModel>.broadcast();
  @override
  Stream<ChatMessageModel> get messageStream => _messageController.stream;

  final _userOnlineController =
      StreamController<Map<String, String>>.broadcast();
  @override
  Stream<Map<String, String>> get userOnlineStream =>
      _userOnlineController.stream;

  // ================= CONNECT =================
  @override
  Future<void> connect() async {
    if (connection != null &&
        connection!.state == HubConnectionState.Connected) {
      return;
    }
    try {
      connection = HubConnectionBuilder()
          .withUrl(
            ApiKeys.signalrChatUrl,
            options: HttpConnectionOptions(
              accessTokenFactory: () async {
                final token = SharedPreferencesHelper.getString(
                  LocalStorageVariables.token,
                );
                if (token == null || token.isEmpty) {
                  throw Failure(errorMessage: "Unauthorized user");
                }

                return token;
              },
            ),
          )
          .withAutomaticReconnect()
          .build();
      if (connection!.state != HubConnectionState.Connected) {
        await connection!.start();
      }

      connection!.on("ReceiveMessage", (data) {
        if (_messageController.isClosed) return;
        if (data == null || data.isEmpty) return;
        final json = data.first as Map<String, dynamic>;
        final message = ChatMessageModel.fromJson(json);
        if (!_messageController.isClosed) {
          _messageController.add(message);
        }
      });

      connection!.on("SendMessage", (data) {
        if (_messageController.isClosed) return;
        if (data == null || data.isEmpty) return;
        final json = data.first as Map<String, dynamic>;
        final message = ChatMessageModel.fromJson(json);
        if (!_messageController.isClosed) {
          _messageController.add(message);
        }
      });

      connection!.on("UserOnline", (data) {
        if (_userOnlineController.isClosed) return;
        if (data == null || data.isEmpty) return;
        final userId = data.first as String;
        if (!_userOnlineController.isClosed) {
          _userOnlineController.add({userId: "online"});
        }
      });

      connection!.on("UserOffline", (data) {
        if (_userOnlineController.isClosed) return;
        if (data == null || data.isEmpty) return;
        final userId = data.first as String;
        if (!_userOnlineController.isClosed) {
          _userOnlineController.add({userId: "offline"});
        }
      });
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure(errorMessage: e.toString());
    }
  }

  @override
  Future<void> disconnect() async {
    await connection?.stop();
    connection = null;
  }

  // ================= API CALLS =================
  @override
  Future<List<ChatMessageModel>> getChatHistory(String otherUserId) async {
    return await handleRequest(() async {
      var response = await apiService.get(
        endPoint: "${ApiEndPoints.chatHistory}/$otherUserId",
      );
      if (response.statusCode == 200) {
        List<ChatMessageModel> messages =
            (response.data["data"] as List<dynamic>)
                .map((e) => ChatMessageModel.fromJson(e))
                .toList();

        return messages.reversed.toList();
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  // ================= SEND =================
  @override
  Future<void> sendMessage({
    required String receiverId,
    required String content,
  }) async {
    if (connection!.state != HubConnectionState.Connected) {
      await connect();
    }
    try {
      await connection!.send("SendMessage", args: [receiverId, content]);
    } catch (e) {
      throw Failure(errorMessage: e.toString());
    }
  }

  @override
  Future<void> markChatAsRead({required String otherUserId}) async {
    if (connection!.state != HubConnectionState.Connected) {
      await connect();
    }
    try {
      await connection!.send("MarkChatAsRead", args: [otherUserId]);
    } catch (e) {
      throw Failure(errorMessage: e.toString());
    }
  }

  @override
  Future<void> activeChatWith({required String otherUserId}) async {
    if (connection!.state != HubConnectionState.Connected) {
      await connect();
    }
    try {
      await connection!.send("InActiveChatWith", args: [otherUserId]);
    } catch (e) {
      throw Failure(errorMessage: e.toString());
    }
  }

  @override
  Future<void> leaveActiveChat({required String otherUserId}) async {
    if (connection!.state != HubConnectionState.Connected) {
      return; // Cannot leave if not connected
    }
    try {
      await connection!.send("LeaveActiveChat", args: [otherUserId]);
    } catch (e) {
      throw Failure(errorMessage: e.toString());
    }
  }
}
