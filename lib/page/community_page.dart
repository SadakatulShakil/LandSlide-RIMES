// views/community_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanslide_report/page/post_details_page.dart';

import '../Utills/widgets/post_card.dart';
import '../controller/community/community_controller.dart';
import 'add_post_page.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommunityController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.to(AddPostPage())
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.posts.isEmpty) {
          return const Center(child: Text('No posts available'));
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadPosts(),
          child: ListView.builder(
            itemCount: controller.posts.length,
            itemBuilder: (context, index) {
              final post = controller.posts[index];
              return PostCard(
                post: post,
                onTap: () => Get.to(PostDetailPage(postId: post.id ?? 0))
              );
            },
          ),
        );
      }),
    );
  }
}