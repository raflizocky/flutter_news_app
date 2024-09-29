import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_news_app/data/model/article.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static String get _baseUrl => dotenv.env['NEWS_BASE_URL'] ?? '';
  static String get _apiKey => dotenv.env['NEWS_API_KEY'] ?? '';
  static const String _country = 'us';

  Future<ArticlesResult> topHeadlines() async {
    final response = await http.get(Uri.parse(
        "${_baseUrl}top-headlines?country=$_country&apiKey=$_apiKey"));
    if (response.statusCode == 200) {
      return ArticlesResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load top headlines');
    }
  }
}
