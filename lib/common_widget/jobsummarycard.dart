import 'package:flutter/material.dart';

import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/location_history_display.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class Jobsummarycard extends StatelessWidget {
  final String time;
  final String date;
  final double price;
  final String jobType;

  const Jobsummarycard( {
    super.key,
    required this.time,
    required this.date,
    required this.price,
    required this.jobType,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBodyWidget(context, "userLocation");
  }

  _buildBodyWidget(context, userLocation) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColor.lightGrey300),
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        color: AppColor.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 1),
              HandyLabel(
                text: jobType,
                isBold: true,
                fontSize: 18,
              ),
              LocationHistoryDisplay(
                customerLocation: userLocation,
                isActive: true,
                iconColor: AppColor.lightGrey500,
                textStyle: TextStyle(
                  color: AppColor.lightGrey600,
                  fontSize: 16,
                ),
              ),
              Divider(
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(spacing: 3, children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                    ),
                    HandyLabel(
                      text: date,
                      fontSize: 14,
                      isBold: true,
                    ),
                  ]),
                  Container(
                    width: 1.3,
                    height: 30,
                    color: AppColor.lightGrey500,
                  ),
                  Row(spacing: 3, children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                    ),
                    HandyLabel(
                      text: time,
                      fontSize: 14,
                      isBold: true,
                    ),
                  ]),
                  Container(
                    width: 1.3,
                    height: 30,
                    color: AppColor.lightGrey500,
                  ),
                  Row(spacing: 3, children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                    ),
                    HandyLabel(
                      text: "\$ $price",
                      fontSize: 14,
                      isBold: true,
                    ),
                  ])
                ],
              ),
              SizedBox(height: 1),
            ],
          ),
        ),
      ),
    );
  }
}
