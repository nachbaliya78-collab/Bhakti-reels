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

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final video = items[index];
              final snippet = video['snippet'];
              final videoId = video['id']['videoId'];
              final title = snippet['title'];
              final channel = snippet['channelTitle'];
              final thumbnail =
                  snippet['thumbnails']['high']['url'];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Image.network(
                    thumbnail,
                    width: 110,
                    fit: BoxFit.cover,
                  ),
                  title: Text(title),
                  subtitle: Text(channel),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoPage(
                          videoId: videoId,
                        ),
                      ),
                    );
                  },
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
