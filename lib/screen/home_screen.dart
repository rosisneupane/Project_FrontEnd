import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:new_ui/config.dart';
import 'package:new_ui/helper/home_features.dart';
import 'package:new_ui/model/schedule.dart';
import 'package:new_ui/screen/createschedule_screen.dart';
import 'package:new_ui/screen/menu_screen.dart';
import 'package:new_ui/screen/scheduledetail_screen.dart';
import 'package:new_ui/widgets/drawer_widget.dart';
import 'package:new_ui/widgets/feature_container.dart';
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
                        "Therapy Thread is here with you",
                        style: AppTextStyles.question,
                        textAlign: TextAlign.center,
                      ),

                      const MoodSelectorCard(),
                      const SizedBox(height: 18),

                      // Schedule Header
                      scheduleData.isEmpty
                          ? SizedBox()
                          : Row(
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
                      scheduleData.isEmpty
                          ? SizedBox()
                          : SizedBox(
                              height: 150,
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : scheduleData.isEmpty
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ScheduleDetailPage(
                                                      id: item.id,
                                                      date: item.date,
                                                      time: item.time,
                                                      text: item.text,
                                                      status: item.status,
                                                      onDelete: () {
                                                        setState(() {
                                                          scheduleData
                                                              .removeAt(index);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 12.0),
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
                                              ),
                                            );
                                          },
                                        ),
                            ),

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
                            child: HomeFeatureContainer(
                              icon: feature.icon,
                              label: feature.label,
                            ),
                          );
                        },
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
