import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_ui/config.dart';
import 'package:new_ui/screen/full_screen_videoplayer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class ResourceVideoScreen extends StatefulWidget {
  final String type;
  const ResourceVideoScreen({super.key, required this.type});

  @override
  State<ResourceVideoScreen> createState() => _ResourceVideoScreenState();
}

class _ResourceVideoScreenState extends State<ResourceVideoScreen> {
  List<dynamic> videoList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    setState(() => isLoading = true);
    String url = AppConfig.apiUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('JWT Token not found');
    }

    final response = await http.get(
      Uri.parse("$url/media?media_type=video&category=${widget.type}"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        videoList = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Resource Videos")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : videoList.isEmpty
              ? Center(child: Text("No videos found"))
              : ListView.builder(
                  itemCount: videoList.length,
                  itemBuilder: (context, index) {
                    final video = videoList[index];
                    return VideoListItem(video: video);
                  },
                ),
    );
  }
}


class VideoListItem extends StatefulWidget {
  final dynamic video;
  const VideoListItem({super.key, required this.video});

  @override
  State<VideoListItem> createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  late VideoPlayerController _controller;
  String baseUrl = AppConfig.apiUrl;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('$baseUrl${widget.video["url"]}'),
    )..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

    void _goFullScreen() {
    if (_controller.value.isInitialized) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FullScreenVideoPlayer(controller: _controller),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: _controller.value.isInitialized
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                        IconButton(
                          icon: Icon(
                            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: _togglePlayback,
                        ),
                                                Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.fullscreen, color: Colors.white),
                            onPressed: _goFullScreen,
                          ),
                        )
                      ],
                    )
                  : AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Center(child: CircularProgressIndicator()),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                widget.video["title"] ?? "Untitled",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Urbanist',
                  color: Color(0xFF3F3B35),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
