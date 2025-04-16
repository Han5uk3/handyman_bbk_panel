import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/outline_button.dart';
import 'package:handyman_bbk_panel/common_widget/svgicon.dart';
import 'package:handyman_bbk_panel/helpers/hive_helpers.dart';
import 'package:handyman_bbk_panel/modules/login/login_page.dart';
import 'package:handyman_bbk_panel/modules/login/worker/worker_detail_page.dart';
import 'package:handyman_bbk_panel/modules/profile/earnings_page.dart';

import 'package:handyman_bbk_panel/modules/profile/terms_and_conditions_page.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final bool _isLoading = false;
  bool isGuestUser = false;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar('Profile', context, isneedtopop: false),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            _buildProfileTile(
              label: "My Profile",
              path: "assets/icons/profileIcons/profilePerson.svg",
              color: AppColor.lightPurple,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WorkerDetailPage(isProfile: true),
                  ),
                );
              },
            ),
            _buildProfileTile(
              label: "Earnings",
              path: "assets/icons/profileIcons/profileEarnings.svg",
              color: AppColor.lightYellow,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EarningsPage(),
                  ),
                );
              },
            ),
            _buildProfileTile(
              label: "Terms & Conditions",
              path: "assets/icons/profileIcons/T&C.svg",
              color: AppColor.lightGreen,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TermsAndConditionsPage(),
                  ),
                );
              },
            ),
            _buildProfileTile(
              label: "Delete Account",
              path: "assets/icons/profileIcons/deleteprofile.svg",
              color: AppColor.lightRed,
              onTap: () {
                _showDeleteBottomSheet(context, true);
              },
            ),
            _buildProfileTile(
              label: "Logout",
              path: "assets/icons/profileIcons/logout.svg",
              color: AppColor.lightPink,
              onTap: () {
                _showDeleteBottomSheet(context, false);
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildProfileTile({
    VoidCallback? onTap,
    required String path,
    required Color color,
    required String label,
  }) {
    return Column(
      children: [
        ListTile(
          minTileHeight: 85,
          onTap: onTap,
          leading: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: SizedBox(height: 20, width: 20, child: loadsvg(path)),
            ),
          ),
          title: Text(label, style: TextStyle(fontSize: 16)),
          trailing: Icon(Icons.chevron_right, size: 35),
        ),
        Divider(height: 1, thickness: 0.5, color: AppColor.lightGrey500),
      ],
    );
  }

  _showDeleteBottomSheet(BuildContext context, bool toggler) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                toggler ? "Delete Profile" : "Logout",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(height: 1, thickness: 0.5, color: AppColor.lightGrey500),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: toggler ? 40 : 40,
                child: Text(
                  toggler
                      ? "Are you sure you want to delete your account?"
                      : "Are you sure you want to logout?",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 5),
            Divider(height: 0.5, thickness: 0.5, color: AppColor.lightGrey500),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: HandymanOutlineButton(
                      borderThickness: 1.0,
                      text: "Cancel",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      borderColor: AppColor.red,
                      textColor: AppColor.red,
                    ),
                  ),
                  Expanded(
                    child: HandymanButton(
                      text: toggler ? "Delete Account" : "Logout",
                      onPressed: () => toggler ? () {} : _logout(context),
                      color: AppColor.red,
                      textColor: AppColor.white,
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      backgroundColor: AppColor.white,
      // isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.27,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      barrierColor: AppColor.lightblack,
      isDismissible: false,
      enableDrag: false,
      useRootNavigator: true,
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await HiveHelper.removeUID();
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
