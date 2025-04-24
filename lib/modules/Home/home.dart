import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/loader.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';
import 'package:handyman_bbk_panel/modules/Home/home_page.dart';
import 'package:handyman_bbk_panel/modules/history/history_page.dart';
import 'package:handyman_bbk_panel/modules/jobs/jobs_page.dart';
import 'package:handyman_bbk_panel/modules/orders/orders_page.dart';
import 'package:handyman_bbk_panel/modules/products/products_page.dart';
import 'package:handyman_bbk_panel/modules/profile/profile_page.dart';
import 'package:handyman_bbk_panel/modules/workers/workers_page.dart';
import 'package:handyman_bbk_panel/services/app_services.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
      stream:
          AppServices.getUserData(uid: FirebaseAuth.instance.currentUser?.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: HandymanLoader());
        }
        final user = snapshot.data!;
        final bool isAdmin = user.isAdmin ?? false;
        final List<Widget> pages = [
          HomePage(
            isAdmin: isAdmin,
            userData: user,
          ),
          JobsPage(
            isAdmin: isAdmin,
          ),
          isAdmin ? ProductsPage() : HistoryPage(),
          isAdmin ? OrdersPage() : ProfilePage(),
          isAdmin ? WorkersPage() : ProfilePage(),
        ];
        return Scaffold(
          body: pages[_currentIndex],
          bottomNavigationBar: (user.isVerified ?? false)
              ? Theme(
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
                    selectedLabelStyle:
                        const TextStyle(fontWeight: FontWeight.w600),
                    showUnselectedLabels: true,
                    type: BottomNavigationBarType.fixed,
                    items: [
                      _bottomNavBarItem(0, Icons.home, Icons.home_outlined,
                          AppLocalizations.of(context)!.dashboard),
                      _bottomNavBarItem(
                          1,
                          Icons.handyman,
                          Icons.handyman_outlined,
                          AppLocalizations.of(context)!.jobs),
                      _bottomNavBarItem(
                        2,
                        isAdmin ? Icons.inventory : Icons.history,
                        isAdmin
                            ? Icons.inventory_2_outlined
                            : Icons.history_outlined,
                        isAdmin
                            ? AppLocalizations.of(context)!.products
                            : AppLocalizations.of(context)!.history,
                      ),
                      if (isAdmin)
                        _bottomNavBarItem(
                            3,
                            Icons.history,
                            Icons.history_outlined,
                            AppLocalizations.of(context)!.orders),
                      _bottomNavBarItem(
                        isAdmin ? 4 : 3,
                        isAdmin ? Icons.people : Icons.person,
                        isAdmin
                            ? Icons.people_outline
                            : Icons.person_2_outlined,
                        isAdmin
                            ? AppLocalizations.of(context)!.workers
                            : AppLocalizations.of(context)!.profile,
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
        );
      },
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
