import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_library_app/main.dart';
import 'package:book_library_app/models/book.dart';
import 'package:book_library_app/screens/add_book_screen.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    List<Book> booksToShow = _searchQuery.isEmpty
        ? bookProvider.books
        : bookProvider.searchBooks(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Library'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort_by_alpha),
            onPressed: () {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: Text('Sort by'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text('Title'),
                        onTap: () {
                          bookProvider.sortBooksByTitle();
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text('Author'),
                        onTap: () {
                          bookProvider.sortBooksByAuthor();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search books',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: booksToShow.length,
              itemBuilder: (context, index) {
                final book = booksToShow[index];
                return Dismissible(
                  key: Key(book.id.toString()),
                  onDismissed: (direction) {
                    bookProvider.deleteBook(book.id!);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('${book.title} deleted')));
                  },
                  background: Container(color: Colors.red),
                  child: ListTile(
                    title: Text(book.title),
                    subtitle: Text('By ${book.author} (${book.genre})'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddBookScreen(book: book),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBookScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}