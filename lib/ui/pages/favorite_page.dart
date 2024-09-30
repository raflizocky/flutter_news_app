import 'package:flutter/material.dart';
import '/data/model/article.dart';
import '/data/local/database_helper.dart';
import '../widgets/article_card.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  FavoritePageState createState() => FavoritePageState();
}

class FavoritePageState extends State<FavoritePage> {
  late Future<List<Article>> _favoriteArticles;

  @override
  void initState() {
    super.initState();
    _refreshFavorites();
  }

  // refresh the list of favorite articles
  void _refreshFavorites() {
    setState(() {
      _favoriteArticles = DatabaseHelper.instance.getFavoriteArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshFavorites,
          ),
        ],
      ),
      body: FutureBuilder<List<Article>>(
        future: _favoriteArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                _refreshFavorites();
              },
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ArticleCard(
                    article: snapshot.data![index],
                    onFavoriteChanged: () {
                      // Refresh the list when a favorite is toggled
                      _refreshFavorites();
                    },
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('No favorite articles yet.'));
          }
        },
      ),
    );
  }
}
