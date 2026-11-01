import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  static const String apiKey = 'YOUR_API_KEY';

  Future<List<dynamic>> getVideos(String query) async {
    final url = Uri.https(
      'www.googleapis.com',
      '/youtube/v3/search',
      {
        'part': 'snippet',
        'q': query,
        'type': 'video',
        'maxResults': '10',
        'regionCode': 'IN',
        'key': apiKey,
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['items'];
    } else {
      throw Exception('AIzaSyBOuqsJGUSWF6eHqaWoC6Bs-QZM8jEVV3Y: ${response.body}');
    }
  }
}
