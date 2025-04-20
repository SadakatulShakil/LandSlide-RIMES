// views/post_detail_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utills/widgets/comment_tile.dart';
import '../Utills/widgets/post_card.dart';
import '../controller/community/community_controller.dart';

class PostDetailPage extends StatelessWidget {
  final int postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CommunityController>();
    final commentController = TextEditingController();

    // Load comments when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadComments(postId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: Obx(() {
        final post = controller.posts.firstWhereOrNull((p) => p.id == postId);
        if (post == null) {
          return const Center(child: Text('Post not found'));
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PostCard(post: post, onTap: null),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(),
                    ),
                    if (controller.isLoading.value)
                      const Center(child: CircularProgressIndicator())
                    else if (controller.comments.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No comments yet'),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.comments.length,
                        itemBuilder: (context, index) {
                          final comment = controller.comments[index];
                          return CommentTile(comment: comment);
                        },
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (commentController.text.isNotEmpty) {
                        controller.addComment(commentController.text);
                        commentController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}