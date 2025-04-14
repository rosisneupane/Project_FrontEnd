import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:new_ui/config.dart';
import 'package:new_ui/theme/colors.dart';
import 'package:new_ui/theme/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MoodSelectorCard extends StatefulWidget {
  const MoodSelectorCard({super.key});

  @override
  State<MoodSelectorCard> createState() => _MoodSelectorCardState();
}

class _MoodSelectorCardState extends State<MoodSelectorCard> {
  bool _hasSubmittedMood = false;
  int? selectedMood;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _checkMoodStatus();
  }

  Future<void> _checkMoodStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('JWT Token not found');
      }

      String url = AppConfig.apiUrl;
      final response = await http.get(
        Uri.parse('$url/mood/today/exist'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        if (response.body.trim() == 'true') {
          setState(() {
            _hasSubmittedMood = true;
          });
        } else {
          setState(() {
            _hasSubmittedMood = false;
          });
        }
        _loading = false;
      } else {
        throw Exception('Failed to check mood status');
      }
    } catch (e) {
      debugPrint('Error checking mood status: $e');
      setState(() {
        _hasSubmittedMood = true; // fallback to hide
        _loading = false;
      });
    }
  }

  void selectMood(int rating) async {
    // Retrieve the JWT token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('JWT Token not found');
    }

    String url = AppConfig.apiUrl;

    final response = await http.post(
      Uri.parse('$url/mood/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"mood_rating": rating}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _hasSubmittedMood = true;
      });
    } else {
      throw Exception('Failed to check mood status');
    }
  }

  IconData getMoodIcon(int rating) {
    switch (rating) {
      case 1:
        return Icons.sentiment_very_dissatisfied;
      case 2:
        return Icons.sentiment_dissatisfied;
      case 3:
        return Icons.sentiment_neutral;
      case 4:
        return Icons.sentiment_satisfied;
      case 5:
        return Icons.sentiment_very_satisfied;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(); // or a shimmer/skeleton if you like
    }

    if (_hasSubmittedMood) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How are you feeling today?",
              style: AppTextStyles.question,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                final rating = index + 1;
                final isSelected = selectedMood == rating;
                return GestureDetector(
                  onTap: () => selectMood(rating),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.2)
                          : Colors.transparent,
                    ),
                    child: Icon(
                      getMoodIcon(rating),
                      color: isSelected ? AppColors.primary : Colors.black26,
                      size: 32,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
