

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/modules/workers/worker_info_page.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class WorkersPage extends StatefulWidget {
  const WorkersPage({super.key});

  @override
  State<WorkersPage> createState() => _WorkersPageState();
}

class _WorkersPageState extends State<WorkersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar("Workers", context,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.filter_list,
                  color: AppColor.black,
                ))
          ],
          isCenter: true,
          isneedtopop: false,
          iswhite: true),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTabSelector(),
          _buildTabContent(),
        ],
      ),
    );
  }

  _buildTabContent() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [_buildNewWorkerTabContent(), _buildActiveWorkerTabContent()],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColor.green,
        labelPadding: EdgeInsets.zero,
        tabs: [
          _customTab("New", 0),
          _customTab("Online", 1),
        ],
      ),
    );
  }

  Widget _customTab(String text, int index) {
    bool isSelected = _tabController.index == index;
    return Tab(
      child: Container(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppColor.black : AppColor.lightGrey400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildNewWorkerTabContent() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => WorkerInfoPage(
                isActive: false,
              ),
            ));
          },
          child: Card(
              elevation: 0,
              color: AppColor.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: AppColor.lightGrey300)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 15,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: AppColor.skyBlue),
                      ),
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HandyLabel(
                              text: "John Doe",
                              isBold: true,
                              fontSize: 16,
                            ),
                            SizedBox(height: 10),
                            HandyLabel(
                              text: "Plumber",
                              isBold: false,
                              fontSize: 14,
                            ),
                          ])
                    ]),
              )),
        );
      },
    );
  }

  _buildActiveWorkerTabContent() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {   Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => WorkerInfoPage(
                isActive: true,
              ),
            ));},
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Card(
                elevation: 0,
                color: AppColor.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: AppColor.lightGrey300)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 15,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: AppColor.skyBlue),
                            ),
                            Expanded(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 5,
                                      children: [
                                        HandyLabel(
                                          text: "John Doe",
                                          isBold: true,
                                          fontSize: 16,
                                        ),
                                        _buildStatusIndicator(true),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    HandyLabel(
                                      text: "Plumber",
                                      isBold: false,
                                      fontSize: 14,
                                    ),
                                  ]),
                            ),
                            IconButton(
                              constraints: BoxConstraints(
                                  minHeight: 50,
                                  maxHeight: 50,
                                  maxWidth: 50,
                                  minWidth: 50),
                              style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                AppColor.lightGreen,
                              )),
                              onPressed: () {},
                              icon: Icon(
                                size: 30,
                                Icons.phone,
                                color: AppColor.green,
                              ),
                            ),
                          ]),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(height: 10),
                      _detailRow("Total Jobs", "24"),
                      SizedBox(height: 10),
                      _detailRow("Jobs In Queue", "1"),
                      SizedBox(height: 10),
                      Divider(
                        thickness: 1,
                      ),
                      Row(
                        children: [
                          HandyLabel(
                            text: "4.0",
                            isBold: true,
                            fontSize: 16,
                          ),
                          Expanded(
                            child: RatingBar.builder(
                              initialRating: 4.0,
                              minRating: 0.5,
                              maxRating: 5.0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              unratedColor: AppColor.lightGrey300,
                              itemCount: 5,
                              itemSize: 20,
                              ignoreGestures: true,
                              itemPadding: EdgeInsets.zero,
                              itemBuilder: (context, _) =>
                                  Icon(Icons.star, color: AppColor.yellow),
                              onRatingUpdate: (rating) {},
                            ),
                          ),
                          HandyLabel(
                            text: "42 Reviews",
                            isBold: false,
                            fontSize: 16,
                          )
                        ],
                      )
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }

  Widget _buildStatusIndicator(isOnline) {
    return Row(
      spacing: 5,
      children: [
        CircleAvatar(
          radius: 5,
          backgroundColor: isOnline ? AppColor.green : AppColor.red,
        ),
        HandyLabel(
          text: isOnline ? "Available" : "Offline",
          textcolor: isOnline ? AppColor.green : AppColor.greyDark,
        )
      ],
    );
  }

  Widget _detailRow(title, content) {
    return Row(
      children: [
        Expanded(
          child: HandyLabel(
            text: title,
            isBold: false,
            fontSize: 14,
          ),
        ),
        HandyLabel(
          textcolor: AppColor.lightGrey500,
          text: content,
          isBold: false,
          fontSize: 14,
        )
      ],
    );
  }
}
