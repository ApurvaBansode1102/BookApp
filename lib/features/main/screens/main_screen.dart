import 'package:bookapp/features/contacts/screens/contacts_screen.dart';
import 'package:bookapp/features/books/screens/home_screen.dart';
import 'package:bookapp/features/profile/screens/profile_screen.dart';
import 'package:bookapp/features/books/screens/second_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    AnalyticsScreen(),
    ContactsScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // When back is pressed, go to login screen
        Navigator.of(context).popUntil((route) => route.isFirst);
        // Or use Get.offAllNamed('/login'); if using GetX navigation
        // Get.offAllNamed('/login');
        return false;
      },
      child: Scaffold(
        body: _pages[_currentIndex],

        // Floating search button
        // floatingActionButton: Container(
        //   width: 64,
        //   height: 64,
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     color: const Color(0xFFFFFFFF),
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.black.withOpacity(0.1),
        //         blurRadius: 8,
        //         offset: const Offset(0, 2),
        //       ),
        //     ],
        //   ),
        //   child: FloatingActionButton(
        //     onPressed: () {
        //       _onTabTapped(2); // Index of Search
        //     },
        //     backgroundColor: Colors.transparent,
        //     elevation: 0,
        //     child: const Icon(Icons.search, size: 28, color: Color(0xFF3366FF)),
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        // Bottom bar
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue, // Active color
          unselectedItemColor: Colors.grey,
          items: [
            for (int i = 0; i < 4; i++)
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    if (_currentIndex == i)
                      Container(
                        width: 24,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    Icon(
                      [
                        Icons.home,
                        Icons.analytics,
                        Icons.contacts,
                        Icons.person,
                      ][i],
                    ),
                  ],
                ),
                label: ['Home', 'Analytics', 'Contacts', 'Profile'][i],
              ),
          ],
        ),
      ),
    );
  }
}
