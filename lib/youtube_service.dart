import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  static const String _apiKey = String.fromEnvironment('YOUTUBE_API_KEY');

  Future<List<Map<String, dynamic>>> searchVideos(String query) async {
    if (_apiKey.isEmpty) {
      throw Exception('YouTube API key configure nahi hai.');
    }

    final uri = Uri.https(
      'www.googleapis.com',
      '/youtube/v3/search',
      {
        'part': 'snippet',
        'q': query,
        'type': 'video',
        'maxResults': '20',
        'key': _apiKey,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Video search fail hua: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>? ?? [];

    return items.map((item) {
      final video = item as Map<String, dynamic>;
      final snippet = video['snippet'] as Map<String, dynamic>;
      final id = video['id'] as Map<String, dynamic>;

      return {
        'videoId': id['videoId'] ?? '',
        'title': snippet['title'] ?? '',
        'channel': snippet['channelTitle'] ?? '',
        'thumbnail': snippet['thumbnails']?['high']?['url'] ??
            snippet['thumbnails']?['default']?['url'] ??
            '',
      };
    }).toList();
  }
}
