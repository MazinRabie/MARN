import 'package:MARN/core/widgets/buildImage_url.dart';
import 'package:MARN/features/chatboot/domain/entities/assistant_message_entity.dart';

class AssistantMessageModel extends AssistantMessageEntity {
  const AssistantMessageModel({
    super.messageId,
    super.sessionId,
    required super.role,
    required super.content,
    super.imagePaths,
    required super.createdAt,
  });

  factory AssistantMessageModel.fromJson(Map<String, dynamic> json) {
    return AssistantMessageModel(
      messageId: json['messageId'],
      sessionId: json['sessionId'],
      role: json['role'] ?? 'assistant',
      content: json['content'] ?? '',
      imagePaths:
          (json['imagePaths'] as List<dynamic>?)
              ?.map((e) => buildImageUrl(e.toString()) ?? '')
              .toList() ??
          const [],
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
