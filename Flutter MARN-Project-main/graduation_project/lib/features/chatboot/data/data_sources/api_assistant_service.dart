import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/core/services/api_service.dart';
import 'package:MARN/core/utilities/api_endpoints.dart';
import 'package:MARN/features/chatboot/data/data_sources/assistant_service.dart';
import 'package:MARN/features/chatboot/data/models/assistant_message_model.dart';
import 'package:MARN/features/chatboot/data/models/assistant_session_model.dart';
import 'package:dio/dio.dart';

class ApiAssistantService implements AssistantService {
  final ApiService apiService;

  ApiAssistantService({required this.apiService});

  @override
  Future<SendMessageResponse> sendMessage({
    required String? sessionId,
    required String content,
  }) async {
    return await handleRequest(() async {
      final response = await apiService.post(
        endPoint: ApiEndPoints.assistantMessages,
        body: {
          if (sessionId != null) 'sessionId': sessionId,
          'content': content,
        },
        options: Options(
          connectTimeout: const Duration(minutes: 2),
          receiveTimeout: const Duration(minutes: 2),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final returnedSessionId = data['sessionId']?.toString() ?? '';
        final assistantMessageJson = data['assistantMessage'];
        final assistantMessage = AssistantMessageModel.fromJson(
          assistantMessageJson,
        );

        return SendMessageResponse(
          sessionId: returnedSessionId,
          assistantMessage: assistantMessage,
        );
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<List<AssistantSessionModel>> getSessions() async {
    return await handleRequest(() async {
      final response = await apiService.get(
        endPoint: ApiEndPoints.assistantSessions,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        return data.map((e) => AssistantSessionModel.fromJson(e)).toList();
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<List<AssistantMessageModel>> getSessionMessages({
    required String sessionId,
  }) async {
    return await handleRequest(() async {
      final response = await apiService.get(
        endPoint: "${ApiEndPoints.assistantSessionBase}/$sessionId/messages",
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        return data.map((e) => AssistantMessageModel.fromJson(e)).toList();
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<AssistantSessionModel> renameSession({
    required String sessionId,
    required String sessionName,
  }) async {
    return await handleRequest(() async {
      final response = await apiService.patch(
        endPoint: "${ApiEndPoints.assistantSessionBase}/$sessionId/name",
        body: {'sessionName': sessionName},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return AssistantSessionModel.fromJson(data);
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }
}
