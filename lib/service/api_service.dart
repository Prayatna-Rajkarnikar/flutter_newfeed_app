import 'dart:convert';
import 'package:newsfeed_app/model/comment.dart';
import 'package:newsfeed_app/model/news_post.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:newsfeed_app/model/user.dart';

class ApiService {
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    print("Token: ${prefs.getString('token')}");
    return prefs.getString("token");
  }

  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("https://dummyjson.com/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = User.fromJson(data);
      final savedToken = await SharedPreferences.getInstance();
      await savedToken.setString("token", user.token);
      print("Token saved: ${user.token}");

      // Print the token again to check if it's stored properly
      final token = savedToken.getString("token");
      print("Retrieved token: $token");

      return user;
    } else {
      print("Login failed: ${response.body}");
      return null;
    }
  }

  Future<List<NewsPost>> getNews() async {
    final response = await http.get(Uri.parse("https://dummyjson.com/posts"));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['posts'];
      return data.map((post) => NewsPost.fromJson(post)).toList();
    } else {
      throw Exception("Failed to laod news");
    }
  }

  Future<NewsPost> getNewsDetail(int id) async {
    final response = await http.get(
      Uri.parse("https://dummyjson.com/posts/$id"),
    );

    if (response.statusCode == 200) {
      return NewsPost.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Filed to load news details");
    }
  }

  Future<List<Comment>> getComments(int newsId) async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/comments/post/$newsId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['comments'];
      return data.map((e) => Comment.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load comments");
    }
  }

  Future<NewsPost?> addNewsPost(NewsPost news) async {
    final token = await getToken();

    if (token == null) {
      print("Error: No token found");
      return null;
    }

    final response = await http.post(
      Uri.parse('https://dummyjson.com/posts/add'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'id': news.id,
        'title': news.title,
        'body': news.body,
        'userId': news.userId,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print("Post Created Successfully");
      return NewsPost.fromJson(responseData);
    } else {
      print("Error: ${response.body}");
      return null;
    }
  }
}
