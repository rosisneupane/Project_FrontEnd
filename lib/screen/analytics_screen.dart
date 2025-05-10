import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:new_ui/config.dart';
import 'package:new_ui/helper/analytics.dart';
import 'package:new_ui/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/colors.dart';
import '../theme/text_styles.dart';

class DayWithMood {
  final String day;
  final IconData moodIcon;
  final double moodScore;

  DayWithMood({
    required this.day,
    required this.moodIcon,
    required this.moodScore,
  });
}

class AnalyticsScreen extends StatefulWidget {
  final bool? showBack;
  const AnalyticsScreen({super.key, this.showBack});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List<DayWithMood> daysWithMoods = [];
  bool isLoading = true;
  String url = AppConfig.apiUrl;

  final moodScoresMap = {
    0: Icons.sentiment_very_dissatisfied,
    1: Icons.sentiment_dissatisfied,
    2: Icons.sentiment_neutral,
    3: Icons.sentiment_satisfied,
    4: Icons.sentiment_very_satisfied,
  };

  IconData getIconForMood(int rating) =>
      moodScoresMap[rating] ?? Icons.sentiment_neutral;

  double getScoreFromRating(int rating) => (rating + 1).toDouble();

  String getShortDay(String dateString) {
    final date = DateTime.parse(dateString);
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

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

  String getMoodCategory() {
    if (daysWithMoods.isEmpty) return 'Low';
    final avg = daysWithMoods.map((e) => e.moodScore).reduce((a, b) => a + b) /
        daysWithMoods.length;
    if (avg >= 4.5) return 'High';
    if (avg >= 3.5) return 'Medium';
    return 'Low';
  }

  List<FlSpot> getMoodSpots() {
    return List.generate(daysWithMoods.length, (index) {
      return FlSpot(index.toDouble(), daysWithMoods[index].moodScore);
    });
  }

  Future<void> fetchMoodData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('JWT Token not found');
      }

      final response = await http.get(
        Uri.parse('$url/mood/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<DayWithMood> moods = data.map((entry) {
          final rating = entry['mood_rating'];
          final date = entry['date'];
          return DayWithMood(
            day: getShortDay(date),
            moodIcon: getIconForMood(rating),
            moodScore: getScoreFromRating(rating),
          );
        }).toList();

        setState(() {
          daysWithMoods = moods.take(7).toList(); // Limit to 7 most recent
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load mood data');
      }
    } catch (e) {
      debugPrint('Error fetching mood data: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMoodData();
  }

  @override
  Widget build(BuildContext context) {
    final int score = UserService().user?.score ?? 0;
    final double progressValue = getProgressValue(score);
    const double progressBarHeight = 20; // you can tweak this
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: widget.showBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
        title: const Text('Analytics', style: AppTextStyles.title),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
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
                          Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(getBadgeImage(score)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Row: Previous badge, ProgressBar, Next badge
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Previous Badge
                              Image.asset(
                                getPreviousBadgeImage(score),
                                height: progressBarHeight,
                                width: progressBarHeight,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 8),

                              // Progress Bar
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: progressBarHeight,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: progressValue,
                                      child: Container(
                                        height: progressBarHeight,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        '$score',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Next Badge
                              Image.asset(
                                getNextBadgeImage(score),
                                height: progressBarHeight,
                                width: progressBarHeight,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),

                          const Text(
                            'Weekly Report',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4E3321),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              itemBuilder: (context, index) {
                                final item = daysWithMoods[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
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

                          const SizedBox(height: 28),

                          const Text(
                            'Mood Trend',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4E3321),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Line Chart
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: SizedBox(
                              height: 200,
                              child: LineChart(
                                LineChartData(
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 1,
                                        getTitlesWidget: (value, meta) {
                                          final index = value.toInt();
                                          if (index < 0 ||
                                              index >= daysWithMoods.length) {
                                            return const SizedBox.shrink();
                                          }
                                          return Text(
                                            daysWithMoods[index].day,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black54,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 1,
                                        getTitlesWidget: (value, _) {
                                          if (value < 1 || value > 5) {
                                            return const SizedBox.shrink();
                                          }
                                          return Text(
                                            value.toInt().toString(),
                                            style: const TextStyle(
                                                color: Colors.black45),
                                          );
                                        },
                                      ),
                                    ),
                                    rightTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    topTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                  ),
                                  gridData: FlGridData(show: true),
                                  borderData: FlBorderData(show: false),
                                  minX: 0,
                                  maxX: daysWithMoods.length - 1,
                                  minY: 1,
                                  maxY: 5,
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: getMoodSpots(),
                                      isCurved: true,
                                      color: AppColors.primary,
                                      barWidth: 4,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(show: true),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
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
