import 'package:flutter/material.dart';
import 'package:newsfeed_app/screens/login_screen.dart';
import 'package:newsfeed_app/screens/newsfeed_screen.dart';
import 'package:newsfeed_app/screens/register_screen.dart';
import 'package:newsfeed_app/service/auth_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AuthProvider())],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/register_screen': (context) => RegisterScreen(),
          '/newsfeed_screen': (context) => NewsfeedScreen(),
        },
      ),
    ),
  );
}
