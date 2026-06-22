import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/core/services/api_service.dart';
import 'package:MARN/core/utilities/api_endpoints.dart';
import 'package:MARN/features/chat/data/data_sources/chat_service.dart';
import 'package:MARN/features/chat/data/models/chat_user_model.dart';

class ChatServiceImpl implements ChatService {
  final ApiService apiService;
  ChatServiceImpl({required this.apiService});

  @override
  Future<List<UserChatModel>> getUsers() async {
    return await handleRequest(() async {
      var response = await apiService.get(endPoint: ApiEndPoints.chatUsers);
      if (response.statusCode == 200) {
        List<UserChatModel> users = (response.data["data"] as List<dynamic>)
            .map((e) => UserChatModel.fromJson(e))
            .toList();
        return users;
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<List<UserChatModel>> searchUsers({required String query}) async {
    return await handleRequest(() async {
      var response = await apiService.get(
        endPoint: ApiEndPoints.chatSearch,
        queryParameters: {"q": query},
      );
      if (response.statusCode == 200) {
        List<UserChatModel> users = (response.data["data"] as List<dynamic>)
            .map((e) => UserChatModel.fromJson(e))
            .toList();
        return users;
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }
}
