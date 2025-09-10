import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Colors, ElevatedButton;
import 'package:google_fonts/google_fonts.dart';
import '../../utils/responsive.dart';

class CourseItem extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;
  final bool isGrid;

  const CourseItem({
    super.key,
    required this.title,
    required this.author,
    required this.imageUrl,
    this.isGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final paddingAll = Responsive.padding(context, mobile: 12, tablet: 20);
    final borderRadius = BorderRadius.circular(isTablet ? 18 : 12);
    final imageSize = isTablet ? 80.0 : 60.0;
    final titleFontSize = Responsive.fontSize(context, mobile: 14, tablet: 20);
    final authorFontSize = Responsive.fontSize(context, mobile: 14, tablet: 18);
    final iconSize = isTablet ? 28.0 : 20.0;

    return Container(
      padding: EdgeInsets.all(paddingAll),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: isTablet ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isGrid
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circle Image
                ClipOval(
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 100,
                          width: 100,
                          color: Colors.grey[400],
                          child: Icon(
                            Icons.book,
                            color: Colors.white,
                            size: iconSize,
                          ),
                        ),
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),
                // Author / Description
                Text(
                  author,
                  style: GoogleFonts.poppins(
                    fontSize: authorFontSize,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
          : Row(
              children: [
                imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(isTablet ? 14 : 10),
                        child: Image.network(
                          imageUrl,
                          height: imageSize,
                          width: imageSize,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: imageSize,
                        width: imageSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 14 : 10,
                          ),
                          color: Colors.grey[400],
                        ),
                        child: Icon(
                          Icons.book,
                          color: Colors.white,
                          size: iconSize,
                        ),
                      ),
                SizedBox(
                  width: Responsive.padding(context, mobile: 12, tablet: 20),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: Responsive.padding(
                          context,
                          mobile: 4,
                          tablet: 8,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: iconSize,
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              author,
                              style: GoogleFonts.poppins(
                                fontSize: authorFontSize,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
