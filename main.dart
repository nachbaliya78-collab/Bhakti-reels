import 'package:flutter/material.dart';

void main() {
  runApp(const BhaktiReels());
}

class BhaktiReels extends StatelessWidget {
  const BhaktiReels({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bhakti Reels',
      theme: ThemeData.dark(),
      home: const ReelsPage(),
    );
  }
}

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  final PageController controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> videos = [
    {
      'title': 'Premanand Maharaj Ji',
      'caption': 'राधा नाम की महिमा 🙏',
      'type': 'प्रवचन और सत्संग',
    },
    {
      'title': 'Premanand Maharaj Ji',
      'caption': 'जीवन में भक्ति का महत्व ❤️',
      'type': 'आध्यात्मिक विचार',
    },
    {
      'title': 'Radha Krishna Bhakti',
      'caption': 'राधे राधे 🌸',
      'type': 'राधा कृष्ण भक्ति',
    },
    {
      'title': 'Premanand Maharaj Ji',
      'caption': 'मन को शांत कैसे रखें?',
      'type': 'प्रवचन और सत्संग',
    },
  ];

  final Set<int> liked = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: controller,
            scrollDirection: Axis.vertical,
            itemCount: videos.length,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            itemBuilder: (context, index) {
              final video = videos[index];

              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF302016),
                      Color(0xFF111111),
                      Color(0xFF000000),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.play_circle_fill,
                      size: 85,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      video['type']!,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'भक्ति और सत्संग',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '🙏 राधे राधे 🙏',
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              );
            },
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: const [
                  Text(
                    'Bhakti Reels',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.search, size: 28),
                ],
              ),
            ),
          ),

          Positioned(
            right: 12,
            bottom: 115,
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (liked.contains(currentIndex)) {
                        liked.remove(currentIndex);
                      } else {
                        liked.add(currentIndex);
                      }
                    });
                  },
                  icon: Icon(
                    liked.contains(currentIndex)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: liked.contains(currentIndex)
                        ? Colors.red
                        : Colors.white,
                    size: 34,
                  ),
                ),
                const Text('Like'),
                const SizedBox(height: 18),
                const Icon(Icons.comment, size: 32),
                const Text('Comment'),
                const SizedBox(height: 18),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share, size: 32),
                ),
                const Text('Share'),
              ],
            ),
          ),

          Positioned(
            left: 16,
            bottom: 100,
            right: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  videos[currentIndex]['title']!,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  videos[currentIndex]['caption']!,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.home, size: 27),
                  Icon(Icons.video_library, size: 27),
                  Icon(Icons.add_circle_outline, size: 32),
                  Icon(Icons.favorite_border, size: 27),
                  Icon(Icons.person_outline, size: 27),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
