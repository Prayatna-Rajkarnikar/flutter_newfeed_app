import 'package:flutter/material.dart';
import 'package:newsfeed_app/model/comment.dart';
import 'package:newsfeed_app/service/api_service.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.newsID});

  final int newsID;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late Future<List<Comment>> _comment;

  @override
  void initState() {
    super.initState();
    _comment = ApiService().getComments(widget.newsID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _comment,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading comments"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final comments = snapshot.data![index];
                return Card(
                  child: Column(
                    children: [
                      Text(comments.user.username),
                      Text(comments.body),
                      Text(comments.likes.toString()),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
