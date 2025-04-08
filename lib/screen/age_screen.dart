import 'package:flutter/material.dart';
import 'package:new_ui/widgets/rounded_button.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  final int initialAge = 18;
  late final FixedExtentScrollController _controller;
  late final List<int> numbers;
  int selected = 18;

  @override
  void initState() {
    super.initState();
    numbers = List.generate(90, (index) => 1 + index); // 1 to 100
    _controller = FixedExtentScrollController(initialItem: initialAge - 1);
    selected = initialAge;
  }

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
                        "What’s your age?",
                        style: AppTextStyles.question,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      Center(
                        child: SizedBox(
                          height: 300,
                          width: 100,
                          child: ListWheelScrollView.useDelegate(
                            controller: _controller,
                            itemExtent:
                              120, // Increased from 60 to prevent clipping
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selected = numbers[index];
                              });
                            },
                            physics: const FixedExtentScrollPhysics(),
                            perspective: 0.005,
                            diameterRatio: 2.0,
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                if (index < 0 || index >= numbers.length)
                                  return null;

                                final number = numbers[index];
                                final isSelected = number == selected;

                                return Center(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isSelected ? 12 : 16,
                                      vertical: isSelected ? 16 : 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.green[400]
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(40),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: Colors.green
                                                    .withOpacity(0.4),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Text(
                                      '$number',
                                      style: TextStyle(
                                        fontSize: isSelected ? 56 : 28,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      RoundedButton(
                        onPressed: () {
                          // TODO: Handle continue with selected age
                          print("Selected Age: $selected");
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
