// data/floor/dao/comment_dao.dart
import 'package:floor/floor.dart';

import '../entities/comment_entities.dart';

@dao
abstract class CommentDao {
  @Query('SELECT * FROM comments WHERE post_id = :postId ORDER BY createdAt DESC')
  Future<List<CommentEntity>> getCommentsForPost(int postId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertComment(CommentEntity comment);

  @Query('DELETE FROM comments WHERE id = :id')
  Future<void> deleteComment(int id);

  @Query('SELECT COUNT(*) FROM comments WHERE post_id = :postId')
  Future<int?> getCommentCountForPost(int postId);

  @Query('UPDATE posts SET comment_count = :count WHERE id = :postId')
  Future<void> updateCommentCount(int postId, int count);
}