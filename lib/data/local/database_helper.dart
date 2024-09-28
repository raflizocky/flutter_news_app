import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/article.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('news.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE articles(
        url TEXT PRIMARY KEY,
        author TEXT,
        title TEXT NOT NULL,
        description TEXT,
        urlToImage TEXT,
        publishedAt TEXT,
        content TEXT,
        isFavorite INTEGER NOT NULL
      )
    ''');
  }

  Future<List<Article>> getAllArticles() async {
    final db = await database;
    final maps = await db.query('articles');
    return List.generate(maps.length, (i) {
      return Article.fromJson(maps[i]);
    });
  }

  Future<int> insertArticle(Article article) async {
    final db = await database;
    return await db.insert(
      'articles',
      article.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateArticle(Article article) async {
    final db = await database;
    return await db.update(
      'articles',
      {
        'author': article.author,
        'title': article.title,
        'description': article.description,
        'urlToImage': article.urlToImage,
        'publishedAt': article.publishedAt?.toIso8601String(),
        'content': article.content,
        'isFavorite': article.isFavorite ? 1 : 0,
      },
      where: 'url = ?',
      whereArgs: [article.url],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Article>> getFavoriteArticles() async {
    final db = await database;
    final maps = await db.query(
      'articles',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) {
      return Article.fromJson(maps[i]);
    });
  }

  Future<void> toggleFavorite(Article article) async {
    article.isFavorite = !article.isFavorite;
    await updateArticle(article);
  }
}
