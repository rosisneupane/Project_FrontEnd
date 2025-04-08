import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class DayWithMood {
  final String day;
  final IconData moodIcon;

  DayWithMood({required this.day, required this.moodIcon});
}

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final List<DayWithMood> daysWithMoods = [
    DayWithMood(day: 'Mon', moodIcon: Icons.sentiment_very_satisfied),
    DayWithMood(day: 'Tue', moodIcon: Icons.sentiment_satisfied),
    DayWithMood(day: 'Wed', moodIcon: Icons.sentiment_dissatisfied),
    DayWithMood(day: 'Thu', moodIcon: Icons.sentiment_very_dissatisfied),
    DayWithMood(day: 'Fri', moodIcon: Icons.sentiment_neutral),
    DayWithMood(day: 'Sat', moodIcon: Icons.sentiment_very_satisfied),
    DayWithMood(day: 'Sun', moodIcon: Icons.sentiment_satisfied),
  ];

  Color getMoodColor(IconData icon) {
    switch (icon) {
      case Icons.sentiment_very_satisfied:
        return Colors.green;
      case Icons.sentiment_satisfied:
        return Colors.lightGreen;
      case Icons.sentiment_neutral:
        return Colors.orange;
      case Icons.sentiment_dissatisfied:
        return Colors.redAccent;
      case Icons.sentiment_very_dissatisfied:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    color: AppColors.primary,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Analytics', style: AppTextStyles.title),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF936C),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Text('Low', style: AppTextStyles.button),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Center(
                      child: Text(
                        "Checkout your recent\n performance 🤩",
                        style: AppTextStyles.question,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Weekly Report',
                      style: TextStyle(
                        color: Color(0xFF4E3321),
                        fontSize: 30,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w800,
                        height: 1.27,
                        letterSpacing: -0.30,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Mood List
                    Container(
                      height: 90,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: daysWithMoods.length,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemBuilder: (context, index) {
                          final item = daysWithMoods[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  item.moodIcon,
                                  size: 30,
                                  color: getMoodColor(item.moodIcon),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  item.day,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20), // Padding below
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
