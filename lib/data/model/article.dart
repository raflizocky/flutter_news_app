class ArticlesResult {
  final String status;
  final int totalResults;
  final List<Article> articles;

  ArticlesResult({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory ArticlesResult.fromJson(Map<String, dynamic> json) => ArticlesResult(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<Article>.from((json["articles"] as List)
            .map((x) => Article.fromJson(x))
            .where((article) => article.isValid())),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'totalResults': totalResults,
        'articles': articles.map((article) => article.toJson()).toList(),
      };
}

class Article {
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;

  Article({
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: json["publishedAt"] != null
            ? DateTime.parse(json["publishedAt"])
            : null,
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        'author': author,
        'title': title,
        'description': description,
        'url': url,
        'urlToImage': urlToImage,
        'publishedAt': publishedAt?.toIso8601String(),
        'content': content,
      };

  bool isValid() =>
      author != null &&
      description != null &&
      urlToImage != null &&
      publishedAt != null &&
      content != null;
}
