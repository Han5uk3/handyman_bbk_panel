import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/jobsummarycard.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';

import 'package:handyman_bbk_panel/common_widget/loader.dart';
import 'package:handyman_bbk_panel/models/booking_data.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';
import 'package:handyman_bbk_panel/modules/workers/widgets/jobcard.dart';


import 'package:handyman_bbk_panel/styles/color.dart';

class JobDetailsPage extends StatelessWidget {

  final BookingModel bookingModel;
  final UserData userData;
  const JobDetailsPage({
    super.key,
    required this.bookingModel,
    required this.userData,
  });


  @override
  Widget build(BuildContext context) {
    String bookedDate = getformattedDate(bookingModel.date);
    String todayDate = getformattedDate(DateTime.now());
    bool isStartButtonLocked = bookedDate == todayDate ? false : true;
    return Scaffold(

      appBar: handyAppBar("", context,
          isCenter: true, isneedtopop: true, iswhite: true),
      body: _buildBody(),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16, 5, 16, 28),
        child: HandymanButton(
          text: "Start Job ($bookedDate)",
          onPressed: isStartButtonLocked ? () {} : () {},
          color: isStartButtonLocked ? AppColor.greyDark : AppColor.black,
        ),
      ),

    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        bookingModel.isWorkerAccept ?? false

            ? Container(
                color: isCompleted ? AppColor.green : AppColor.red,
                height: 30,
                child: Center(
                    child: HandyLabel(

                  text: "Customer has been notified that you accepted the job!",

                  textcolor: AppColor.white,
                  isBold: true,
                  fontSize: 12,
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
          date: getformattedDate(bookingModel.date),
          jobType: bookingModel.name ?? "",
          price: bookingModel.totalFee ?? 0,
          time: bookingModel.time ?? "",
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
                    bookingModel.issue ?? "",
                  )),

              SizedBox(height: 20),
            ],
          ),
        ),

        Container(
          color: AppColor.lightGrey100,
          height: 15,
        ),
        _buildCustomerCard(),
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
                child: CachedNetworkImage(
                    imageUrl: userData.profilePic ?? "",
                    height: 55,
                    width: 55,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => HandymanLoader(),
                    errorWidget: (context, url, error) => Container(
                          height: 55,
                          width: 55,
                          color: AppColor.lightGrey100,
                          child: Icon(
                            Icons.person,
                            size: 30,
                          ),
                        ))),
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
                      text: userData.name ?? "",
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
