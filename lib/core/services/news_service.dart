import 'dart:convert';
import 'package:http/http.dart' as http;

import '../data/news_models.dart';

/// Fetches real Indian legal news from the NewsData.io free API.
///
/// Free tier: 200 requests / day — no credit card required.
/// Docs: https://newsdata.io/docs
class NewsService {
  static const _apiKey = 'pub_f0092e484b674badbb7a028024a52235';
  static const _endpoint = 'https://newsdata.io/api/1/news';

  static final NewsService _instance = NewsService._internal();
  factory NewsService() => _instance;
  NewsService._internal();

  /// Returns up to [count] Indian legal/law news articles.
  Future<List<NewsArticle>> fetchLegalNews({int count = 6}) async {
    final uri = Uri.parse(
      '$_endpoint?apikey=$_apiKey'
      '&q=legal+law+court+india'
      '&country=in'
      '&language=en'
      '&category=politics,crime',
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final results = (body['results'] as List<dynamic>? ?? []);
        return results
            .take(count)
            .map((e) => NewsArticle.fromJson(e as Map<String, dynamic>))
            .where((a) => a.title.isNotEmpty)
            .toList();
      } else {
        throw Exception('NewsData API error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch legal news: $e');
    }
  }
}
