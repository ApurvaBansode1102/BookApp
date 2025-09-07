import 'package:bookapp/features/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:bookapp/features/auth/widgets/custom_searchbar.dart';
import 'package:get/get.dart';
import 'package:bookapp/features/books/controllers/home_controller.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a unique tag for the search screen controller so it does not share state with home
    final controller = Get.put(HomeController(), tag: 'search', permanent: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
                horizontal: Responsive.padding(context, mobile: 20, tablet: 40),
                vertical: Responsive.padding(context, mobile: 40, tablet: 80),  ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSearchBar(
                onSearch: (query) {
                  // Only update this controller's search, not the home screen's
                  controller.searchBooks(query);
                },
              ),
              const SizedBox(height: 16),
              // Expanded(
              //   child: Obx(() {
              //     if (controller.isLoading.value) {
              //       return const Center(child: CircularProgressIndicator());
              //     }
              //     if (controller.filteredBooks.isEmpty) {
              //       return Center(
              //         child: Text(
              //           'No books found.',
              //           style: GoogleFonts.poppins(),
              //         ),
              //       );
              //     }
              //     return ListView.builder(
              //       itemCount: controller.filteredBooks.length,
              //       itemBuilder: (context, index) {
              //         final book = controller.filteredBooks[index];
              //         return CourseItem(
              //           title: book.title,
              //           author: book.authors.isNotEmpty ? book.authors.first : 'Unknown Author',
              //           imageUrl: book.thumbnail,
              //         );
              //       },
              //     );
              //   }),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}