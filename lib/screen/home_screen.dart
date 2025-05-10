import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:new_ui/config.dart';
import 'package:new_ui/model/schedule.dart';
import 'package:new_ui/screen/ai_therapist_screen.dart';
import 'package:new_ui/screen/analytics_screen.dart';
import 'package:new_ui/screen/createschedule_screen.dart';
import 'package:new_ui/screen/forumentry_screen.dart';
import 'package:new_ui/screen/hydration_tracker_screen.dart';
import 'package:new_ui/screen/job_interview_roleplay_screen.dart';
import 'package:new_ui/screen/menu_screen.dart';
import 'package:new_ui/screen/resource_file_screen.dart';
import 'package:new_ui/screen/resource_video_screen.dart';
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

class FeatureItem {
  final IconData icon;
  final String label;

  final List<MenuItem> menuItems;

  FeatureItem(
      {required this.icon, required this.label, required this.menuItems});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<ScheduleItem> scheduleData = [];
  bool isLoading = true;

  final List<FeatureItem> features = [
    FeatureItem(
      icon: Icons.school,
      label: 'Education',
      menuItems: [
        MenuItem(
            title: 'Focus timer',
            screen: CountdownTimerScreen(),
            icon: Icons.timer),
        MenuItem(
            title: 'SMART goal setting',
            screen: CreateScheduleScreen(),
            icon: Icons.flag),
        MenuItem(
            title: 'Visual task planner',
            screen: CreateScheduleScreen(),
            icon: Icons.view_agenda),
        MenuItem(
            title: 'Resource Files',
            screen: ResourceFilesScreen(type: "education"),
            icon: Icons.insert_drive_file),
        MenuItem(
            title: 'Resource Video',
            screen: ResourceVideoScreen(type: "education"),
            icon: Icons.video_library),
      ],
    ),
    FeatureItem(
      icon: Icons.work,
      label: 'Work',
      menuItems: [
        MenuItem(
            title: 'Career exploration quiz',
            screen: JobInterviewRoleplayScreen(),
            icon: Icons.quiz),
        MenuItem(
            title: 'Job interview role-play tool',
            screen: JobInterviewRoleplayScreen(),
            icon: Icons.mic),
        MenuItem(
            title: 'Resource Files',
            screen: ResourceFilesScreen(type: "work"),
            icon: Icons.insert_drive_file),
        MenuItem(
            title: 'Resource Video',
            screen: ResourceVideoScreen(type: "work"),
            icon: Icons.video_library),
      ],
    ),
    FeatureItem(
      icon: Icons.group,
      label: 'Social',
      menuItems: [
        MenuItem(
            title: 'Social role-play scenarios',
            screen: SocialScenarioPage(),
            icon: Icons.record_voice_over),
        MenuItem(
            title: 'Safe chat space',
            screen: ForumEntryScreen(),
            icon: Icons.forum),
        MenuItem(
            title: 'Badge system for social interactions',
            screen: SocialScenarioPage(),
            icon: Icons.emoji_events),
        MenuItem(
            title: 'Resource Files',
            screen: ResourceFilesScreen(type: "social"),
            icon: Icons.insert_drive_file),
        MenuItem(
            title: 'Resource Video',
            screen: ResourceVideoScreen(type: "social"),
            icon: Icons.video_library),
      ],
    ),
    FeatureItem(
      icon: Icons.spa,
      label: 'Self Care',
      menuItems: [
        MenuItem(
            title: 'Customizable morning/evening routine builder',
            screen: CreateScheduleScreen(),
            icon: Icons.wb_twilight),
        MenuItem(
            title: 'Grounding exercises',
            screen: CountdownTimerScreen(),
            icon: Icons.self_improvement),
        MenuItem(
            title: 'Hydration trackers',
            screen: HydrationTrackerScreen(),
            icon: Icons.local_drink),
        MenuItem(
            title: 'Resource Files',
            screen: ResourceFilesScreen(type: "self-care"),
            icon: Icons.insert_drive_file),
        MenuItem(
            title: 'Resource Video',
            screen: ResourceVideoScreen(type: "self-care"),
            icon: Icons.video_library),
      ],
    ),
    FeatureItem(
      icon: Icons.sports_esports,
      label: 'Leisure',
      menuItems: [
        MenuItem(
            title: 'Yoga and mindfulness routines',
            screen: ResourcesScreen(),
            icon: Icons.self_improvement),
        MenuItem(
            title: 'Gamified rewards',
            screen: AnalyticsScreen(showBack: true,),
            icon: Icons.stars),
        MenuItem(
            title: 'Cross-Functional Achievement badges',
            screen: AnalyticsScreen(showBack: true,),
            icon: Icons.military_tech),
        MenuItem(
            title: 'Resource Files',
            screen: ResourceFilesScreen(type: "leisure"),
            icon: Icons.insert_drive_file),
        MenuItem(
            title: 'Resource Video',
            screen: ResourceVideoScreen(type: "leisure"),
            icon: Icons.video_library),
      ],
    ),
    FeatureItem(
      icon: Icons.chat_bubble_outline,
      label: 'EaseTalk',
      menuItems: [
        MenuItem(
            title: 'Talk To AI',
            screen: AiTherapistScreen(showBack: true,),
            icon: Icons.smart_toy),
      ],
    ),
  ];

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
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: features.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        itemBuilder: (context, index) {
                          final feature = features[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MenuScreen(
                                    topBarTitle: feature.label,
                                    menuItems: feature.menuItems,
                                  ),
                                ),
                              );
                            },
                            child: FeatureContainer(
                              icon: feature.icon,
                              label: feature.label,
                            ),
                          );
                        },
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
