import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import '../../core/constants.dart'; // Import the constants file

/// Service for fetching book data from Google Books API
class BookApiService {
  /// Search books by title
  /// Returns a list of Book objects matching the query
  static Future<List<Book>> searchBooks(String query) async {
    final url = Uri.parse(
      '${AppConstants.googleBooksBaseUrl}?q=intitle:${Uri.encodeComponent(query)}',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'] as List<dynamic>? ?? [];
      // Parse each item into a Book model
      return items.map((item) => Book.fromJson(item)).toList();
    }
    // Return empty list if request fails
    return [];
  }

  /// Fetch books by author
  /// Optionally exclude a book by its ID
  static Future<List<Book>> booksByAuthor(String author, {String? excludeId}) async {
    final url = Uri.parse(
      '${AppConstants.googleBooksBaseUrl}?q=inauthor:${Uri.encodeComponent(author)}',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'] as List<dynamic>? ?? [];
      // Parse and filter out excluded book
      return items
          .map((item) => Book.fromJson(item))
          .where((b) => excludeId == null || b.id != excludeId)
          .toList();
    }
    // Return empty list if request fails
    return [];
  }
}
