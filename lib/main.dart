import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:new_ui/config.dart';
import 'package:new_ui/model/user.dart';
import 'package:new_ui/screen/signin_screen.dart';
import 'package:new_ui/screen/simple_nav_screen.dart';
import 'package:new_ui/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    String url = AppConfig.apiUrl;

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('$url/user/me'), // change to your endpoint
          headers: { 
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final user = User.fromJson(data);
          UserService().setUser(user); // Save globally

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SimpleBottomNav()),
          );
        } else {
          // Token invalid or error
          Navigator.pushReplacement( 
            context,
            MaterialPageRoute(builder: (context) => const SignIn()),
          );
        }
      } catch (e) {
        debugPrint('Error fetching user: $e');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      }
    } else { 
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
