import 'package:flutter/material.dart';
import 'package:newsfeed_app/model/news_post.dart';
import 'package:newsfeed_app/screens/newsfeed_detail.dart';
import 'package:newsfeed_app/service/api_service.dart';

class NewsfeedScreen extends StatefulWidget {
  const NewsfeedScreen({super.key});

  @override
  State<NewsfeedScreen> createState() => _NewsfeedScreenState();
}

class _NewsfeedScreenState extends State<NewsfeedScreen> {
  late Future<List<NewsPost>> _newsPosts;

  @override
  void initState() {
    super.initState();
    _newsPosts = ApiService().getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Newsfeed")),
      body: FutureBuilder(
        future: _newsPosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading news"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final post = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsfeedDetail(newsId: post.id),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(post.title), Text(post.body)],
                      ),
                    ),
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
