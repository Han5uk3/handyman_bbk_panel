import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/jobsummarycard.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';

import 'package:handyman_bbk_panel/styles/color.dart';

class JobDetailsPage extends StatelessWidget {
  const JobDetailsPage(
      {super.key,
      required this.jobID,
      required this.jobType,
      required this.date,
      required this.price,
      required this.time,
      required this.isAccepted});

  final String jobID;
  final bool isAccepted;
  final String jobType;
  final String date;
  final double price;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16, 5, 16, 28),
        child: HandymanButton(
            text: "Start Job",
            onPressed:
                () {}), // if current date == date of appointment then show button else grey button with ignorePointer
                // after start job button pressed, replace it with "mark as complete" button.
                
      ),
      appBar: handyAppBar("", context,
          isCenter: true, isneedtopop: true, iswhite: true),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isAccepted
            ? Container(
                color: AppColor.yellow,
                height: 30,
                child: Center(
                    child: HandyLabel(
                  text: "Customer has been notified that you accepted the job!",// when button is "mark as complete", change to "Payment Done by Customer" if payment is done.
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
              SizedBox(
                  height: 120,
                  child: Text(
                      textAlign: TextAlign.justify,
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")),
              // add before and after service images in a row 
              
              SizedBox(height: 20),
            ],
          ),
        ),
        Container(
          color: AppColor.lightGrey100,
          height: 15,
        ),
        _buildCustomerCard(), // switch with rating and review setup
        Container(
          color: AppColor.lightGrey100,
          height: 15,
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
}
