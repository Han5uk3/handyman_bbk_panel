import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/jobsummarycard.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/rating_display.dart';

import 'package:handyman_bbk_panel/styles/color.dart';

class JobDetailsPage extends StatelessWidget {
  const JobDetailsPage({
    super.key,
    required this.jobID,
    required this.jobType,
    required this.date,
    required this.price,
    required this.time,
    required this.isHistory,
    this.isAccepted = false,
    this.isCompleted = false,
  });

  final String jobID;
  final bool isAccepted;
  final bool isCompleted;
  final String jobType;
  final String date;
  final double price;
  final String time;
  final bool isHistory;
  final String lorIps =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isHistory
          ? null
          : Padding(
              padding: EdgeInsets.fromLTRB(16, 5, 16, 28),
              child: HandymanButton(
                  text: "Start Job",
                  onPressed:
                      () {}), // if current date == date of appointment then show button else grey button with ignorePointer
              // after start job button pressed, replace it with "mark as complete" button.
            ),
      appBar: handyAppBar("", context,
          isCenter: true, isneedtopop: true, iswhite: true),
      body: SingleChildScrollView(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isHistory
            ? Container(
                color: isCompleted ? AppColor.green : AppColor.red,
                height: 30,
                child: Center(
                    child: HandyLabel(
                  text:
                      isCompleted ? "Completed on $date" : "Service Cancelled",
                  textcolor: AppColor.white,
                  isBold: true,
                  fontSize: 16,
                )),
              )
            : isAccepted
                ? Container(
                    color: AppColor.yellow,
                    height: 30,
                    child: Center(
                        child: HandyLabel(
                      text:
                          "Customer has been notified that you accepted the job!", // when button is "mark as complete", change to "Payment Done by Customer" if payment is done.
                      //if service is completed, change to "Service completed on date."
                      textcolor: AppColor.white,
                      isBold: true,
                      fontSize: 16,
                    )),
                  )
                : SizedBox.shrink(),
        Jobsummarycard(
          date: date,
          jobID: jobID,
          jobType: jobType,
          price: price,
          time: time,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HandyLabel(text: "Issue Details", isBold: true, fontSize: 16),
              const SizedBox(height: 10),
              HandyLabel(
                text: lorIps,
                isBold: false,
                fontSize: 14,
                textcolor: AppColor.lightGrey500,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: isHistory
              ? Column(
                  spacing: 60,
                  children: [
                    _buildImageSection(),
                    _buildRatingSection(),
                  ],
                )
              : Column(children: [
                  Container(
                    color: AppColor.lightGrey100,
                    height: 15,
                  ),
                  _buildCustomerCard(),
                  Container(
                    color: AppColor.lightGrey100,
                    height: 15,
                  ),
                ]),
        ),
      ],
    );
  }

  Widget _buildCustomerCard() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 90,
        color: AppColor.white,
        width: double.infinity,
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 60,
                  width: 60,
                  color: AppColor.purple,
                )),
            Expanded(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HandyLabel(
                      text: "Customer Name",
                      isBold: false,
                      fontSize: 14,
                    ),
                    HandyLabel(
                      text: "John Doe",
                      isBold: true,
                      fontSize: 16,
                    )
                  ]),
            ),
            IconButton(
              constraints: BoxConstraints(
                  minHeight: 55, maxHeight: 55, maxWidth: 55, minWidth: 55),
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                AppColor.lightGreen,
              )),
              onPressed: () {},
              icon: Icon(
                size: 26,
                Icons.phone,
                color: AppColor.green,
              ),
            )
          ],
        ));
  }

  _buildImageSection() {
    return Row(
      spacing: 35,
      children: [
        Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HandyLabel(
              text: "Before",
              textcolor: AppColor.lightGrey600,
            ),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: Container(
                height: 110,
                width: 110,
                color: AppColor.black,
              ),
            )
          ],
        ),
        Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HandyLabel(
              text: "After",
              textcolor: AppColor.lightGrey600,
            ),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: Container(
                height: 110,
                width: 110,
                color: AppColor.green,
              ),
            )
          ],
        )
      ],
    );
  }

  _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        HandyLabel(
          text: "Rating by customer",
          isBold: true,
          fontSize: 16,
        ),
        SizedBox(
          height: 15,
        ),
        RatingDisplay(
          rating: 4.0,
          iconSize: 26,
          reviewCount: 24,
          isInHistory: true,
        ),
        SizedBox(
          height: 10,
        ),
        HandyLabel(
          textcolor: AppColor.lightGrey600,
          text: lorIps,
          fontSize: 14,
        ),
        SizedBox(
          height: 80,
        )
      ],
    );
  }
}
