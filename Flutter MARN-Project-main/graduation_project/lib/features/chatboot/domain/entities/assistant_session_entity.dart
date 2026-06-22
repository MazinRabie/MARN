class AssistantSessionEntity {
  final String sessionId;
  final String sessionName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? lastMessagePreview;
  final DateTime? lastMessageAt;

  const AssistantSessionEntity({
    required this.sessionId,
    required this.sessionName,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessagePreview,
    this.lastMessageAt,
  });

  AssistantSessionEntity copyWith({
    String? sessionId,
    String? sessionName,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? lastMessagePreview,
    DateTime? lastMessageAt,
  }) {
    return AssistantSessionEntity(
      sessionId: sessionId ?? this.sessionId,
      sessionName: sessionName ?? this.sessionName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }
}
