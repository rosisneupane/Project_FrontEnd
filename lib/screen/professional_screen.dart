import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ui/widgets/rounded_button.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class ProfessionalScreen extends StatefulWidget {
  const ProfessionalScreen({super.key});

  @override
  State<ProfessionalScreen> createState() => _ProfessionalScreenState();
}

class _ProfessionalScreenState extends State<ProfessionalScreen> {
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
                        "Have you sought\n professional help before?",
                        style: AppTextStyles.question,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      FractionallySizedBox(
                        widthFactor: 0.85, // between 0.80 and 0.90
                        child: SvgPicture.asset(
                          'assets/images/ProfessionalFrame.svg',
                          fit: BoxFit
                              .contain, // ensures it maintains aspect ratio
                        ),
                      ),
                      const SizedBox(height: 48),
                      YesNoSelector(),
                                            const SizedBox(height: 48),
                      RoundedButton(
                        onPressed: () {
                          // TODO: Handle continue with selected age
                        },
                        label: 'Continue',
                        // Optionally, add semanticLabel if you have voice accessibility in mind
                        // semanticLabel: 'Continue to the next screen after selecting age',
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
class YesNoSelector extends StatefulWidget {
  const YesNoSelector({super.key});

  @override
  State<YesNoSelector> createState() => _YesNoSelectorState();
}

class _YesNoSelectorState extends State<YesNoSelector> {
  String selected = 'Yes';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: ['Yes', 'No'].map((option) {
        final isSelected = selected == option;
        return GestureDetector(
          onTap: () {
            setState(() {
              selected = option;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 150, // You can easily change width
            height: 50,  // You can easily change height
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFA4C37E)
                  : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: isSelected
                  ? Border.all(color: const Color(0xFFDCE5C8))
                  : Border.all(color: Colors.transparent),
            ),
            child: Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.brown[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

