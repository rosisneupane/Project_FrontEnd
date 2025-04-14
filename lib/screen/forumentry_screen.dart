import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ui/screen/conversation_list_screen.dart';
import 'package:new_ui/screen/join_conversation_screen.dart';
import 'package:new_ui/screen/start_conversation_screen.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class ForumEntryScreen extends StatelessWidget {
   ForumEntryScreen({super.key});

final List<Map<String, dynamic>> forumOptions = [
  {
    'label': 'Responding to a group',
    'image': 'assets/images/ManSpeech.svg',
    'screen': const ConversationListScreen(), 
  },
  {
    'label': 'Starting a conversation',
    'image': 'assets/images/ManSpeech.svg',
    'screen': const StartConversationScreen(),
  },
  {
    'label': 'Joining a group activity',
    'image': 'assets/images/ManSpeech.svg',
    'screen': const JoinConversationScreen(), 
  },
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  // IconButton(
                  //   icon: const Icon(Icons.chevron_left),
                  //   color: AppColors.primary,
                  //   onPressed: () => Navigator.pop(context),
                  // ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Community Forum', style: AppTextStyles.title),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        "How would you like to\n engage with the community?",
                        style: AppTextStyles.question,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      ...List.generate(forumOptions.length, (index) {
                        return ForumOption(
                          label: forumOptions[index]['label']!,
                          imagePath: forumOptions[index]['image']!,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => forumOptions[index]['screen'], // Replace with your actual screens
                              ),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForumOption extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onTap;

  const ForumOption({
    super.key,
    required this.label,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 110,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF3F3B35),
                    fontSize: 16,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: SvgPicture.asset(
                  imagePath,
                  width: 120,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
