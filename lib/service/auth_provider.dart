import 'package:flutter/material.dart';
import 'package:newsfeed_app/model/user.dart';
import 'package:newsfeed_app/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<bool> login(String username, String password) async {
    _user = await ApiService().login(username, password);

    if (_user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _user!.token);
    }

    notifyListeners();
    return _user != null;
  }

  Future<bool> isLoggedIn() async {
    final savedToken = await SharedPreferences.getInstance();
    return savedToken.getString("token") != null;
  }
}
