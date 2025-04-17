import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/svgicon.dart';
import 'package:handyman_bbk_panel/helpers/hive_helpers.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';
import 'package:handyman_bbk_panel/modules/login/login_page.dart';
import 'package:handyman_bbk_panel/modules/workers/bloc/workers_bloc.dart';
import 'package:handyman_bbk_panel/services/app_services.dart';
import 'package:handyman_bbk_panel/sheets/localization_sheet.dart';
import 'package:handyman_bbk_panel/sheets/logout_sheet.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class HomePage extends StatefulWidget {
  final bool isAdmin;
  final UserData userData;
  const HomePage({super.key, required this.isAdmin, required this.userData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showGrid = true;
  bool isVerified = true;
  bool isSeen = false;
  int totalWorkers = 0;
  Stream<int>? workersCountStream;
  Stream<int>? scheduledBookingsStream;
  Stream<int>? urgentBookingsStream;
  Stream<int>? productsStream;

  @override
  void initState() {
    showGrid = true;
    if (widget.isAdmin) {
      workersCountStream = AppServices.getWorkersCount();
      scheduledBookingsStream = AppServices.getScheduleUrgentCount();
      urgentBookingsStream = AppServices.getScheduleUrgentCount(isUrgent: true);
      productsStream = AppServices.getProductsCount();
    }
    super.initState();
  }

  void toggleGrid() {
    setState(() {
      showGrid = !showGrid;
    });
  }

  List<Map<String, dynamic>> adminData = [
    {
      "title": "Total Workers",
      "color": AppColor.yellow,
      "icon": "assets/icons/worker.svg"
    },
    {
      "title": "Products Listed",
      "color": AppColor.purple,
      "icon": "assets/icons/power_drill.svg"
    },
    {
      "title": "Scheduled",
      "color": AppColor.pink,
      "icon": "assets/icons/calendar_clock.svg"
    },
    {
      "title": "Urgent",
      "color": AppColor.skyBlue,
      "icon": "assets/icons/urgent.svg"
    },
  ];
  List<Map<String, dynamic>> workerData = [
    {
      "title": "Total Jobs",
      "count": "0",
      "color": AppColor.yellow,
      "icon": "assets/icons/worker.svg"
    },
    {
      "title": "Earnings ",
      "count": "0",
      "color": AppColor.green,
      "icon": "assets/icons/earnings.svg"
    },
    {
      "title": "Urgent",
      "count": "0",
      "color": AppColor.skyBlue,
      "icon": "assets/icons/urgent.svg"
    },
    {
      "title": "Scheduled",
      "count": "0",
      "color": AppColor.pink,
      "icon": "assets/icons/calendar_clock.svg"
    },
  ];
  List<Map<String, dynamic>> topWorkers = [
    {
      "name": "Mathew John",
      "job": "Plumber",
      "color": AppColor.yellow,
      "jobcount": "24"
    },
    {
      "name": "John Samson",
      "job": "Electrician",
      "color": AppColor.purple,
      "jobcount": "69"
    },
    {
      "name": "Ladis Washeroom",
      "job": "Plumber",
      "color": AppColor.pink,
      "jobcount": "4"
    },
    {
      "name": "Allison Begrers",
      "job": "Electrician",
      "color": AppColor.lightblue,
      "jobcount": "2"
    },
  ];

  void _showLogoutPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AdminLogoutPopup(
        onLogout: () async {
          await HiveHelper.removeUID();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
          );
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar(
          widget.isAdmin ? "Dashboard" : "Welcome ${widget.userData.name}",
          context,
          isCenter: false,
          iswhite: false,
          textColor: AppColor.white,
          actions: [
            IconButton(
              icon: Icon(
                Icons.language,
                color: AppColor.white,
              ),
              onPressed: ()=> Localization.showLanguageDialog(context),
            ),
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: AppColor.white,
              ),
              onPressed: () {},
            ),
            widget.isAdmin
                ? IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: AppColor.white,
                    ),
                    onPressed: () => _showLogoutPopup(context),
                  )
                : SizedBox.shrink()
          ]),
      body: (widget.userData.isVerified ?? false)
          ? _buildBody()
          : _adminWantToVerifyWorkersAccount(),
    );
  }

  Widget _adminWantToVerifyWorkersAccount() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: HandyLabel(
          text: "Please wait for admin to verify your account",
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          widget.isAdmin
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: toggleGrid,
                    child: SizedBox(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HandyLabel(
                            text: "Dashboard",
                            fontSize: 14,
                            isBold: false,
                          ),
                          Icon(
                            showGrid
                                ? CupertinoIcons.chevron_up
                                : CupertinoIcons.chevron_down,
                            size: 14,
                            color: AppColor.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : isVerified
                  ? BlocBuilder<WorkersBloc, WorkersState>(
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              HandyLabel(
                                text: "Online",
                                fontSize: 18,
                                isBold: false,
                              ),
                              Switch(
                                value: widget.userData.isUserOnline ?? false,
                                onChanged: (value) {
                                  if (value) {
                                    context.read<WorkersBloc>().add(
                                          SwitchToOnlineEvent(
                                              workerId: AppServices.uid),
                                        );
                                  } else {
                                    context.read<WorkersBloc>().add(
                                          SwitchToOfflineEvent(
                                              workerId: AppServices.uid),
                                        );
                                  }
                                },
                                activeColor: AppColor.white,
                                activeTrackColor: AppColor.green,
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: showGrid ? _buildCardsGrid() : SizedBox.shrink(),
          ),
          SizedBox(height: 16),
          if (widget.isAdmin)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: HandyLabel(
                      text: "Top Workers", fontSize: 18, isBold: true),
                ),
                SizedBox(height: 16),
                _topWorkersSection(),
              ],
            )
        ],
      ),
    );
  }

  Widget _buildCardsGrid() {
    if (widget.isAdmin) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: 2.1,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            if (index == 0) {
              return StreamBuilder<int>(
                stream: workersCountStream,
                builder: (context, snapshot) {
                  String count =
                      snapshot.hasData ? snapshot.data.toString() : "0";
                  return _buildGridCard(
                    title: "Total Workers",
                    count: count,
                    color: AppColor.yellow,
                    icon: "assets/icons/worker.svg",
                  );
                },
              );
            } else if (index == 1) {
              return StreamBuilder<int>(
                stream: productsStream,
                builder: (context, snapshot) {
                  String count =
                      snapshot.hasData ? snapshot.data.toString() : "0";
                  return _buildGridCard(
                    title: "Products Listed",
                    count: count,
                    color: AppColor.purple,
                    icon: "assets/icons/power_drill.svg",
                  );
                },
              );
            } else if (index == 2) {
              return StreamBuilder<int>(
                stream: scheduledBookingsStream,
                builder: (context, snapshot) {
                  String count =
                      snapshot.hasData ? snapshot.data.toString() : "0";
                  return _buildGridCard(
                    title: "Scheduled",
                    count: count,
                    color: AppColor.pink,
                    icon: "assets/icons/calendar_clock.svg",
                  );
                },
              );
            } else {
              return StreamBuilder<int>(
                stream: urgentBookingsStream,
                builder: (context, snapshot) {
                  String count =
                      snapshot.hasData ? snapshot.data.toString() : "0";
                  return _buildGridCard(
                    title: "Urgent",
                    count: count,
                    color: AppColor.skyBlue,
                    icon: "assets/icons/urgent.svg",
                  );
                },
              );
            }
          },
        ),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: 2.1,
          ),
          itemCount: workerData.length,
          itemBuilder: (context, index) {
            return _buildGridCard(
              title: workerData[index]["title"],
              count: workerData[index]["count"],
              color: workerData[index]["color"],
              icon: workerData[index]["icon"],
            );
          },
        ),
      );
    }
  }

  Widget _buildGridCard({
    required String title,
    required String count,
    required Color color,
    required String icon,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColor.lightGrey200)),
      elevation: 0,
      color: AppColor.white,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: AppColor.lightGrey200),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
            padding: EdgeInsets.all(10),
            child: loadsvg(icon),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              HandyLabel(
                text: title,
                isBold: false,
                fontSize: 14,
                textcolor: AppColor.greyDark,
              ),
              HandyLabel(
                text: count,
                isBold: true,
                fontSize: 15,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _topWorkersSection() {
    return Column(
      children: List.generate(topWorkers.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppColor.lightGrey200),
            ),
            elevation: 0,
            color: AppColor.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: topWorkers[index]["color"],
                      border: Border.all(color: AppColor.lightGrey200),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: EdgeInsets.fromLTRB(0, 8, 8, 8),
                    padding: EdgeInsets.all(10),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HandyLabel(
                          text: topWorkers[index]["name"],
                          isBold: true,
                          fontSize: 16,
                        ),
                        HandyLabel(
                          text: topWorkers[index]["job"],
                          isBold: false,
                          fontSize: 16,
                          textcolor: AppColor.lightGrey700,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${topWorkers[index]["jobcount"]} jobs",
                    style: TextStyle(color: AppColor.lightGrey700),
                  )
                ],
              ),
            ),
          ),
        );
      }, growable: true),
    );
  }
}
