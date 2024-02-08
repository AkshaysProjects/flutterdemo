class Post {
  final String id;
  final int userId;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  // Factory constructor to create a Post from a JSON map.
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
    );
  }
}
