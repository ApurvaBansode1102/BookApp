import 'package:bookapp/features/books/models/book.dart';
import 'package:bookapp/features/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/book_api_service.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  List<Book> otherBooks = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchOtherBooks();
  }

  Future<void> fetchOtherBooks() async {
    if (widget.book.authors.isEmpty) return;
    setState(() { loading = true; });
    final author = widget.book.authors.first;
    final books = await BookApiService.booksByAuthor(author, excludeId: widget.book.id);
    setState(() {
      otherBooks = books;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title, style: GoogleFonts.poppins()),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.padding(context, mobile: 20, tablet: 40),
          vertical: Responsive.padding(context, mobile: 40, tablet: 80),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: book.thumbnail.isNotEmpty
                    ? Image.network(book.thumbnail, height: 180)
                    : Container(height: 180, width: 120, color: Colors.grey[300], child: const Icon(Icons.book, size: 60)),
              ),
              const SizedBox(height: 16),
              Text(book.title, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(book.authors.isNotEmpty ? 'By ${book.authors.join(", ")}' : 'Unknown Author', style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700])),
              const SizedBox(height: 16),
              Text(book.description.isNotEmpty ? book.description : 'No description available', style: GoogleFonts.poppins(fontSize: 15)),
              const SizedBox(height: 24),
              Text('Other books by this author:', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              loading
                  ? const Center(child: CircularProgressIndicator())
                  : otherBooks.isEmpty
                      ? Text('No other books found.', style: GoogleFonts.poppins())
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: otherBooks.length,
                          itemBuilder: (context, idx) {
                            final b = otherBooks[idx];
                            return ListTile(
                              leading: b.thumbnail.isNotEmpty
                                  ? Image.network(b.thumbnail, height: 40, width: 30, fit: BoxFit.cover)
                                  : Container(height: 40, width: 30, color: Colors.grey[300]),
                              title: Text(b.title, style: GoogleFonts.poppins(fontSize: 14)),
                              subtitle: Text(b.authors.isNotEmpty ? b.authors.join(", ") : 'Unknown Author', style: GoogleFonts.poppins(fontSize: 12)),
                              onTap: () {
                                // Navigate to detail of this book
                                Get.to(() => BookDetailScreen(book: b));
                              },
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
