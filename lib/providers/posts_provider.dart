import 'package:flutter/foundation.dart';
import 'package:flutterdemo/models/post_model.dart'; // Ensure this is the correct path to your Post model
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class PostsProvider with ChangeNotifier {
  List<Post> _posts = [];
  final Logger _logger = Logger();

  // Getter to access the list of posts
  List<Post> get posts => _posts;

  // Fetches posts from the server and updates the local list
  Future<void> fetchPosts() async {
    final response =
        await http.get(Uri.parse('https://posts.akshaykakatkar.tech/posts'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      _posts = jsonResponse.map((data) => Post.fromJson(data)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // Creates a new post on the server
  Future<void> createPost(String title, String body, int? userId) async {
    final url = Uri.parse('https://posts.akshaykakatkar.tech/posts');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'body': body,
          'userId': userId,
        }),
      );

      if (response.statusCode == 201) {
        // Update local list with new post
        Map jsonResponse = json.decode(response.body);
        _posts.add(Post.fromJson(jsonResponse['post']));
        notifyListeners();
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      _logger.e("Post Creation Error: $e");
    }
  }

  // Updates an existing post on the server
  Future<void> updatePost(String id, String title, String body) async {
    final url = Uri.parse('https://posts.akshaykakatkar.tech/posts/$id');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'body': body,
        }),
      );

      if (response.statusCode == 200) {
        // Update local lost of posts
        int index = _posts.indexWhere((post) => post.id == id);
        if (index != -1) {
          Map jsonResponse = json.decode(response.body);
          _posts[index] = Post.fromJson(jsonResponse['post']);
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update post');
      }
    } catch (e) {
      _logger.e("Post Update Error: $e");
    }
  }
}
