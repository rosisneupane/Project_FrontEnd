import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:new_ui/config.dart';
import 'package:new_ui/model/schedule.dart';
import 'package:new_ui/screen/createschedule_screen.dart';
import 'package:new_ui/widgets/drawer_widget.dart';
import 'package:new_ui/widgets/home_top_bar.dart';
import 'package:new_ui/widgets/mood_selector.dart';
import 'package:new_ui/widgets/schedule_card.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<ScheduleItem> scheduleData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchScheduleData();
  }

  Future<void> fetchScheduleData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('JWT Token not found');
      }

      String url = AppConfig.apiUrl;

      final response = await http.get(
        Uri.parse('$url/routines'),
        headers: {
          'Authorization': 'Bearer $token', // Pass JWT Token in Header
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          scheduleData =
              data.map((item) => ScheduleItem.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load schedule');
      }
    } catch (e) {
      debugPrint("Error fetching schedule: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            HomeTopBar(
              onProfileTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      "CUHK AI Therapist is\n here with you",
                      style: AppTextStyles.question,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    const MoodSelectorCard(),
                    const SizedBox(height: 28),

                    /// Weekly Highlight Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'What makes your week?',
                          style: TextStyle(
                            color: Color(0xFF4E3321),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'View More...',
                          style: TextStyle(
                            color: Color(0xFF736A66),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    /// Weekly Activities
                    ...List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '19 Apr: Completed SEEM3510 Asm ${index + 1}',
                              style: const TextStyle(
                                color: Color(0xFF736A66),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: const Color(0xFFA694F5),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(
                                Icons.face,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    /// Schedule Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Schedule for the week ...',
                          style: TextStyle(
                            color: Color(0xFF4E3321),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateScheduleScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Create More...',
                            style: TextStyle(
                              color: Color(0xFF736A66),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// Horizontal Schedule Cards
                    SizedBox(
                      height: 150,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : scheduleData.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No Schedules",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: scheduleData.length,
                                  itemBuilder: (context, index) {
                                    final item = scheduleData[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      child: SizedBox(
                                        width: 300,
                                        child: ScheduleCard(
                                          id: item.id,
                                          date: item.date,
                                          time: item.time,
                                          text: item.text,
                                          status: item.status,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    ),
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
