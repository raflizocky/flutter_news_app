import '../../domain/repositories/article_repository.dart';
import '../viewmodels/base_viewmodel.dart';
import '../../data/models/article.dart';

class HomeViewModel extends BaseViewModel {
  final ArticleRepository _repository;
  List<Article> _articles = [];

  List<Article> get articles => _articles;

  HomeViewModel(this._repository);

  // load articles from repository
  Future<void> loadArticles() async {
    setLoading(true);
    try {
      _articles = await _repository.getTopHeadlines();
      setError(null);
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  // refresh articles from repository
  Future<void> refreshArticles() async {
    setLoading(true);
    try {
      final newArticles = await _repository.getTopHeadlines();
      _articles = newArticles;
      setError(null);
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  // Toggle favorite status of an article
  Future<void> toggleFavorite(Article article) async {
    await _repository.toggleFavorite(article);
    notifyListeners();
  }
}
