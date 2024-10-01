import '../../domain/repositories/article_repository.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';
import '../models/article.dart';

// interface for domain/repositories/article_repository.dart
class ArticleRepositoryImpl implements ArticleRepository {
  final ApiService _apiService;
  final DatabaseHelper _databaseHelper;

  ArticleRepositoryImpl(this._apiService, this._databaseHelper);

  @override
  Future<List<Article>> getTopHeadlines() async {
    try {
      // get articles from local db
      final localArticles = await _databaseHelper.getAllArticles();
      if (localArticles.isEmpty) {
        final remoteArticles = await _apiService.topHeadlines();
        await _databaseHelper.insertArticles(remoteArticles.articles);
        return remoteArticles.articles;
      }
      return localArticles;
    } catch (e) {
      throw Exception('Failed to get top headlines: $e');
    }
  }

  @override
  Future<List<Article>> getFavoriteArticles() async {
    return _databaseHelper.getFavoriteArticles();
  }

  @override
  Future<void> toggleFavorite(Article article) async {
    article.isFavorite = !article.isFavorite;
    await _databaseHelper.updateArticle(article);
  }

  @override
  Future<void> saveArticles(List<Article> articles) async {
    await _databaseHelper.insertArticles(articles);
  }
}
