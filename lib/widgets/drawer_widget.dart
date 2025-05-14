import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:new_ui/config.dart';
import 'package:new_ui/model/user.dart';
import 'package:path/path.dart';
import 'package:new_ui/screen/event_screen.dart';
import 'package:new_ui/screen/forumentry_screen.dart';
import 'package:new_ui/screen/job_interview_roleplay_screen.dart';
import 'package:new_ui/screen/quiz_screen.dart';
import 'package:new_ui/screen/signin_screen.dart';
import 'package:new_ui/screen/social_scenario_screen.dart';
import 'package:new_ui/theme/colors.dart';
import 'package:new_ui/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});
  final user = UserService();

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignIn()),
      (route) => false,
    );
  }

  void _showUploadModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndUploadImage(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('JWT Token not found');
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final uri = Uri.parse(
        '${AppConfig.apiUrl}/user/upload_profile_picture'); // Replace with your URL

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(
        await http.MultipartFile.fromPath('file', file.path,
            filename: basename(file.path)),
      );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      Navigator.of(context).pop(); // close progress dialog

      if (response.statusCode == 200) {
        // You can parse JSON here if needed
        // final data = jsonDecode(responseBody);
        print(responseBody);
              final data = json.decode(responseBody);
      final user = User.fromJson(data);
      UserService().setUser(user); // Save globally
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Upload successful')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: $responseBody')));
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final profilePic = user.user?.profilePicture;
    final username = user.user?.username ?? 'Guest';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _showUploadModal(context),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundImage: profilePic == null
                        ? AssetImage("assets/images/blank-profile.png")
                        : NetworkImage(profilePic) as ImageProvider,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  username,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.quiz),
            title: Text('Quiz'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const QuizPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Social Scenario'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SocialScenarioPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.work),
            title: Text('Job Interview Roleplay'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const JobInterviewRoleplayScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.forum),
            title: Text('Community'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ForumEntryScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Events'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EventListPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }
}
