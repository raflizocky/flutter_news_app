import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/article.dart';

class DatabaseHelper {
  static const String _databaseName = "news.db";
  static const int _databaseVersion = 1;
  static const String _tableArticles = 'articles';

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableArticles (
        url TEXT PRIMARY KEY,
        author TEXT,
        title TEXT NOT NULL,
        description TEXT,
        urlToImage TEXT,
        publishedAt TEXT,
        content TEXT,
        isFavorite INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<List<Article>> getAllArticles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableArticles);
    return List.generate(maps.length, (i) => Article.fromJson(maps[i]));
  }

  Future<List<Article>> getFavoriteArticles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableArticles,
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => Article.fromJson(maps[i]));
  }

  Future<void> insertArticle(Article article) async {
    final db = await database;
    await db.insert(
      _tableArticles,
      article.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertArticles(List<Article> articles) async {
    final db = await database;
    final batch = db.batch();
    for (var article in articles) {
      batch.insert(
        _tableArticles,
        article.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> updateArticle(Article article) async {
    final db = await database;
    await db.update(
      _tableArticles,
      article.toJson(),
      where: 'url = ?',
      whereArgs: [article.url],
    );
  }

  Future<void> deleteArticle(String url) async {
    final db = await database;
    await db.delete(
      _tableArticles,
      where: 'url = ?',
      whereArgs: [url],
    );
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete(_tableArticles);
  }
}
