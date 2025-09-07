import 'package:bookapp/features/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.padding(context, mobile: 20, tablet: 40),
          vertical: Responsive.padding(context, mobile: 40, tablet: 80),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top skip button aligned to the end
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/onboarding3');
                },
                child: Text(
                  "Skip",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Image
            Center(
              child: Image.asset('assets/illustration 01.png' , height: 300, width: 300, fit: BoxFit.cover),
                        
            ),

            const SizedBox(height: 40),

            // Title
            Text(
              "Numerous free \ntrial courses",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 15),

            // Subtitle
            Text(
              "Free courses for you to\nfind your way to learning",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),

            const Spacer(),

            // Dots Indicator
            // DotsIndicator(
            //   dotsCount: 3,
            //   position: 0,
            //   decorator: DotsDecorator(
            //     activeColor: Colors.blue,
            //     size: const Size.square(6.0),
            //     activeSize: const Size(18.0, 6.0),
            //     activeShape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(5.0),
            //     ),
            //   ),
            // ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
