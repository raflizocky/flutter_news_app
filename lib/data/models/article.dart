import 'package:equatable/equatable.dart';

class ArticlesResult extends Equatable {
  final String status;
  final int totalResults;
  final List<Article> articles;

  const ArticlesResult({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  // JSON -> ArticlesResult
  factory ArticlesResult.fromJson(Map<String, dynamic> json) {
    try {
      return ArticlesResult(
        status: json["status"] as String? ?? '',
        totalResults: json["totalResults"] as int? ?? 0,
        articles: (json["articles"] as List?)
                ?.map((x) => Article.fromJson(x as Map<String, dynamic>))
                .where((article) => article.isValid)
                .toList() ??
            [],
      );
    } catch (e) {
      throw FormatException('Failed to load articles result: $e');
    }
  }

  // ArticlesResult -> JSON
  Map<String, dynamic> toJson() => {
        'status': status,
        'totalResults': totalResults,
        'articles': articles.map((article) => article.toJson()).toList(),
      };

  @override
  List<Object?> get props => [status, totalResults, articles];

  @override
  bool get stringify => true;
}

class Article extends Equatable {
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;
  bool isFavorite;

  Article({
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.isFavorite = false,
  });

  bool get isValid =>
      title.isNotEmpty &&
      url.isNotEmpty &&
      urlToImage != null &&
      description != null;

  Article copyWith({
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    DateTime? publishedAt,
    String? content,
    bool? isFavorite,
  }) {
    return Article(
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    try {
      return Article(
        author: json["author"] as String?,
        title: json["title"] as String? ?? '',
        description: json["description"] as String?,
        url: json["url"] as String? ?? '',
        urlToImage: json["urlToImage"] as String?,
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.tryParse(json["publishedAt"] as String),
        content: json["content"] as String?,
        isFavorite: json["isFavorite"] == 1,
      );
    } catch (e) {
      throw FormatException('Failed to load article: $e');
    }
  }

  Map<String, dynamic> toJson() => {
        'author': author,
        'title': title,
        'description': description,
        'url': url,
        'urlToImage': urlToImage,
        'publishedAt': publishedAt?.toIso8601String(),
        'content': content,
        'isFavorite': isFavorite ? 1 : 0,
      };

  @override
  List<Object?> get props => [
        author,
        title,
        description,
        url,
        urlToImage,
        publishedAt,
        content,
        isFavorite,
      ];

  @override
  bool get stringify => true;
}
