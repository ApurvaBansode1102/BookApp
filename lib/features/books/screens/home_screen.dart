import 'package:bookapp/features/books/controllers/home_controller.dart';
import 'package:bookapp/features/utils/responsive.dart';
import 'package:bookapp/features/books/widgets/category_card.dart';
import 'package:bookapp/features/books/widgets/course_item.dart';
import 'package:bookapp/features/books/widgets/course_tab.dart';
import 'package:bookapp/features/auth/widgets/custom_searchbar.dart';
import 'package:bookapp/features/books/widgets/headersection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart'; // Add shimmer import

import 'book_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController(), permanent: true);
    final isTablet = Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.padding(context, mobile: 20, tablet: 40),
                vertical: Responsive.padding(context, mobile: 20, tablet: 40),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeaderSection(),
                    SizedBox(height: Responsive.padding(context, mobile: 16, tablet: 32)),
                    CustomSearchBar(
                      onSearch: (query) {
                        controller.searchBooks(query);
                      },
                    ),
                    SizedBox(height: Responsive.padding(context, mobile: 16, tablet: 32)),
                    Row(
                      children: [
                        Expanded(
                          child: CategoryCard(
                            title: ' Free E-books',
                            image: 'assets/Frame.png',
                          ),
                        ),
                        SizedBox(width: Responsive.padding(context, mobile: 12, tablet: 24)),
                        Expanded(
                          child: CategoryCard(
                            title: 'Magazines',
                            image: 'assets/Frame2.png',
                          ),
                        ),
                        if (isTablet)
                          ...[
                            SizedBox(width: Responsive.padding(context, mobile: 12, tablet: 24)),
                            Expanded(
                              child: CategoryCard(
                                title: 'Journals',
                                image: 'assets/Frame3.png',
                              ),
                            ),
                          ]
                      ],
                    ),
                    SizedBox(height: Responsive.padding(context, mobile: 16, tablet: 32)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "List of Books",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: Responsive.fontSize(context, mobile: 17, tablet: 24),
                          ),
                        ),
                        Row(

                          children:  [
                            Icon(Icons.grid_view),
                            Icon(Icons.menu_outlined),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: Responsive.padding(context, mobile: 12, tablet: 24)),
                    const CourseTab(),
                    SizedBox(height: Responsive.padding(context, mobile: 12, tablet: 24)),
                    Obx(() {
                      if (controller.isLoading.value) {
                        // Show shimmer effect while loading
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: isTablet ? 6 : 3,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: Responsive.padding(context, mobile: 12, tablet: 24),
                              ),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: isTablet ? 120 : 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      if (controller.filteredBooks.isEmpty) {
                        return Center(
                          child: Text(
                            'No books found.',
                            style: GoogleFonts.poppins(
                              fontSize: Responsive.fontSize(context, mobile: 14, tablet: 18),
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.filteredBooks.length,
                        itemBuilder: (context, index) {
                          final book = controller.filteredBooks[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: Responsive.padding(context, mobile: 12, tablet: 24),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                controller.lastTappedBook = book;
                                controller.lastTappedBookApiResponse = book is Map<String, dynamic> ? book as Map<String, dynamic>? : null;
                                Get.to(
                                  () => BookDetailScreen(book: book),
                                  transition: Transition.cupertino,
                                );
                              },
                              child: CourseItem(
                                title: book.title,
                                author: book.authors.isNotEmpty
                                    ? book.authors.first
                                    : 'Unknown Author',
                                imageUrl: book.thumbnail,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
