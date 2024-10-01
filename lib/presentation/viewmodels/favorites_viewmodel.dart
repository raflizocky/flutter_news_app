import '../../domain/repositories/article_repository.dart';
import '../viewmodels/base_viewmodel.dart';
import '../../data/models/article.dart';

class FavoritesViewModel extends BaseViewModel {
  final ArticleRepository _repository;
  List<Article> _favoriteArticles = [];

  List<Article> get favoriteArticles => _favoriteArticles;

  FavoritesViewModel(this._repository);

  Future<void> loadFavorites() async {
    setLoading(true);
    try {
      _favoriteArticles = await _repository.getFavoriteArticles();
      setError(null);
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
