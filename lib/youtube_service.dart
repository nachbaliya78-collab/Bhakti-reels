import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  static const String apiKey =
    String.fromEnvironment('AIzaSyAUyUQNx4TMP39KObrbbApJ_NlIsOlGbIg');

  Future<List<dynamic>> getVideos(String query) async {

    if(apiKey.isEmpty) {
       throw Exception('YOUTUBE_API_KEY EMPTY');
       }
    final url = Uri.https(
      'www.googleapis.com',
      '/youtube/v3/search',
      {
        'part': 'snippet',
        'q': query,
        'type': 'video',
        'maxResults': '10',
        'regionCode': 'IN',
        'order': 'relevance',
        'key': apiKey,
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['items'] ?? [];
    }

    throw Exception('AIzaSyAUyUQNx4TMP39KObrbbApJ_NlIsOlGbIg: ${response.statusCode} - ${response.body}');
  }

  Future<List<dynamic>> getAllBhaktiVideos() async {
    final results = await Future.wait([
      getVideos('Radha Krishna Bhajan'),
      getVideos('Premanand Maharaj'),
      getVideos('Hanuman Bhajan'),
    ]);

    return results.expand((list) => list).toList();
  }
}
