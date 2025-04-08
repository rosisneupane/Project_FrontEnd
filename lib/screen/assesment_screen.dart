import 'package:flutter/material.dart';
import 'package:new_ui/screen/gender_screen.dart';
import 'package:new_ui/widgets/assesment_option.dart';
import 'package:new_ui/widgets/rounded_button.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  int? selectedOption;

  @override
  Widget build(BuildContext context) {
    final options = [
      ('I wanna reduce stress', Icons.favorite),
      ('I wanna try CUHK AI Therapy', Icons.smart_toy),
      ('I want to cope with trauma', Icons.flag),
      ('I want to be a better person', Icons.mood),
      ('Just trying out the app, mate!', Icons.phone_android),
    ];

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
                    child: const Text('1 of 14', style: AppTextStyles.progress),
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
                        "What's your health goal?",
                        style: AppTextStyles.question,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      Column(
                        children: options.asMap().entries.map((entry) {
                          final index = entry.key;
                          final option = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AssessmentOption(
                              text: option.$1,
                              icon: Icon(option.$2),
                              isSelected: selectedOption == index,
                              onTap: () =>
                                  setState(() => selectedOption = index),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 48),
                      RoundedButton(
                        onPressed: () {
                                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GenderScreen()),
                          );
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
