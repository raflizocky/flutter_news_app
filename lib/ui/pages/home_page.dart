import 'package:flutter/material.dart';
import '/data/model/article.dart';
import '/data/network/api_service.dart';
import '/data/local/database_helper.dart';
import '../widgets/article_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  List<Article> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  // load articles from local db/API
  Future<void> _loadArticles() async {
    setState(() => _isLoading = true);

    // get articles from db
    _articles = await DatabaseHelper.instance.getAllArticles();

    // If db is empty, fetch from API and save to db
    if (_articles.isEmpty) {
      final articlesResult = await _apiService.topHeadlines();
      _articles = articlesResult.articles;
      for (var article in _articles) {
        await DatabaseHelper.instance.insertArticle(article);
      }
    }

    setState(() => _isLoading = false);
  }

  // refresh articles from API
  Future<void> _refreshArticles() async {
    setState(() => _isLoading = true);

    // Fetch new data from the API
    final articlesResult = await _apiService.topHeadlines();
    List<Article> newArticles = articlesResult.articles;

    // Get existing articles from the db
    List<Article> existingArticles =
        await DatabaseHelper.instance.getAllArticles();

    // Create a map of existing articles for quick lookup
    Map<String, Article> existingArticlesMap = {
      for (var article in existingArticles) article.url: article
    };

    // Update the db with new articles, preserving favorite status
    for (var newArticle in newArticles) {
      if (existingArticlesMap.containsKey(newArticle.url)) {
        // If the article already exists, preserve its favorite status
        newArticle.isFavorite = existingArticlesMap[newArticle.url]!.isFavorite;
      }
      await DatabaseHelper.instance.insertArticle(newArticle);
    }

    // Update the _articles list with the new data
    _articles = await DatabaseHelper.instance.getAllArticles();

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Headlines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshArticles,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshArticles,
              child: ListView.builder(
                itemCount: _articles.length,
                itemBuilder: (context, index) {
                  return ArticleCard(
                    article: _articles[index],
                    onFavoriteChanged: () {
                      // Update the local list when favorite status changes
                      setState(() {
                        _articles[index] = _articles[index];
                      });
                    },
                  );
                },
              ),
            ),
    );
  }
}
