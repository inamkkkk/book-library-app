class Book {
  int? id;
  String title;
  String author;
  String genre;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.genre,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'genre': genre,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      genre: map['genre'],
    );
  }
}