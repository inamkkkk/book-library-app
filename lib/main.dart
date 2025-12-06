import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_library_app/screens/book_list_screen.dart';
import 'package:book_library_app/services/database_service.dart';
import 'package:book_library_app/models/book.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final DatabaseService databaseService = DatabaseService();
  await databaseService.initializeDatabase();
  runApp(MyApp(databaseService: databaseService));
}

class MyApp extends StatelessWidget {
  final DatabaseService databaseService;

  const MyApp({Key? key, required this.databaseService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => BookProvider(databaseService),
      child: MaterialApp(
        title: 'Book Library',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BookListScreen(),
      ),
    );
  }
}

class BookProvider extends ChangeNotifier {
  final DatabaseService databaseService;
  List<Book> _books = [];

  BookProvider(this.databaseService) {
    loadBooks();
  }

  List<Book> get books => _books;

  Future<void> loadBooks() async {
    _books = await databaseService.getBooks();
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    await databaseService.insertBook(book);
    await loadBooks();
  }

  Future<void> updateBook(Book book) async {
    await databaseService.updateBook(book);
    await loadBooks();
  }

  Future<void> deleteBook(int id) async {
    await databaseService.deleteBook(id);
    await loadBooks();
  }

  List<Book> searchBooks(String query) {
    return _books.where((book) =>
        book.title.toLowerCase().contains(query.toLowerCase()) ||
        book.author.toLowerCase().contains(query.toLowerCase())).toList();
  }

  void sortBooksByTitle() {
    _books.sort((a, b) => a.title.compareTo(b.title));
    notifyListeners();
  }

  void sortBooksByAuthor() {
    _books.sort((a, b) => a.author.compareTo(b.author));
    notifyListeners();
  }
}
