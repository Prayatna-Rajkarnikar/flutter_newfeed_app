import 'package:flutter/material.dart';
import 'package:newsfeed_app/model/news_post.dart';
import 'package:newsfeed_app/model/user.dart';
import 'package:newsfeed_app/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  NewsPost? _newsPost;

  User? get user => _user;
  NewsPost? get newsPost => _newsPost;

  Future<bool> login(String username, String password) async {
    _user = await ApiService().login(username, password);

    if (_user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _user!.token);
      print("Token saved: ${_user!.token}");

      // Check if the token is saved correctly
      final token = prefs.getString('token');
      print("Saved token: $token");

      if (token == null) {
        print("Error: Token was not saved!");
      }
    }

    notifyListeners();
    return _user != null;
  }

  Future<int?> getUserIdFromToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      print("Error: Token is null or empty");
      return null;
    }

    try {
      if (!JwtDecoder.isExpired(token)) {
        final decodedToken = JwtDecoder.decode(token);
        print("Decoded Token: $decodedToken");
        if (decodedToken.containsKey('userId')) {
          return decodedToken['userId'];
        } else {
          print("Error: 'userId' not found in token payload.");
          return null;
        }
      }
    } catch (e) {
      print("Error decoding token: $e");
      return null;
    }

    return null;
  }

  Future<bool> addPost(NewsPost news) async {
    try {
      final token = await ApiService().getToken();

      if (token == null || JwtDecoder.isExpired(token)) {
        print("Error: Token is either null or expired.");
        return false;
      }

      _newsPost = await ApiService().addNewsPost(news);
      notifyListeners();

      return _newsPost != null;
    } catch (e) {
      print("Error adding post: $e");
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final savedToken = await SharedPreferences.getInstance();
    return savedToken.getString("token") != null;
  }
}
