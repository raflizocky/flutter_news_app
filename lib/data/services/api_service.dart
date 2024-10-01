import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import 'api_config.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<ArticlesResult> topHeadlines() async {
    try {
      final response = await _client.get(
        Uri.parse(
            "${ApiConfig.baseUrl}/top-headlines?country=${ApiConfig.country}&apiKey=${ApiConfig.apiKey}"),
      );

      if (response.statusCode == 200) {
        return ArticlesResult.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load articles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load articles: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
