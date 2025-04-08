import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ui/widgets/rounded_button.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  int gender = 0;

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
                    child: Text('Assessment', style: AppTextStyles.title),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Text('2 of 14', style: AppTextStyles.progress),
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
                        "What’s your official\n gender?",
                        style: AppTextStyles.question,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            gender = 1;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 155,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black, // Border color
                              width: 2.0, // Border width
                            ),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: gender == 1
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(
                                          25), // 255 * 0.1 = 25.5 → 25
                                      spreadRadius: 4,
                                      blurRadius: 10,
                                      offset: Offset(0,
                                          4), // horizontal and vertical offset
                                    ),
                                  ]
                                : [],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'I am Male',
                                      style: TextStyle(
                                        color: const Color(0xFF3F3B35),
                                        fontSize: 16,
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Icon(Icons.male)
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: SvgPicture.asset(
                                  'assets/images/Male.svg',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit
                                      .cover, // Optional, helps with scaling
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            gender = 2;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 155,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black, // Border color
                              width: 2.0, // Border width
                            ),
                            borderRadius: BorderRadius.circular(
                                32), // Optional rounded corners
                            boxShadow: gender == 2
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(
                                          25), // 255 * 0.1 = 25.5 → 25
                                      spreadRadius: 4,
                                      blurRadius: 10,
                                      offset: Offset(0,
                                          4), // horizontal and vertical offset
                                    ),
                                  ]
                                : [],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'I am Female',
                                      style: TextStyle(
                                        color: const Color(0xFF3F3B35),
                                        fontSize: 16,
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Icon(Icons.female)
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: SvgPicture.asset(
                                  'assets/images/Female.svg',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit
                                      .cover, // Optional, helps with scaling
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      RoundedButton(
                        onPressed: () {
                          // Handle continue action here
                        },
                        label: 'Continue',
                      ),
                      const SizedBox(height: 48),
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
