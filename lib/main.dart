import 'package:flutter/material.dart';
import 'youtube_service.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

void main() {
  runApp(const BhaktiReelsApp());
}

class BhaktiReelsApp extends StatelessWidget {
  const BhaktiReelsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bhakti Reels',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> videos;

  @override
  void initState() {
    super.initState();
    videos = YouTubeService().getAllBhaktiVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🙏 Bhakti Reels'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: videos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(
              child: Text('No videos found'),
            );
          }

          return PageView.builder(
  scrollDirection: Axis.vertical,
  itemCount: items.length,
  itemBuilder: (context, index) {
    final video = items[index];
    final videoId = video['id']['videoId'];
    final snippet = video['snippet'];

    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            snippet['thumbnails']['high']['url'],
            height: 250,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Text(
            snippet['title'],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          Text(snippet['channelTitle']),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoPage(videoId: videoId),
                ),
              );
            },
            child: const Text('Play Video'),
          ),
        ],
      ),
    );
  },
);
        },
      ),
    );
  }
}

class VideoPage extends StatefulWidget {
  final String videoId;

  const VideoPage({super.key, required this.videoId});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bhakti Video')),
      body: Center(
        child: YoutubePlayer(
          controller: controller,
          aspectRatio: 16 / 9,
        ),
      ),
    );
  }
}
