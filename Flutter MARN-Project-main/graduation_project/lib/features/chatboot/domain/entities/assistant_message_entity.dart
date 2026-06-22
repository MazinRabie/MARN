class AssistantMessageEntity {
  final String? messageId;
  final String? sessionId;
  final String role;
  final String content;
  final List<String> imagePaths;
  final DateTime createdAt;
  final bool pending;
  final bool failed;

  const AssistantMessageEntity({
    this.messageId,
    this.sessionId,
    required this.role,
    required this.content,
    this.imagePaths = const [],
    required this.createdAt,
    this.pending = false,
    this.failed = false,
  });

  AssistantMessageEntity copyWith({
    String? messageId,
    String? sessionId,
    String? role,
    String? content,
    List<String>? imagePaths,
    DateTime? createdAt,
    bool? pending,
    bool? failed,
  }) {
    return AssistantMessageEntity(
      messageId: messageId ?? this.messageId,
      sessionId: sessionId ?? this.sessionId,
      role: role ?? this.role,
      content: content ?? this.content,
      imagePaths: imagePaths ?? this.imagePaths,
      createdAt: createdAt ?? this.createdAt,
      pending: pending ?? this.pending,
      failed: failed ?? this.failed,
    );
  }
}
