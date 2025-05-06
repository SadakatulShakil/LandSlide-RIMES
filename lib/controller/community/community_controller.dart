// controllers/community_controller.dart
import 'package:get/get.dart';

import '../../models/comment_model.dart';
import '../../models/community_post_model.dart';
import '../../services/db_service.dart';
// import '../services/api_urls.dart';

class CommunityController extends GetxController {
  final DBService dbService = Get.find();
  // final ApiService apiService = Get.find();

  final RxList<CommunityPost> posts = <CommunityPost>[].obs;
  final RxList<Comment> comments = <Comment>[].obs;
  final RxBool isLoading = true.obs;
  final RxInt selectedPostId = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  Future<void> loadPosts() async {
    isLoading.value = true;
    try {
      // For API version:
      // posts.value = await apiService.getPosts();

      // For offline version:
      posts.value = await dbService.getPosts();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load posts');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createPost(CommunityPost post) async {
    try {
      // For API version:
      // final newPost = await apiService.createPost(post);
      // posts.insert(0, newPost);

      // For offline version:
      await dbService.savePost(post);
      await loadPosts();
    } catch (e) {
      Get.snackbar('Error', 'Failed to create post');
    }
  }

  // Future<void> likePost(int postId) async {
  //   try {
  //     final post = posts.firstWhere((p) => p.id == postId);
  //     final updatedPost = post.copyWith(likes: post.likes + 1);
  //
  //     // For API version:
  //     // await apiService.likePost(postId);
  //     // posts[posts.indexWhere((p) => p.id == postId)] = updatedPost;
  //
  //     // For offline version:
  //     await dbService.updatePost(updatedPost);
  //     await loadPosts();
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to like post');
  //   }
  // }

  // controllers/community_controller.dart
  Future<void> toggleLike(int postId) async {
    try {
      final post = posts.firstWhere((p) => p.id == postId);
      final isLiked = post.isLiked; // Add this field to your CommunityPost model
      final updatedPost = post.copyWith(
        likes: isLiked ? post.likes - 1 : post.likes + 1,
        isLiked: !isLiked,
      );

      // For offline version:
      await dbService.updatePost(updatedPost);
      await loadPosts();

      // For API version (commented out):
      // await apiService.toggleLike(postId);
      // posts[posts.indexWhere((p) => p.id == postId)] = updatedPost;
    } catch (e) {
      Get.snackbar('Error', 'Failed to toggle like');
    }
  }

  Future<void> loadComments(int postId) async {
    isLoading.value = true;
    selectedPostId.value = postId;
    try {
      // For API version:
      // comments.value = await apiService.getComments(postId);

      // For offline version:
      comments.value = await dbService.getCommentsForPost(postId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load comments');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> addComment(String content) async {
    if (selectedPostId.value == -1) return;

    final comment = Comment(
      postId: selectedPostId.value,
      content: content,
    );

    try {
      // For offline version:
      await dbService.addComment(comment);

      // Refresh comments list
      await loadComments(selectedPostId.value);

      // Update the comment count in the post
      final postIndex = posts.indexWhere((p) => p.id == selectedPostId.value);
      if (postIndex != -1) {
        final currentPost = posts[postIndex];
        final updatedPost = currentPost.copyWith(
          commentCount: currentPost.commentCount + 1,
        );
        posts[postIndex] = updatedPost;
        await dbService.updatePost(updatedPost);
      }

      // For API version (commented out):
      // final newComment = await apiService.addComment(comment);
      // comments.insert(0, newComment);
      // // You would need API endpoint to update comment count
    } catch (e) {
      Get.snackbar('Error', 'Failed to add comment');
    }
  }
}