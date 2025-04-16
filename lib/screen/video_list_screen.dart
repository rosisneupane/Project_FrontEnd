import 'package:flutter/material.dart';
import 'package:new_ui/config.dart';

import 'package:new_ui/model/collection.dart';
import 'package:new_ui/screen/full_screen_videoplayer.dart';
import 'package:video_player/video_player.dart';

class VideoListScreen extends StatelessWidget {
  final List<Video> videos;
  const VideoListScreen({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F2EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Self-Help Videos',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFF4E3321),
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Color(0xFF4E3321)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: videos.isEmpty
            ? const Center(
                child: Text(
                  'No videos available.',
                  style: TextStyle(
                    color: Color(0xFF3F3B35),
                    fontFamily: 'Urbanist',
                    fontSize: 16,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return VideoContainer(
                    video: video,
                  );
                },
              ),
      ),
    );
  }
}


class VideoContainer extends StatefulWidget {
  final Video video;
  const VideoContainer({super.key, required this.video});

  @override
  State<VideoContainer> createState() => _VideoContainerState();
}

class _VideoContainerState extends State<VideoContainer> {
  late VideoPlayerController _controller;
  String url = AppConfig.apiUrl;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse('$url${widget.video.url}'))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                          onPressed: () {
                            setState(() {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            });
                          },
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
                  : const AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Center(child: CircularProgressIndicator()),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                widget.video.title,
                style: const TextStyle(
                  color: Color(0xFF3F3B35),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Urbanist',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
