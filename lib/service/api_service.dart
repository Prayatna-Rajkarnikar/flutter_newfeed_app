import 'dart:convert';
import 'package:newsfeed_app/model/news_post.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:newsfeed_app/model/user.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com';

  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = User.fromJson(data);
      final savedToken = await SharedPreferences.getInstance();
      savedToken.setString("token", user.token);
      return user;
    } else {
      return null;
    }
  }

  Future<List<NewsPost>> getNews() async {
    final response = await http.get(Uri.parse("$baseUrl/posts"));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['posts'];
      return data.map((post) => NewsPost.fromJson(post)).toList();
    } else {
      throw Exception("Failed to laod news");
    }
  }
}
