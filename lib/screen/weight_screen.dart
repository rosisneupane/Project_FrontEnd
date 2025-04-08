import 'package:flutter/material.dart';
import 'package:new_ui/screen/professional_screen.dart';
import 'package:new_ui/widgets/rounded_button.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
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
                        "What’s your weight?",
                        style: AppTextStyles.question,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      WeightSelector(),
                      const SizedBox(height: 48),
                      RoundedButton(
                        onPressed: () {
                                                   Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfessionalScreen()),
                          );
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

class WeightSelector extends StatefulWidget {
  const WeightSelector({super.key});

  @override
  State<WeightSelector> createState() => _WeightSelectorState();
}

class _WeightSelectorState extends State<WeightSelector> {
  final int start = 120;
  final int end = 135;
  late int selectedValue;

  final ScrollController _scrollController = ScrollController();
  final double itemExtent = 42.0; // Width of each tick item including padding

  @override
  void initState() {
    super.initState();
    selectedValue = 128;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerOnValue(selectedValue);
    });
  }

  void _centerOnValue(int value) {
    final index = value - start;
    final screenWidth = MediaQuery.of(context).size.width;
    final offset = index * itemExtent - (screenWidth / 2 - itemExtent / 2);
    _scrollController
        .jumpTo(offset.clamp(0, _scrollController.position.maxScrollExtent));
  }

  void _onScroll() {
    final scrollOffset = _scrollController.offset;
    final screenWidth = MediaQuery.of(context).size.width;
    final centerOffset = scrollOffset + screenWidth / 2;
    final index = (centerOffset / itemExtent).round();
    final value = (index + start).clamp(start, end);
    if (value != selectedValue) {
      setState(() {
        selectedValue = value;
      });
    }
  }

  void _onScrollEnd() {
    final screenWidth = MediaQuery.of(context).size.width;
    final centerOffset = _scrollController.offset + screenWidth / 2;
    final index = (centerOffset / itemExtent).round();
    final value = (index + start).clamp(start, end);
    final targetOffset =
        index * itemExtent - (screenWidth / 2 - itemExtent / 2);

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );

    setState(() {
      selectedValue = value;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        // Selected value display
        RichText(
          text: TextSpan(
            text: '$selectedValue',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
            children: const [
              TextSpan(
                text: ' kg',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Tick bar with fixed center highlight
        SizedBox(
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification) {
                    _onScrollEnd();
                  } else if (notification is ScrollUpdateNotification) {
                    _onScroll();
                  }
                  return true;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: end - start + 1,
                  itemExtent: itemExtent,
                  itemBuilder: (context, index) {
                    final value = start + index;
                    final isLabel = value % 1 == 0;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 2,
                          height: value == selectedValue ? 60 : 40,
                          decoration: BoxDecoration(
                            color: Colors.brown[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (isLabel)
                          Text(
                            '$value',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.brown[300],
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),

              // Fixed center highlighter tick
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.green[400],
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
