import 'package:MARN/features/chatboot/domain/entities/assistant_session_entity.dart';

class AssistantSessionModel extends AssistantSessionEntity {
  const AssistantSessionModel({
    required super.sessionId,
    required super.sessionName,
    required super.createdAt,
    required super.updatedAt,
    super.lastMessagePreview,
    super.lastMessageAt,
  });

  factory AssistantSessionModel.fromJson(Map<String, dynamic> json) {
    return AssistantSessionModel(
      sessionId: json['sessionId'] ?? '',
      sessionName: json['sessionName'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
      lastMessagePreview: json['lastMessagePreview'],
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.tryParse(json['lastMessageAt'].toString())
          : null,
    );
  }
}
