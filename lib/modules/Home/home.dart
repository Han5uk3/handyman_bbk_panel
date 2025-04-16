import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/modules/Home/home_page.dart';
import 'package:handyman_bbk_panel/modules/jobs/jobs_page.dart';
import 'package:handyman_bbk_panel/modules/products/products_page.dart';
import 'package:handyman_bbk_panel/modules/profile/profile_page.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(
      isAdmin: false,
    ),
    JobsPage(),
    ProductsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: AppColor.transparent,
          highlightColor: AppColor.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          unselectedItemColor: AppColor.greyDark,
          selectedItemColor: AppColor.purple,
          iconSize: 28,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: [
            _bottomNavBarItem(0, Icons.home, Icons.home_outlined, 'Home'),
            _bottomNavBarItem(
              1,
              Icons.handyman,
              Icons.handyman_outlined,
              'Jobs',
            ),
            _bottomNavBarItem(
              2,
              Icons.history,
              Icons.history_outlined,
              'History',
            ),
            _bottomNavBarItem(
              3,
              Icons.person,
              Icons.person_2_outlined,
              'Profile',
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _bottomNavBarItem(
    int index,
    IconData selectedIcon,
    IconData unselectedIcon,
    String title,
  ) {
    return BottomNavigationBarItem(
      icon: Icon(_currentIndex == index ? selectedIcon : unselectedIcon),
      label: title,
    );
  }
}
