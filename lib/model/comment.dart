import 'package:newsfeed_app/model/user.dart';

class Comment {
  final int id;
  final String body;
  final int newsId;
  final int likes;
  final User user;

  Comment({
    required this.id,
    required this.body,
    required this.newsId,
    required this.likes,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      body: json['body'],
      newsId: json['postId'],
      likes: json['likes'],
      user: User.fromJson(json['user']),
    );
  }
}
