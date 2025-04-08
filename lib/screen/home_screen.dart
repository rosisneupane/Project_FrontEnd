import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ui/screen/texttotext_screen.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> interactionModes = [
    {
      'label': 'You: Speech\n AI: Speech',
      'image': 'assets/images/Female.svg',
    },
    {
      'label': 'You: Speech\n AI: Text',
      'image': 'assets/images/Female.svg',
    },
    {
      'label': 'You: Text\n AI: Text',
      'image': 'assets/images/Female.svg',
    },
    {
      'label': 'You: Text\n AI: Speech',
      'image': 'assets/images/Female.svg',
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
                    child: Image.asset("assets/images/ProPic1.png"),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Welcome, Jerry', style: AppTextStyles.title),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFB812),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Text('Golden', style: AppTextStyles.button),
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
                        "CUHK AI Therapist is\n here with you",
                        style: AppTextStyles.question,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'What makes your week?              ',
                                    style: TextStyle(
                                      color: const Color(0xFF4E3321),
                                      fontSize: 20,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w500,
                                      height: 1.90,
                                      letterSpacing: -0.20,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'View More...',
                                    style: TextStyle(
                                      color: const Color(0xFF736A66),
                                      fontSize: 12,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w400,
                                      height: 3.17,
                                      letterSpacing: -0.12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: List.generate(4, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '19 Apr: Completed SEEM3510 Asm ${index + 1}',
                                  style: TextStyle(
                                    color: Color(0xFF736A66),
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.05,
                                  ),
                                ),
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFA694F5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2468),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.face,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Schedule for the week ...',
                          style: TextStyle(
                            color: const Color(0xFF4E3321),
                            fontSize: 20,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                                            SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: interactionModes.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: SizedBox(
                                width: 300, // fixed width
                                child: InteractionOption(
                                  label: interactionModes[index]['label']!,
                                  imagePath: interactionModes[index]['image']!,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ChatPage()),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      )
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
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today, 4:30 pm',
                          style: TextStyle(
                            color: Color(0xFF3F3B35),
                            fontSize: 16,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.05,
                          ),
                        ),
                        Text(
                          'Meetings with Dr. Chan',
                          style: TextStyle(
                            color: Color(0xFF3F3B35),
                            fontSize: 10,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.03,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'At CUHK Medical Center',
                      style: TextStyle(
                        color: const Color(0xFF3F3B35),
                        fontSize: 8,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.02,
                      ),
                    )
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: SvgPicture.asset(
                  imagePath,
                  width: 150,
                  height: 113,
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
