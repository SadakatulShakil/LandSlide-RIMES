// services/api_urls.dart
/*
class ApiService extends GetConnect {
  final String baseUrl = 'https://your-api-url.com';

  Future<List<CommunityPost>> getPosts() async {
    final response = await get('$baseUrl/posts');
    if (response.status.hasError) {
      throw Exception('Failed to load posts');
    }
    return (response.body as List).map((e) => CommunityPost.fromJson(e)).toList();
  }

  Future<CommunityPost> createPost(CommunityPost post) async {
    final response = await post('$baseUrl/posts', post.toJson());
    if (response.status.hasError) {
      throw Exception('Failed to create post');
    }
    return CommunityPost.fromJson(response.body);
  }

  Future<void> likePost(int postId) async {
    final response = await post('$baseUrl/posts/$postId/like');
    if (response.status.hasError) {
      throw Exception('Failed to like post');
    }
  }

  Future<List<Comment>> getComments(int postId) async {
    final response = await get('$baseUrl/posts/$postId/comments');
    if (response.status.hasError) {
      throw Exception('Failed to load comments');
    }
    return (response.body as List).map((e) => Comment.fromJson(e)).toList();
  }

  Future<Comment> addComment(Comment comment) async {
    final response = await post('$baseUrl/comments', comment.toJson());
    if (response.status.hasError) {
      throw Exception('Failed to add comment');
    }
    return Comment.fromJson(response.body);
  }
}
*/