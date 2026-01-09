import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/news_model.dart';

class NewsApiService {
  final String baseUrl = dotenv.env['RAPIDAPI_BASE_URL'] ?? '';
  final String apiKey = dotenv.env['RAPIDAPI_KEY'] ?? '';
  final String apiHost = dotenv.env['RAPIDAPI_HOST'] ?? '';

  Future<NewsResponse> getNews({
    String query = 'Football',
    int limit = 50,
    String timePublished = 'anytime',
    String country = 'US',
    String lang = 'en',
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/search').replace(
        queryParameters: {
          'query': query,
          'limit': limit.toString(),
          'time_published': timePublished,
          'country': country,
          'lang': lang,
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'x-rapidapi-host': apiHost,
          'x-rapidapi-key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return NewsResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
}
