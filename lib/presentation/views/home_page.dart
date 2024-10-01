import 'package:flutter/material.dart';
import '../../data/models/article.dart';
import '../../data/services/api_service.dart';
import '../widgets/article_card.dart';
import '../../data/services/database_helper.dart';

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

  Future<void> _loadArticles() async {
    setState(() => _isLoading = true);

    try {
      // Get articles from db
      _articles = await DatabaseHelper.instance.getAllArticles();

      // If db is empty, fetch from API and save to db
      if (_articles.isEmpty) {
        final articlesResult = await _apiService.topHeadlines();
        _articles = articlesResult.articles;
        for (var article in _articles) {
          await DatabaseHelper.instance.insertArticle(article);
        }
      }
    } catch (e) {
      // Handle error
      print('Error loading articles: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Headlines'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
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
    );
  }
}
