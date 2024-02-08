import 'package:flutter/material.dart';
import 'package:flutterdemo/models/post_model.dart';

// Widget for displaying a single post as a card.
class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onEdit;

  // Constructor to initialize the post data and edit callback.
  const PostCard({Key? key, required this.post, required this.onEdit})
      : super(key: key);

  // Build the card layout for displaying post details.
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with post ID and edit button.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Post ID: ${post.id}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Display user ID associated with the post.
            Text(
              'User ID: ${post.userId}',
            ),
            const SizedBox(height: 5),
            // Post title section.
            const Text(
              'Title:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(post.title),
            const SizedBox(height: 5),
            // Post body content section.
            const Text(
              'Body:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(post.body),
          ],
        ),
      ),
    );
  }
}
