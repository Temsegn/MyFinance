import 'package:flutter/material.dart';
import 'Home/home_page.dart';
import 'accounts/account_page.dart';
import 'Analytics/analytics.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'category/category_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MainPage> {
  int _selectedindex = 0;
   void _onItemTapped(int index) {
    setState(() {
      _selectedindex = index;
    });
  }

  List<Widget> _pages = [
      DashboardScreen(),
      AnalyticsPage(),
      CategoryManagementPage(),
      AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedindex],
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Flat Container for Navigation Bar
          Container(
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: GNav(
                gap: 8,
                backgroundColor: Colors.white,
                color: const Color.fromARGB(255, 12, 154, 236),
                activeColor: Colors.white,
                tabBackgroundColor: Colors.grey[800]!,
                padding: const EdgeInsets.all(10),
                onTabChange: _onItemTapped,
                tabs: const [
                  GButton(icon: Icons.home, text: 'Home'),
                  GButton(icon: Icons.analytics, text: 'Analytics'),
                  GButton(icon: Icons.category, text: 'Categories'),
                  GButton(icon: Icons.person, text: 'Accounts'),
                ],
              ),
            ),
          ),
          // Rounded Floating Action Button
          Positioned(
            bottom: 50, // Half of FAB height (56/2) to position it above the nav bar
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle, // Ensures the FAB is rounded
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.blue,
                elevation: 0,
                shape: const CircleBorder(), // Explicitly sets rounded shape
                child: const Icon(Icons.add, size: 32, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
