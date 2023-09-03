import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gram_news/models/news_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final databaseProvider = Provider((ref) => SQLHelper());

class SQLHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;
  static const table = 'my_table';

  //create database
  Future<Database> _init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    final db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
    return db;
  }

  //create table
  Future _onCreate(Database db, int version) async {
    await db.execute("""CREATE TABLE $table(
        author TEXT,
        title TEXT PRIMARY KEY NOT NULL,
        description TEXT,
        image TEXT,
        url TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  //create item inside table
  Future<int> createItem(
      String title, String? description, String? image, String url) async {
    final database = await _init();
    final data = {
      'title': title,
      'description': description,
      'image': image,
      'url': url
    };
    final id = await database.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  //get single item from table
  Future<NewsModel?> getItem(String title) async {
    final database = await _init();

    final result = await database.query(table,
        where: "title = ?", whereArgs: [title], limit: 1);

    if (result[0]['title'] == null) {
      return null;
    }
    return NewsModel(
      id: result[0]['id'] as String?,
      title: result[0]['title'] as String?,
      description: result[0]['description'] as String?,
      imageUrl: result[0]['image'] as String?,
      newsUrl: result[0]['url'] as String?,
    );
  }

  //get all items from table
  Future<List<NewsModel>>? getItems() async {
    final database = await _init();
    final result = await database.query(table, orderBy: "createdAt DESC");
    return result.map((map) {
      return NewsModel(
        id: map['author'] as String?,
        title: map['title'] as String?,
        description: map['description'] as String?,
        imageUrl: map['image'] as String?,
        newsUrl: map['url'] as String?,
      );
    }).toList();
  }
}
