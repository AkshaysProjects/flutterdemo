import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterdemo/providers/auth_provider.dart';
import 'package:flutterdemo/providers/posts_provider.dart';
import 'package:flutterdemo/models/post_model.dart';
import 'package:flutterdemo/widgets/post_dialog.dart';
import 'package:flutterdemo/widgets/post_card.dart';

// HomePage widget with dynamic content based on state.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controllers for form inputs.
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();

  // Clean up controllers when widget is disposed.
  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  // Displays a dialog for creating or editing a post.
  void _showDialog({Post? post}) {
    // Set initial form values if editing an existing post.
    _titleController.text = post?.title ?? '';
    _bodyController.text = post?.body ?? '';
    _userIdController.text = post?.userId.toString() ?? '';

    // Show post creation or editing dialog.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PostDialog(
          post: post,
          titleController: _titleController,
          bodyController: _bodyController,
          userIdController: _userIdController,
          onSave: (title, body, userId) async {
            if (post == null) {
              // Create new post
              await Provider.of<PostsProvider>(context, listen: false)
                  .createPost(title, body, userId);
            } else {
              // Update existing post
              await Provider.of<PostsProvider>(context, listen: false)
                  .updatePost(post.id, title, body);
            }
            _navigateToHome();
          },
        );
      },
    );
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  // Initializes state and fetches posts on widget creation.
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<PostsProvider>(context, listen: false).fetchPosts(),
    );
  }

  // Builds the HomePage UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
          // Add post button
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showDialog(),
          ),
        ],
      ),
      // Main content area displaying posts or a loading indicator.
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Consumer<PostsProvider>(
          builder: (context, postsProvider, child) {
            if (postsProvider.posts.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: postsProvider.posts.length,
                itemBuilder: (context, index) {
                  // Display each post in a card.
                  return PostCard(
                    post: postsProvider.posts[index],
                    onEdit: () => _showDialog(post: postsProvider.posts[index]),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
