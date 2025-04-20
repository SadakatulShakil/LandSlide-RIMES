// models/community_post_model.dart
class CommunityPost {
  final int? id;
  final String title;
  final String description;
  final String imagePath;
  final int likes;
  final bool isLiked; // Add this field
  final DateTime createdAt;
  final int commentCount; // Add comment count

  CommunityPost({
    this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    this.likes = 0,
    this.isLiked = false, // Default to false
    this.commentCount = 0, // Default to 0
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Update copyWith to include new fields
  CommunityPost copyWith({
    int? id,
    String? title,
    String? description,
    String? imagePath,
    int? likes,
    bool? isLiked,
    int? commentCount,
    DateTime? createdAt,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}