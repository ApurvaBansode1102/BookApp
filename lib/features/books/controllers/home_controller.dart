import 'package:bookapp/features/books/models/book.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// Book model
import '../models/allbooks_model.dart'; // AllbooksModel, Items
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/book_api_service.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var selectedTab = 0.obs;
  // Add a filteredBooks observable
  var filteredBooks = <Book>[].obs;
  // Call this after fetching books or when tab changes
  void filterBooks() {
    if (selectedTab.value == 0) {
      // All
      filteredBooks.value = books;
    } else if (selectedTab.value == 1) {
      // Popular: Example - books with most authors (or any other logic)
      filteredBooks.value = List<Book>.from(books)..sort((a, b) => b.authors.length.compareTo(a.authors.length));
    } else if (selectedTab.value == 2) {
      // New: Example - books with '202' in description (simulate new)
      filteredBooks.value = books.where((b) => b.description.contains('202')).toList();
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
    filterBooks();
  }
  // For analytics: store last tapped book and its API response
  Book? lastTappedBook;
  Map<String, dynamic>? lastTappedBookApiResponse;
  var allBooks = <Items>[].obs;
  var categories = [
    'Fiction',
    'Non-fiction',
    'Romance',
    'Sci-fi',
    'Thriller',
    'History',
    'Biography',
  ];
  //var selectedTab = 0.obs;
  var searchHistory = <String>[].obs;
  var books = <Book>[].obs;
  var lastApiResponse = {};

  @override
  void onInit() {
    super.onInit();
    loadHistory();
    fetchBooksByCategory(categories.first); // Default: Fiction
  }

  Future<void> fetchBooksByCategory(String category) async {
    final books = await BookApiService.searchBooks(category);
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    searchHistory.value = prefs.getStringList('searchHistory') ?? [];
  }

  Future<void> saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('searchHistory', searchHistory.toList());
  }

  

  Future<void> searchBooks(String query) async {
  if (query.trim().isEmpty) return;
  isLoading.value = true;
  // Keep only unique queries in history, most recent first
  searchHistory.remove(query);
  searchHistory.insert(0, query);
  await saveHistory(); // Save after update
  final results = await BookApiService.searchBooks(query);
  books.value = results;
  filterBooks();
  isLoading.value = false;
}

  void onSubmitted(String query) {
    searchBooks(query);
  }
}

