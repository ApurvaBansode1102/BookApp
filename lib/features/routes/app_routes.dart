import 'package:bookapp/features/contacts/screens/contacts_screen.dart';
import 'package:bookapp/features/books/screens/home_screen.dart';
import 'package:bookapp/features/auth/screens/login_screen.dart';
import 'package:bookapp/features/main/screens/main_screen.dart';
import 'package:bookapp/features/profile/screens/profile_screen.dart';
import 'package:bookapp/features/books/screens/search_screen.dart';
import 'package:bookapp/features/books/screens/second_screen.dart';
import 'package:bookapp/features/auth/screens/signup_screen.dart';
import 'package:get/get.dart';
import '../onboarding/screens/onboarding_flow.dart';
import '../onboarding/screens/onboarding_screen1.dart';
import '../onboarding/screens/onboarding_screen2.dart';
import '../onboarding/screens/onboarding_screen3.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/onboarding', page: () => OnboardingFlow()),
    GetPage(name: '/onboarding1', page: () => OnboardingScreen1()),
    GetPage(name: '/onboarding2', page: () => OnboardingScreen2()),
    GetPage(name: '/onboarding3', page: () => OnboardingScreen3()),
    GetPage(name: '/signup', page: () => SignUpScreen()),
    GetPage(name: '/login', page: () => LoginScreen()),
    GetPage(name: '/main', page: () => const MainScreen()),
    GetPage(name: '/home', page: () => const HomeScreen()),
    GetPage(name: '/second', page: () => const AnalyticsScreen()),
    GetPage(name: '/search', page: () => const SearchScreen()),
    GetPage(name: '/contacts', page: () => ContactsScreen()),
    GetPage(name: '/profile', page: () => ProfileScreen()),
   
    // Add other routes here
  ];
}
