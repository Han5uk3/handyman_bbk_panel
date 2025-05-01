import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/location_history_display.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    required this.isInWorkerHistory,
    required this.paymentStatus,
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
                text: getlocalizedjobname(jobType, context),
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
                      text: getlocalizeddate(date, context),
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
                      text: getlocalizedtime(time, context),
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
                    HandyLabel(
                      text: "${AppLocalizations.of(context)!.sar} $price",
                      fontSize: 14,
                      isBold: true,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    HandyLabel(
                      text: _getPaidtext(paymentStatus, context),
                      textcolor: paymentStatus ? AppColor.green : AppColor.red,
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

  _getPaidtext(bool paymentDone, context) {
    return paymentDone
        ? AppLocalizations.of(context)!.paid
        : AppLocalizations.of(context)!.unpaid;
  }
}

getlocalizedtime(time, context) {
  AppLocalizations ln = AppLocalizations.of(context)!;
  String tod = time
      .toString()
      .substring((time.toString().length - 2), time.toString().length);
  if (tod == "AM") {
    return "${time.toString().substring(0, time.toString().length - 2)} ${ln.am}";
  } else {
    return "${time.toString().substring(0, time.toString().length - 2)} ${ln.pm}";
  }
}

getlocalizeddate(date, context) {
  AppLocalizations ln = AppLocalizations.of(context)!;
  String month = date
      .toString()
      .substring((date.toString().length - 3), date.toString().length);

  switch (month) {
    case "Jan":
      return "${date.toString().substring(0, date.toString().length - 3)} ${ln.jan}";
    case "Feb":
      return "${date.toString().substring(0, date.toString().length - 3)} ${ln.feb}";
    case "Mar":
      return "${date.toString().substring(0, date.toString().length - 3)} ${ln.mar}";
    case "Apr":
      return "${date.toString().substring(0, date.toString().length - 3)} ${ln.apr}";
    case "May":
      return "${date.toString().substring(0, date.toString().length - 3)} ${ln.may}";
    case "Jun":
      return "${date.toString().substring(0, date.toString().length - 3)} ${ln.jun}";
    case "Jul":
      return "${date.toString().substring(0, date.toString().length - 3)} ${ln.jul}";
    case "Aug":
      return "${date.toString().substring(0, date.toString().length - 3)} ${ln.aug}";
    case "Sep":
      return "${date.toString().substring(0, date.toString().length - 3)} ${ln.sep}";
    case "Oct":
      return "${date.toString().substring(0, date.toString().length - 3)} ${ln.oct}";
    case "Nov":
      return "${date.toString().substring(0, date.toString().length - 3)} ${ln.nov}";
    case "Dec":
      return "${date.toString().substring(0, date.toString().length - 3)} ${ln.dec}";
  }
}

getlocalizedjobname(name, context) {
  AppLocalizations ln = AppLocalizations.of(context)!;
  if (name == "Electricity") {
    return ln.electricity;
  } else {
    return ln.plumbing;
  }
}
