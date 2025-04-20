// data/floor/entities/comment_entity.dart
import 'package:floor/floor.dart';
import 'package:lanslide_report/database_helper/entities/post_entities.dart';

@Entity(tableName: 'comments', foreignKeys: [
  ForeignKey(
    childColumns: ['post_id'],
    parentColumns: ['id'],
    entity: PostEntity,
  )
])
class CommentEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  @ColumnInfo(name: 'post_id')
  final int postId;
  final String content;
  final int createdAt;

  CommentEntity({
    this.id,
    required this.postId,
    required this.content,
    required this.createdAt,
  });
}