import 'package:flutter/material.dart';
import 'package:new_ui/widgets/rounded_button.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class StressScreen extends StatefulWidget {
  const StressScreen({super.key});

  @override
  State<StressScreen> createState() => _StressScreenState();
}

class _StressScreenState extends State<StressScreen> {
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
                        "How would you rate your\n stress level?",
                        style: AppTextStyles.question,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      StressLevelSelector(),
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



class StressLevelSelector extends StatefulWidget {
  const StressLevelSelector({super.key});

  @override
  _StressLevelSelectorState createState() => _StressLevelSelectorState();
}

class _StressLevelSelectorState extends State<StressLevelSelector> {
  int _selected = 5;

  final Map<int, String> descriptions = {
    1: "You're Super Chill.",
    2: "You're Doing Fine.",
    3: "A Bit Stressed, But Okay.",
    4: "Feeling Quite Tense.",
    5: "You Are Extremely Stressed Out.",
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$_selected',
          style: TextStyle(
            fontSize: 100,
            fontWeight: FontWeight.bold,
            color: Colors.brown[800],
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              int number = index + 1;
              bool isSelected = number == _selected;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selected = number;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.orange : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$number',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: 20),
        Text(
          descriptions[_selected] ?? '',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}