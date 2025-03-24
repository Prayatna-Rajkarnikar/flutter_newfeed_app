import 'package:flutter/material.dart';
import 'package:newsfeed_app/model/user.dart';
import 'package:newsfeed_app/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<bool> login(String username, String password) async {
    _user = await ApiService().login(username, password);
    notifyListeners();
    return _user != null;
  }

  Future<bool> isLoggedIn() async {
    final savedToken = await SharedPreferences.getInstance();
    return savedToken.getString("token") != null;
  }
}
