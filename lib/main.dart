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
          '/': (context) => AuthCheck(),
          '/register_screen': (context) => RegisterScreen(),
          '/newsfeed_screen': (context) => NewsfeedScreen(),
        },
      ),
    ),
  );
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool _isAuthenticated = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    bool isAuthenticated =
        await Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    setState(() {
      _isAuthenticated = isAuthenticated;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_isAuthenticated) {
      return NewsfeedScreen();
    } else {
      return LoginScreen();
    }
  }
}
