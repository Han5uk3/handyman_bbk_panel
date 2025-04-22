import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

List<Map<String, dynamic>> notificationData = [
  {
    "header": "Urgent Work",
    "body": "An urgent work is live! Accept in 30s",
    "time": "10:00 AM"
  },
  {
    "header": "Customer Rated",
    "body": "You got 4.5 stars for your recent job!",
    "time": "06:00 PM"
  },
  {
    "header": "ID Verified",
    "body": "Your ID has been verified successfully",
    "time": "05:00 AM"
  },
];

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar("Notifications", context,
          isCenter: true, isneedtopop: true, iswhite: true),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView.builder(
      itemCount: notificationData.length,
      itemBuilder: (context, index) {
        return Dismissible(
          direction: DismissDirection.startToEnd,
          key: Key('item_$index'),
          onDismissed: (direction) {},
          background: Container(
            color: Colors.green,
            child: Row(
              spacing: 3,
              children: [
                SizedBox(width: 16),
                Icon(
                  Icons.done_all,
                  color: AppColor.white,
                ),
                Text(
                  textAlign: TextAlign.left,
                  'Mark as read',
                  style: TextStyle(color: AppColor.white, fontSize: 16),
                ),
              ],
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
                color: AppColor.white,
                border: Border(
                    bottom:
                        BorderSide(width: 1.5, color: AppColor.lightGrey200),
                    top: BorderSide(width: 1.5, color: AppColor.lightGrey200))),
            height: 100,
            padding: EdgeInsets.all(16),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HandyLabel(
                      text: notificationData[index]['header'],
                      isBold: true,
                      fontSize: 16,
                    ),
                    HandyLabel(
                        text: notificationData[index]['time'],
                        isBold: false,
                        textcolor: AppColor.lightGrey700,
                        fontSize: 12),
                  ],
                ),
                Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  notificationData[index]['body'],
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.lightGrey700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
