import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl =>
      dotenv.env['NEWS_BASE_URL'] ?? 'https://newsapi.org/v2';
  static String get apiKey => dotenv.env['NEWS_API_KEY'] ?? '';
  static String get country => 'us';
}
