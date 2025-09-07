import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:bookapp/features/utils/responsive.dart';

void showSuccessDialog() {
  final context = Get.context!;
  final isTablet = Responsive.isTablet(context);
  final iconSize = isTablet ? 60.0 : 40.0;
  final circlePadding = isTablet ? 24.0 : 16.0;
  final titleFontSize = Responsive.fontSize(context, mobile: 20, tablet: 28);
  final subtitleFontSize = Responsive.fontSize(context, mobile: 14, tablet: 18);
  final buttonPaddingV = isTablet ? 20.0 : 14.0;
  final buttonFontSize = Responsive.fontSize(context, mobile: 16, tablet: 22);
  final borderRadius = BorderRadius.circular(isTablet ? 18 : 12);

  Get.defaultDialog(
    barrierDismissible: false,
    backgroundColor: Colors.white,
    radius: isTablet ? 18 : 12,
    title: '',
    content: Column(
      children: [
        // Circle Icon
        Container(
          padding: EdgeInsets.all(circlePadding),
          decoration: const BoxDecoration(
            color: Color(0xFF3366FF),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: iconSize,
          ),
        ),
        SizedBox(height: isTablet ? 32 : 20),

        // Title
        Text(
          'Success',
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: isTablet ? 18 : 10),

        // Subtitle
        Text(
          'Congratulations, you have\ncompleted your registration!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: subtitleFontSize,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: isTablet ? 36 : 25),

        // Done Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Get.back(); // Close the dialog
              // Navigate to home/dashboard if needed
              // Get.offAllNamed('/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3366FF),
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
              ),
              padding: EdgeInsets.symmetric(vertical: buttonPaddingV),
            ),
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.white,
                fontSize: buttonFontSize,
              ),
            ),
          ),
        )
      ],
    ),
  );
}
