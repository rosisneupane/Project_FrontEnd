import 'package:flutter/material.dart';
import 'package:new_ui/screen/quiz_screen.dart';
import 'package:new_ui/screen/signin_screen.dart';
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

  @override
  Widget build(BuildContext context) {
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
                CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage("assets/images/ProPic1.png"),
                ),
                SizedBox(height: 12),
                Text(
                  user.user!.username,
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
            leading: Icon(Icons.settings),
            title: Text('Quiz'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuizPage()),
              );
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Settings'),
          //   onTap: () {
          //                                          Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                       builder: (context) => const ProfessionalScreen()),
          //                 );
          //   },
          // ),
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
