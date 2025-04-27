import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:new_ui/config.dart';
import 'package:new_ui/model/schedule.dart';
import 'package:new_ui/screen/ai_therapist_screen.dart';
import 'package:new_ui/screen/createschedule_screen.dart';
import 'package:new_ui/screen/job_interview_roleplay_screen.dart';
import 'package:new_ui/screen/resources_screen.dart';
import 'package:new_ui/screen/social_scenario_screen.dart';
import 'package:new_ui/screen/stop_watch_timer_screen.dart';
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

      final response = await http.get(
        Uri.parse('${AppConfig.apiUrl}/routines'),
        headers: {
          'Authorization': 'Bearer $token',
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to load schedule. Please try again.')),
        );
      }
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
              child: RefreshIndicator(
                onRefresh: fetchScheduleData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        "CUHK AI Therapist is here with you",
                        style: AppTextStyles.question,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      const MoodSelectorCard(),
                      const SizedBox(height: 28),

// Grid of Categories
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          GestureDetector(
                                                        onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const StopwatchTimerScreen()),
                              );
                            },
                            child: FeatureContainer(
                                icon: Icons.school, label: 'Education'),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const JobInterviewRoleplayScreen()),
                                );
                              },
                              child: FeatureContainer(
                                  icon: Icons.work, label: 'Work')),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SocialScenarioPage()),
                                );
                              },
                              child: FeatureContainer(
                                  icon: Icons.group, label: 'Social')),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CreateScheduleScreen()),
                                );
                              },
                              child: FeatureContainer(
                                  icon: Icons.spa, label: 'Self Care')),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ResourcesScreen()),
                              );
                            },
                            child: FeatureContainer(
                                icon: Icons.sports_esports, label: 'Leisure'),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AiTherapistScreen()),
                              );
                            },
                            child: FeatureContainer(
                                icon: Icons.chat_bubble_outline,
                                label: 'EaseTalk'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Schedule Header
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
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CreateScheduleScreen(),
                                ),
                              );
                            },
                            child: const Text(
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

                      // Horizontal Schedule Cards
                      SizedBox(
                        height: 150,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : scheduleData.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 10),
                                      const Text(
                                        "No Schedules",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
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
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureContainer extends StatelessWidget {
  final IconData icon;
  final String label;
  const FeatureContainer({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              size: 36,
              color: AppColors.primary), // Change primary color if needed
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4E3321),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
