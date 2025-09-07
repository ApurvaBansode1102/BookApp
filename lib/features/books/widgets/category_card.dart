import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bookapp/features/books/controllers/home_controller.dart';
import 'package:bookapp/features/utils/responsive.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String image;
  final Color bgColor;
  final VoidCallback? onTap;
  final void Function(String)? onSearch;

  const CategoryCard({
    super.key,
    required this.title,
    required this.image,
    this.bgColor = const Color(0xFFE8ECFF),
    this.onTap,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final cardWidth = isTablet ? 220.0 : 165.0;
    final cardHeight = isTablet ? 140.0 : 100.0;
    final borderRadius = BorderRadius.circular(isTablet ? 24 : 16);
    final marginRight = isTablet ? 20.0 : 12.0;
    final titleFontSize = Responsive.fontSize(context, mobile: 14, tablet: 18);
    final paddingH = isTablet ? 14.0 : 8.0;
    final paddingV = isTablet ? 8.0 : 4.0;

    return GestureDetector(
      onTap: onTap ??
          () async {
            final query = title.trim();
            final homeController = Get.find<HomeController>();
            await homeController.searchBooks(query.toLowerCase());
            onSearch?.call(query); // Update the search bar text too
          },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: EdgeInsets.only(right: marginRight),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: isTablet ? 16 : 8,
                bottom: isTablet ? 16 : 8,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: paddingH,
                    vertical: paddingV,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: titleFontSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
