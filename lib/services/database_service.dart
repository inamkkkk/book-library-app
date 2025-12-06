import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:book_library_app/models/book.dart';

class DatabaseService {
  Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initializeDatabase();
    return _db;
  }

  Future<Database> initializeDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'book_library.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE books (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, author TEXT, genre TEXT)',
    );
  }

  Future<List<Book>> getBooks() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient!.query('books');

    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  Future<void> insertBook(Book book) async {
    final dbClient = await db;
    await dbClient!.insert(
      'books',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateBook(Book book) async {
    final dbClient = await db;
    await dbClient!.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<void> deleteBook(int id) async {
    final dbClient = await db;
    await dbClient!.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}