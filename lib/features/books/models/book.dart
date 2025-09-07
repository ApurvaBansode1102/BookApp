class Book {
  final String id;
  final String title;
  final String thumbnail;
  final String description;
  final List<String> authors;

  Book({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.description,
    required this.authors,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    return Book(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? '',
      thumbnail: (volumeInfo['imageLinks'] != null) ? volumeInfo['imageLinks']['thumbnail'] ?? '' : '',
      description: volumeInfo['description'] ?? '',
      authors: (volumeInfo['authors'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
    );
  }
}
