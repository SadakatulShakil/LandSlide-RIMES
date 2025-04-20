// models/comment_model.dart
class Comment {
  final int? id;
  final int postId;
  final String content;
  final DateTime createdAt;

  Comment({
    this.id,
    required this.postId,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}