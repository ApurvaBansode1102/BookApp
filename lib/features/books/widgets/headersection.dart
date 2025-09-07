import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookapp/features/utils/responsive.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final titleFontSize = Responsive.fontSize(context, mobile: 24, tablet: 36);
    final avatarRadius = isTablet ? 56.0 : 40.0;
    final iconSize = isTablet ? 32.0 : 24.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Course",
          style: GoogleFonts.poppins(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.grey[200],
          backgroundImage: const AssetImage('assets/Avatar.png'),
          radius: avatarRadius,
          child: Icon(Icons.person, color: Colors.black, size: iconSize),
        ),
      ],
    );
  }
}
