import 'package:flutter/material.dart';
import 'package:new_ui/screen/ai_therapist_screen.dart';
import 'package:new_ui/screen/createschedule_screen.dart';
import 'package:new_ui/screen/forumentry_screen.dart';
import 'package:new_ui/screen/home_screen.dart';
import 'package:new_ui/screen/hydration_tracker_screen.dart';
import 'package:new_ui/screen/job_interview_roleplay_screen.dart';
import 'package:new_ui/screen/menu_screen.dart';
import 'package:new_ui/screen/resource_file_screen.dart';
import 'package:new_ui/screen/resource_video_screen.dart';
import 'package:new_ui/screen/social_scenario_screen.dart';
import 'package:new_ui/screen/stop_watch_timer_screen.dart';

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
      // MenuItem(
      //     title: 'Badge system for social interactions',
      //     screen: SocialScenarioPage(),
      //     icon: Icons.emoji_events),
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
      // MenuItem(
      //     title: 'Yoga and mindfulness routines',
      //     screen: ResourcesScreen(),
      //     icon: Icons.self_improvement),
      // MenuItem(
      //     title: 'Gamified rewards',
      //     screen: AnalyticsScreen(
      //       showBack: true,
      //     ),
      //     icon: Icons.stars),
      // MenuItem(
      //     title: 'Cross-Functional Achievement badges',
      //     screen: AnalyticsScreen(
      //       showBack: true,
      //     ),
      //     icon: Icons.military_tech),
      MenuItem(
          title: 'Resource Files',
          screen: ResourceFilesScreen(type: "leisure"),
          icon: Icons.insert_drive_file),
      MenuItem(
          title: 'Mindfullness and Yoga Routines',
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
          screen: AiTherapistScreen(
            showBack: true,
          ),
          icon: Icons.smart_toy),
    ],
  ),
];
