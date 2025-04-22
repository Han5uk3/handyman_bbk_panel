import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/location_history_display.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class Jobsummarycard extends StatelessWidget {
  final String time;
  final String date;
  final double price;
  final String jobType;
  final String userLocation;
  final bool isInWorkerHistory;
  final bool paymentStatus;

  const Jobsummarycard({
    super.key,
    required this.time,
    required this.date,
    required this.price,
    required this.jobType,
    required this.userLocation,
    required this.isInWorkerHistory, required this.paymentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBodyWidget(context, userLocation);
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
                      Icons.schedule,
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
                  Row(children: [
                    Icon(
                      Icons.attach_money,
                      size: 18,
                    ),
                    HandyLabel(
                      text: "$price",
                      fontSize: 14,
                      isBold: false,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    HandyLabel(
                      text: _getPaidtext(paymentStatus),
                      textcolor: paymentStatus ? AppColor.green : AppColor.red,
                      fontSize: 14,
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

  _getPaidtext(bool paymentDone) {
    return paymentDone ? "Paid" : "Unpaid";
  }
}
