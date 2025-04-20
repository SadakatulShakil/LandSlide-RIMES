// data/floor/entities/post_entity.dart
import 'package:floor/floor.dart';

@Entity(tableName: 'posts')
class PostEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final String description;
  final String imagePath;
  final int likes;
  @ColumnInfo(name: 'is_liked')
  final int isLiked; // Store as int (0 or 1)
  @ColumnInfo(name: 'comment_count')
  final int commentCount;
  @ColumnInfo(name: 'created_at')
  final int createdAt;

  PostEntity({
    this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.likes,
    required this.isLiked,
    required this.commentCount,
    required this.createdAt,
  });
}