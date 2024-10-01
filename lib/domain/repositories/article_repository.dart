import '../../data/models/article.dart';

abstract class ArticleRepository {
  Future<List<Article>> getTopHeadlines();
  Future<List<Article>> getFavoriteArticles();
  Future<void> toggleFavorite(Article article);
  Future<void> saveArticles(List<Article> articles);
}
