import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ui/widgets/rounded_button.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class PhysicalDestressScreen extends StatefulWidget {
  const PhysicalDestressScreen({super.key});

  @override
  State<PhysicalDestressScreen> createState() => _PhysicalDestressScreenState();
}

class _PhysicalDestressScreenState extends State<PhysicalDestressScreen> {
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
                        "Are you experiencing any\n physical distress?",
                        style: AppTextStyles.question,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      PainSelectionScreen(),
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

class PainSelectionScreen extends StatefulWidget {
  const PainSelectionScreen({super.key});

  @override
  _PainSelectionScreenState createState() => _PainSelectionScreenState();
}

class _PainSelectionScreenState extends State<PainSelectionScreen> {
  int _selectedIndex = 1; // 0 = Yes, 1 = No (default selected)

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSelectableCard(
          index: 0,
          title: "Yes, one or multiple",
          description:
              "I'm experiencing physical pain in different place over my body.",
        ),
        SizedBox(height: 20),
        _buildSelectableCard(
          index: 1,
          title: "No Physical Pain At All",
          description:
              "I'm not experiencing any physical pain in my body at all :)",
        ),
      ],
    );
  }

  Widget _buildSelectableCard({
    required int index,
    required String title,
    required String description,
  }) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFAED581) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isSelected ? Colors.green : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? Colors.white : Colors.black54,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
