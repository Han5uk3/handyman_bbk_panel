import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/svgicon.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.isAdmin});
  final bool isAdmin;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool showGrid = true;

  bool isVerified = true;
  bool isSeen = false;
  bool isOnline = false;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    showGrid = true;
    _controller.forward();
  }

  void toggleGrid() {
    setState(() {
      showGrid = !showGrid;
      if (showGrid) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> adminData = [
    {
      "title": "Total Workers",
      "count": "120",
      "color": AppColor.yellow,
      "icon": "assets/icons/worker.svg"
    },
    {
      "title": "Products Listed",
      "count": "50",
      "color": AppColor.purple,
      "icon": "assets/icons/power_drill.svg"
    },
    {
      "title": "Scheduled",
      "count": "12",
      "color": AppColor.pink,
      "icon": "assets/icons/calendar_clock.svg"
    },
    {
      "title": "Urgent",
      "count": "5",
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar(
          widget.isAdmin ? "Dashboard" : "Welcome Mathew!", context,
          isCenter: false,
          iswhite: false,
          textColor: AppColor.white,
          actions: [
            IconButton(
              icon: Icon(
                Icons.language,
                color: AppColor.white,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: AppColor.white,
              ),
              onPressed: () {},
            )
          ]),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          !isSeen
              ? Container(
                  width: double.infinity,
                  height: 35,
                  decoration: BoxDecoration(
                    color: !isVerified ? AppColor.yellow : AppColor.green,
                  ),
                  child: Center(
                    child: HandyLabel(
                      text: !isVerified
                          ? "Your ID has been sent for Verification!"
                          : "Your ID has been successfully verified!",
                      textcolor: AppColor.white,
                      isBold: false,
                    ),
                  ),
                )
              : SizedBox.shrink(),
          SizedBox(height: 16),
          widget.isAdmin
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: toggleGrid,
                    child: SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          Expanded(
                            child: HandyLabel(
                              fontSize: 18,
                              text: "This Week",
                              isBold: false,
                            ),
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
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HandyLabel(
                              text: "Online", fontSize: 18, isBold: false),
                          Switch(
                            value: isOnline,
                            onChanged: (value) {
                              setState(() {
                                isOnline = value;
                              });
                            },
                            activeColor: AppColor.white,
                            activeTrackColor: AppColor.green,
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizeTransition(
              sizeFactor: _controller,
              axisAlignment: -1.0,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildCardsGrid(),
              ),
            ),
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
        itemCount: adminData.length,
        itemBuilder: (context, index) {
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
                    color: widget.isAdmin
                        ? adminData[index]["color"]
                        : workerData[index]["color"],
                    border: Border.all(color: AppColor.lightGrey200),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                  padding: EdgeInsets.all(10),
                  child: loadsvg(widget.isAdmin
                      ? adminData[index]["icon"]
                      : workerData[index]["icon"]),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HandyLabel(
                      text: widget.isAdmin
                          ? adminData[index]["title"]
                          : workerData[index]["title"],
                      isBold: false,
                      fontSize: 16,
                      textcolor: AppColor.greyDark,
                    ),
                    HandyLabel(
                      text: widget.isAdmin
                          ? adminData[index]["count"]
                          : workerData[index]["count"],
                      isBold: true,
                      fontSize: 18,
                    ),
                  ],
                )
              ],
            ),
          );
        },
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
