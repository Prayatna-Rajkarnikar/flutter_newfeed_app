import 'package:flutter/material.dart';
import 'package:newsfeed_app/model/news_post.dart';
import 'package:newsfeed_app/service/api_service.dart';

class NewsfeedDetail extends StatefulWidget {
  const NewsfeedDetail({super.key, required this.newsId});

  final int newsId;

  @override
  State<NewsfeedDetail> createState() => _NewsfeedDetailState();
}

class _NewsfeedDetailState extends State<NewsfeedDetail> {
  late Future<NewsPost> _newsDetail;

  @override
  void initState() {
    super.initState();
    _newsDetail = ApiService().getNewsDetail(widget.newsId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _newsDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return (Center(child: Text("Error loading details")));
          } else {
            final news = snapshot.data!;
            return Column(children: [Text(news.title), Text(news.body)]);
          }
        },
      ),
    );
  }
}
