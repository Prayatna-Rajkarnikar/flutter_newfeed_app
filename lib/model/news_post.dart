class NewsPost {
  final int id;
  final String title;
  final String body;
  final int userId;

  NewsPost({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  factory NewsPost.fromJson(Map<String, dynamic> json) {
    return NewsPost(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      userId: json['userId'],
    );
  }
}
