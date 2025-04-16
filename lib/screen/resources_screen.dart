import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ui/config.dart';
import 'package:new_ui/model/collection.dart';
import 'package:new_ui/screen/texttotext_screen.dart';
import 'package:new_ui/screen/video_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import 'package:http/http.dart' as http;

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  bool isLoading = true;
  List<Collection> selfHelpVideos = [];

  @override
  void initState() {
    super.initState();
    fetchSelfHelpVideos();
  }

  Future<void> fetchSelfHelpVideos() async {
    try {
      String url = AppConfig.apiUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('JWT Token not found');
      }

      final response = await http.get(
        Uri.parse('$url/collections/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        print(response.body.toString());
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          selfHelpVideos =
              data.map((videoJson) => Collection.fromJson(videoJson)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle errors gracefully
      print("Error fetching videos: $e");
      setState(() {
        isLoading = false;
      });
    }
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
                  // Container(
                  //   width: 48,
                  //   height: 48,
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     border: Border.all(color: AppColors.primary),
                  //   ),
                  //   child: IconButton(
                  //     icon: const Icon(Icons.chevron_left),
                  //     color: AppColors.primary,
                  //     onPressed: () => Navigator.pop(context),
                  //   ),
                  // ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Resources', style: AppTextStyles.title),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7D944D),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Text('Verified', style: AppTextStyles.button),
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
                        "Here’re the resources\n tailored for you 😀 ",
                        style: AppTextStyles.question,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: Text('Mindfulness ✨',
                            style: TextStyle(
                              color: const Color(0xFF4E3321),
                              fontSize: 30,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w800,
                              height: 1.27,
                              letterSpacing: -0.30,
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: SizedBox(
                                width: 300, // fixed width
                                child: InteractionOption(
                                  label: 'Mindfulness Course\n for beginners',
                                  imageUrl: 'assets/images/Male.svg',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ChatPage()),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: Text('Medication ✨',
                            style: TextStyle(
                              color: const Color(0xFF4E3321),
                              fontSize: 30,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w800,
                              height: 1.27,
                              letterSpacing: -0.30,
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: SizedBox(
                                width: 300, // fixed width
                                child: InteractionOption(
                                  label: "Medication\n Info Session",
                                  imageUrl: 'assets/images/Female.svg',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ChatPage()),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Self-Help Videos 🎥',
                          style: TextStyle(
                            color: Color(0xFF4E3321),
                            fontSize: 30,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w800,
                            height: 1.27,
                            letterSpacing: -0.30,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Builder(
                        builder: (context) {
                          if (isLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (selfHelpVideos.isEmpty) {
                            return const Center(
                              child: Text(
                                'No videos available at the moment.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF3F3B35),
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                            );
                          } else {
                            return SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: selfHelpVideos.length,
                                itemBuilder: (context, index) {
                                  final video = selfHelpVideos[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VideoListScreen(
                                            videos: video.videos,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      child: SizedBox(
                                        width: 300,
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 2),
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                video.name,
                                                style: TextStyle(
                                                  color: Color(0xFF3F3B35),
                                                  fontSize: 18,
                                                  fontFamily: 'Urbanist',
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Expanded(
                                                child: Text(
                                                  video.description,
                                                  style: TextStyle(
                                                    color: Color(0xFF3F3B35),
                                                    fontSize: 14,
                                                    fontFamily: 'Urbanist',
                                                  ),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
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

class InteractionOption extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final String imageUrl;

  const InteractionOption({
    super.key,
    required this.label,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 110,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: Color(0xFF3F3B35),
                          fontSize: 16,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.05,
                        ),
                      ),
                    ),
                    Icon(Icons.female)
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: SvgPicture.asset(
                  imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
