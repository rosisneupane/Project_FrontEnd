import 'dart:convert';

import 'package:new_ui/config.dart';
import 'package:new_ui/model/user.dart';
import 'package:new_ui/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserScoreService {
  static Future<void> updateUserScore(int newScore) async {
    String url = AppConfig.apiUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('JWT Token not found');
    }

    final response = await http.put(
      Uri.parse('$url/user/score?new_score=$newScore'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Score updated successfully');
      final data = json.decode(response.body);
      final user = User.fromJson(data);
      UserService().setUser(user);
    } else {
      print('Failed to update score: ${response.body}');
      throw Exception('Failed to update score: ${response.reasonPhrase}');
    }
  }
}
