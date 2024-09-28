import 'package:flutter/material.dart';
import '/data/model/article.dart';
import '/data/local/database_helper.dart';
import '../pages/detail_web_view.dart';

class ArticleCard extends StatefulWidget {
  final Article article;
  final VoidCallback? onFavoriteChanged;

  const ArticleCard({
    super.key,
    required this.article,
    this.onFavoriteChanged,
  });

  @override
  ArticleCardState createState() => ArticleCardState();
}

class ArticleCardState extends State<ArticleCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.article.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleWebView(article: widget.article),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: widget.article.url,
                  child: _buildImage(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.article.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.article.description ??
                            'No description available',
                        style: const TextStyle(fontSize: 14),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : Colors.white,
              ),
              onPressed: _toggleFavorite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return widget.article.urlToImage != null
        ? Image.network(
            widget.article.urlToImage!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.error)),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 200,
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              );
            },
          )
        : Container(
            height: 200,
            color: Colors.grey[300],
            child: const Center(child: Text('No Image')),
          );
  }

  void _toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    widget.article.isFavorite = _isFavorite;
    await DatabaseHelper.instance.updateArticle(widget.article);
    widget.onFavoriteChanged?.call();
  }
}
