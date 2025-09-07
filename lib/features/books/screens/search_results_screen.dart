import 'package:bookapp/features/books/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'book_detail_screen.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;
  const SearchResultsScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    // Trigger search only once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.searchBooks(query);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.books.isEmpty) {
            return Center(child: Text('No results found.', style: GoogleFonts.poppins()));
          }
          // Show 'Results' text and then the list
          return ListView.builder(
            itemCount: controller.books.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
                  child: Text(
                    'Results :',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              }
              final book = controller.books[index - 1];
              return GestureDetector(
                onTap: () {
                  Get.to(() => BookDetailScreen(book: book));
                },
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      book.thumbnail.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                book.thumbnail,
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              height: 60,
                              width: 60,
                              color: Colors.grey[300],
                              child: const Icon(Icons.book, color: Colors.white),
                            ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(book.title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(book.authors.isNotEmpty ? book.authors.join(', ') : 'Unknown Author', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey)),
                            const SizedBox(height: 6),
                            Text(book.description.isNotEmpty ? book.description : 'No description available', maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
