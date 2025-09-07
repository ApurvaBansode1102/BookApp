import 'package:bookapp/features/onboarding/controllers/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'onboarding_screen1.dart';
import 'onboarding_screen2.dart';
import 'onboarding_screen3.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final OnboardingController _controller = OnboardingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Adjust padding and dots size based on device
          final horizontalPadding = isTablet ? 64.0 : 24.0;
          final bottomPadding = isTablet ? 48.0 : 32.0;
          final dotSize = isTablet ? 12.0 : 6.0;
          final activeDotSize = isTablet ? 24.0 : 18.0;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _controller.pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _controller.onPageChanged(index);
                      });
                    },
                    children: const [
                      OnboardingScreen1(),
                      OnboardingScreen2(),
                      OnboardingScreen3(),
                    ],
                  ),
                ),
                if (_controller.currentPage < 2) // Hide on last screen
                  Padding(
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    child: DotsIndicator(
                      dotsCount: 3,
                      position: _controller.currentPage,
                      decorator: DotsDecorator(
                        activeColor: Colors.blue,
                        size: Size.square(dotSize),
                        activeSize: Size(activeDotSize, dotSize),
                        activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onTap: (index) {
                        _controller.animateToPage(index);
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
