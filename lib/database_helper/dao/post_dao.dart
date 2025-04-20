// data/floor/dao/post_dao.dart
import 'package:floor/floor.dart';

import '../entities/post_entities.dart';

@dao
abstract class PostDao {
  @Query('SELECT * FROM posts ORDER BY created_at DESC')
  Future<List<PostEntity>> getAllPosts();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPost(PostEntity post);

  @Update()
  Future<void> updatePost(PostEntity post);

  @Query('SELECT * FROM posts WHERE id = :id')
  Future<PostEntity?> getPostById(int id);

  @Query('DELETE FROM posts WHERE id = :id')
  Future<void> deletePost(int id);
}