// services/db_service.dart
import 'package:get/get.dart';
import '../database_helper/database.dart';
import '../database_helper/entities/comment_entities.dart';
import '../database_helper/entities/post_entities.dart';
import '../database_helper/entities/report_entities.dart';
import '../models/community_post_model.dart';
import '../models/comment_model.dart';

class DBService extends GetxService {
  late AppDatabase _database;

  Future<DBService> init() async {
    _database = await $FloorAppDatabase
        .databaseBuilder('landslide_BD1.db')
        .build();
    return this;
  }

  // Post methods
  Future<List<CommunityPost>> getPosts() async {
    final entities = await _database.postDao.getAllPosts();
    return entities.map((e) => _postFromEntity(e)).toList();
  }

  Future<void> savePost(CommunityPost post) async {
    await _database.postDao.insertPost(_postToEntity(post));
  }

  Future<void> updatePost(CommunityPost post) async {
    await _database.postDao.updatePost(_postToEntity(post));
  }

  Future<CommunityPost?> getPost(int id) async {
    final entity = await _database.postDao.getPostById(id);
    return entity != null ? _postFromEntity(entity) : null;
  }

  Future<void> deletePost(int id) async {
    await _database.postDao.deletePost(id);
  }


  Future<List<Comment>> getCommentsForPost(int postId) async {
    final entities = await _database.commentDao.getCommentsForPost(postId);
    return entities.map((e) => _commentFromEntity(e)).toList();
  }

  Future<void> addComment(Comment comment) async {
    await _database.commentDao.insertComment(_commentToEntity(comment));

    // Update comment count
    final count = await _database.commentDao.getCommentCountForPost(comment.postId) ?? 0;
    await _database.commentDao.updateCommentCount(comment.postId, count);

    // Also update the post in memory
    final posts = await getPosts();
    final postIndex = posts.indexWhere((p) => p.id == comment.postId);
    if (postIndex != -1) {
      final post = posts[postIndex];
      posts[postIndex] = post.copyWith(commentCount: count);
    }
  }

  Future<void> deleteComment(int id) async {
    await _database.commentDao.deleteComment(id);
  }

  // Helper methods
  CommunityPost _postFromEntity(PostEntity entity) {
    return CommunityPost(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      imagePath: entity.imagePath,
      likes: entity.likes,
      isLiked: entity.isLiked == 1, // Convert to boolean
      commentCount: entity.commentCount,
      createdAt: DateTime.fromMillisecondsSinceEpoch(entity.createdAt),
    );
  }

  PostEntity _postToEntity(CommunityPost post) {
    return PostEntity(
      id: post.id,
      title: post.title,
      description: post.description,
      imagePath: post.imagePath,
      likes: post.likes,
      isLiked: post.isLiked ? 1 : 0, // Convert to int
      commentCount: post.commentCount,
      createdAt: post.createdAt.millisecondsSinceEpoch,
    );
  }

  CommentEntity _commentToEntity(Comment comment) {
    return CommentEntity(
      id: comment.id,
      postId: comment.postId,
      content: comment.content,
      createdAt: comment.createdAt.millisecondsSinceEpoch,
    );
  }

  Comment _commentFromEntity(CommentEntity entity) {
    return Comment(
      id: entity.id,
      postId: entity.postId,
      content: entity.content,
      createdAt: DateTime.fromMillisecondsSinceEpoch(entity.createdAt),
    );
  }



  //report
  Future<void> saveReport(LandslideReport reports) async {
    await _database.landslideReportDao.insertReport(reports);
  }
}