import 'package:flutter/material.dart';

class OnboardingController extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  void animateToPage(int page) {
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}