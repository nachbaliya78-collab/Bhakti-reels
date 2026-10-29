import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'explore_page.dart';

void main() => runApp(const BhaktiReelsApp());

const saffron = Color(0xFFFF982E);

class BhaktiReelsApp extends StatelessWidget {
  const BhaktiReelsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bhakti Reels',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const ReelsHome(),
    );
  }
}

class ReelData {
  const ReelData({
    required this.category,
    required this.title,
    required this.handle,
    required this.emoji,
    required this.mantra,
    required this.colors,
  });

  final String category;
  final String title;
  final String handle;
  final String emoji;
  final String mantra;
  final List<Color> colors;
}

const reels = <ReelData>[
  ReelData(
    category: 'Radha Krishna',
    title: 'राधे राधे बोल, मन को शांति मिले 🙏',
    handle: '@daily_bhakti',
    emoji: '🦚',
    mantra: 'राधे राधे • जय श्री कृष्ण',
    colors: [Color(0xFF5E8AB5), Color(0xFF202C52), Color(0xFF090A14)],
  ),
  ReelData(
    category: 'Mahadev',
    title: 'भोलेनाथ सबका कल्याण करें 🔱',
    handle: '@shiv_bhakt',
    emoji: '🔱',
    mantra: 'ॐ नमः शिवाय',
    colors: [Color(0xFF4B879C), Color(0xFF19354B), Color(0xFF070C14)],
  ),
  ReelData(
    category: 'Shri Ram',
    title: 'जहाँ राम का नाम है, वहाँ विश्वास है 🙏',
    handle: '@ram_naam',
    emoji: '🏹',
    mantra: 'जय श्री राम',
    colors: [Color(0xFFFFB94F), Color(0xFF8D4727), Color(0xFF170D12)],
  ),
  ReelData(
    category: 'Hanuman Ji',
    title: 'जय बजरंगबली 🚩',
    handle: '@hanuman_bhakt',
    emoji: '🚩',
    mantra: 'जय हनुमान',
    colors: [Color(0xFFFFB84A), Color(0xFF9E421A), Color(0xFF180907)],
  ),
  ReelData(
    category: 'Mata Rani',
    title: 'माता रानी की कृपा सब पर बनी रहे 🌺',
    handle: '@mata_rani',
    emoji: '🌺',
    mantra: 'जय माता दी',
    colors: [Color(0xFFFFA6A0), Color(0xFF8F2344), Color(0xFF180711)],
  ),
];

class ReelsHome extends StatefulWidget {
  const ReelsHome({super.key});

  @override
  State<ReelsHome> createState() => _ReelsHomeState();
}

class _ReelsHomeState extends State<ReelsHome> {
  final Set<int> liked = {};
  final Set<int> saved = {};
  String selectedCategory = 'सभी';
  int navIndex = 0;

  List<int> get visibleIndices {
    if (selectedCategory == 'सभी') {
      return List.generate(reels.length, (i) => i);
    }
    return [
      for (var i = 0; i < reels.length; i++)
        if (reels[i].category == selectedCategory) i,
    ];
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ));
  }

  Future<void> shareReel(ReelData reel) async {
    final shareText =
        'Bhakti Reels 🙏\n${reel.title}\n${reel.mantra}\n\nBhakti Reels app';
    await Clipboard.setData(ClipboardData(text: shareText));
    if (mounted) showMessage('Share text copy ho gaya. Ise message mein paste kar sakte ho.');
  }

  @override
  Widget build(BuildContext context) {
    final indices = visibleIndices;
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            key: ValueKey(selectedCategory),
            scrollDirection: Axis.vertical,
            itemCount: indices.length,
            itemBuilder: (context, pageIndex) {
              final reelIndex = indices[pageIndex];
              final reel = reels[reelIndex];
              return ReelPage(
                reel: reel,
                isLiked: liked.contains(reelIndex),
                isSaved: saved.contains(reelIndex),
                onLike: () => setState(() {
                  if (!liked.add(reelIndex)) liked.remove(reelIndex);
                }),
                onSave: () => setState(() {
                  if (!saved.add(reelIndex)) saved.remove(reelIndex);
                }),
                onShare: () => shareReel(reel),
                onComment: () => showMessage(
                  'Comments agle version mein backend ke saath add honge.',
                ),
              );
            },
          ),
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(children: [
                                TextSpan(text: '🪔 Bhakti '),
                                TextSpan(
                                  text: 'Reels',
                                  style: TextStyle(color: saffron),
                                ),
                              ]),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              'BHAKTI MEIN SHAKTI',
                              style: TextStyle(
                                fontSize: 9,
                                letterSpacing: 2,
                                color: Color(0xFFFFD9B0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => showMessage(
                          'Video upload ke liye Firebase Storage aur login setup karna hoga.',
                        ),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Upload'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    scrollDirection: Axis.horizontal,
                    children: [
                      _category('✨ Sabhi', 'सभी'),
                      _category('🦚 Krishna', 'Radha Krishna'),
                      _category('🔱 Mahadev', 'Mahadev'),
                      _category('🏹 Shri Ram', 'Shri Ram'),
                      _category('🚩 Hanuman', 'Hanuman Ji'),
                      _category('🌺 Mata Rani', 'Mata Rani'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: NavigationBar(
              selectedIndex: navIndex,
              onDestinationSelected: (index) {
                setState(() => navIndex = index);
                if (index == 0) {
                  setState(() => selectedCategory = 'सभी');
                } else if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const
                      ExplorePage(),
                          ),
                        ),
                }
                } else if (index == 2) {
                  showMessage('Video upload ke liye Firebase setup next step hai.');
                } else if (index == 3) {
                  showMessage('Abhi ${saved.length} reel(s) save ki hain.');
                } else {
                  showMessage('Profile/login feature next version mein aayega.');
                }
              },
              backgroundColor: Colors.black.withValues(alpha: 0.92),
              indicatorColor: const Color(0xFF4B2A12),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.search), label: 'Explore'),
                NavigationDestination(icon: Icon(Icons.add_box_outlined), label: 'Upload'),
                NavigationDestination(icon: Icon(Icons.bookmark_border), label: 'Saved'),
                NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _category(String label, String value) {
    final active = selectedCategory == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: active,
        onSelected: (_) => setState(() {
          selectedCategory = value;
          navIndex = 0;
        }),
        selectedColor: saffron,
        backgroundColor: Colors.black54,
        labelStyle: TextStyle(
          color: active ? Colors.black : Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        side: BorderSide(color: active ? saffron : Colors.white30),
        showCheckmark: false,
      ),
    );
  }
}

class ReelPage extends StatelessWidget {
  const ReelPage({
    super.key,
    required this.reel,
    required this.isLiked,
    required this.isSaved,
    required this.onLike,
    required this.onSave,
    required this.onShare,
    required this.onComment,
  });

  final ReelData reel;
  final bool isLiked;
  final bool isSaved;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onComment;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: reel.colors,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.27,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Container(
                width: 245,
                height: 245,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0x66FFE0A3)),
                  boxShadow: [
                    BoxShadow(
                      color: saffron.withValues(alpha: 0.16),
                      blurRadius: 65,
                      spreadRadius: 15,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(reel.emoji, style: const TextStyle(fontSize: 105)),
              ),
              const SizedBox(height: 24),
              Text(
                reel.mantra,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFFFE3B0),
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.3,
                ),
              ),
            ],
          ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x66000000), Colors.transparent, Color(0xD9000000)],
              stops: [0, 0.38, 1],
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 78,
          bottom: 105,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🙏 ${reel.category.toUpperCase()}',
                style: const TextStyle(
                  color: Color(0xFFFFCF85),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                reel.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 5),
              Text(reel.handle, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              const Text(
                '♫ Bhakti audio — demo screen',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ),
        Positioned(
          right: 12,
          bottom: 118,
          child: Column(
            children: [
              _ActionButton(
                icon: isLiked ? Icons.favorite : Icons.favorite_border,
                label: isLiked ? 'Liked' : 'Like',
                color: isLiked ? Colors.pinkAccent : Colors.white,
                onTap: onLike,
              ),
              const SizedBox(height: 18),
              _ActionButton(
                icon: Icons.mode_comment_outlined,
                label: 'Comment',
                onTap: onComment,
              ),
              const SizedBox(height: 18),
              _ActionButton(
                icon: Icons.send_outlined,
                label: 'Share',
                onTap: onShare,
              ),
              const SizedBox(height: 18),
              _ActionButton(
                icon: isSaved ? Icons.bookmark : Icons.bookmark_border,
                label: isSaved ? 'Saved' : 'Save',
                color: isSaved ? const Color(0xFFFFD27A) : Colors.white,
                onTap: onSave,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.white,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Column(
            children: [
              Icon(icon, size: 29, color: color),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}
