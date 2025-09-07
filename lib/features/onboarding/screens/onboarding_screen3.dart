import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top skip button aligned to the end
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Text(
            //     "Skip",
            //     style: GoogleFonts.poppins(
            //       fontWeight: FontWeight.w400,
            //       color: Colors.grey[700],
            //     ),
            //   ),
            // ),

            const SizedBox(height: 40),

            // Image
            Center(
              child: Image.asset('assets/illustration 03.png' , height: 300, width: 300, fit: BoxFit.cover),
                        
            ),

            const SizedBox(height: 40),

            // Title
            Text(
              "Create your own \n study plan",
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
            "Study according to the \n study plan, make study \n more motivated",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),

            const Spacer(),

            // Buttons
           Row(
  children: [
    // Sign Up Button (Filled)
    Expanded(
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed('/signup');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3366FF), // blue fill
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          "Sign up",
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),

    const SizedBox(width: 12),

    // Log In Button (Outlined)
    Expanded(
      child: OutlinedButton(
        onPressed: () {
          Get.toNamed('/login');
        
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF3366FF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          "Log in",
          style: TextStyle(color: Color(0xFF3366FF)),
        ),
      ),
    ),
  ],
),


           const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
