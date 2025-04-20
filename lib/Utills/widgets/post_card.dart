// widgets/post_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanslide_report/Utills/AppColors.dart';
import 'package:share_plus/share_plus.dart';

import '../../controller/community/community_controller.dart';
import '../../models/community_post_model.dart';

class PostCard extends StatelessWidget {
  final CommunityPost post;
  final VoidCallback? onTap;

  const PostCard({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CommunityController>();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (post.imagePath.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    post.imagePath,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      height: 200,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                post.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 5),
              Text(
                post.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Obx(() {
                    final currentPost = controller.posts.firstWhereOrNull((p) => p.id == post.id);
                    final isLiked = currentPost?.isLiked ?? post.isLiked;
                    return IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? AppColors().app_primary : AppColors().app_primary,
                      ),
                      onPressed: () => controller.toggleLike(post.id!),
                    );
                  }),
                  Text(post.likes.toString()),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: Icon(Icons.comment, color: AppColors().app_primary),
                    onPressed: onTap,
                  ),
                  Text(post.commentCount.toString()), // Show comment count
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.share, color: AppColors().app_primary,),
                    onPressed: (){
                      Share.share('Topic: ${post.title}\nDescription: ${post.description}');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}