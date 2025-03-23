import 'package:flutter/material.dart';
import 'package:newsfeed_app/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<bool> isLoggedIn() async {
    final savedToken = await SharedPreferences.getInstance();
    return savedToken.getString("token") != null;
  }
}
