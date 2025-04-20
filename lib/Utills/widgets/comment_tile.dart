// widgets/comment_tile.dart
import 'package:flutter/material.dart';

import '../../models/comment_model.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(comment.content),
      subtitle: Text(
        '${comment.createdAt.day}/${comment.createdAt.month}/${comment.createdAt.year}',
      ),
    );
  }
}