import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ui/screen/texttotext_screen.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class AiTherapistScreen extends StatefulWidget {
  const AiTherapistScreen({super.key});

  @override
  State<AiTherapistScreen> createState() => _AiTherapistScreenState();
}

class _AiTherapistScreenState extends State<AiTherapistScreen> {


  final List<Map<String, String>> interactionModes = [
    {
      'label': 'You: Speech\n AI: Speech',
      'image': 'assets/images/ManSpeech.svg',
    },
    {
      'label': 'You: Speech\n AI: Text',
      'image': 'assets/images/ManSpeechTwo.svg',
    },
    {
      'label': 'You: Text\n AI: Text',
      'image': 'assets/images/RobotText.svg',
    },
    {
      'label': 'You: Text\n AI: Speech',
      'image': 'assets/images/RobotTextTwo.svg',
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
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left),
                      color: AppColors.primary,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('AI Therapist Chat', style: AppTextStyles.title),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7D944D),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Text('Network OK', style: AppTextStyles.button),
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
                        "How would you like to\n interact with the AI?",
                        style: AppTextStyles.question,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      ...List.generate(interactionModes.length, (index) {
                        return InteractionOption(
                          label: interactionModes[index]['label']!,
                          imagePath: interactionModes[index]['image']!,
                          
                          onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatPage()),
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

class InteractionOption extends StatelessWidget {
  final String label;
  final String imagePath;

  final VoidCallback onTap;

  const InteractionOption({
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
              color:  Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                  width: 150,
                  height: 100,
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
