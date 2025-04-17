import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/rating_display.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:intl/intl.dart';

class JobCard extends StatelessWidget {
  final String customerName;
  final String description;
  final bool isinHistory;
  final String jobID;
  final String jobType;
  final String address;
  final DateTime date;
  final String time;
  final double price;
  final bool paymentStatus;
  final bool status;
  final DateTime completedDate;

  const JobCard({
    super.key,
    required this.customerName,
    required this.description,
    required this.date,
    required this.jobID,
    required this.jobType,
    required this.address,
    required this.time,
    required this.price,
    required this.paymentStatus,
    required this.isinHistory,
    required this.status,
    required this.completedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.lightGrey400),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.lightGrey200,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          flex: isinHistory ? 0 : 6,
                          child: Text(
                            "$jobID $jobType",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: AppColor.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        isinHistory
                            ? _buildStatus(status)
                            : Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: TextButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                            minimumSize: WidgetStatePropertyAll(
                                                Size(60, 34)),
                                            maximumSize: WidgetStatePropertyAll(
                                                Size(60, 34)),
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    AppColor.green)),
                                        child: Text(
                                          "Accept",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: TextButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                            minimumSize: WidgetStatePropertyAll(
                                                Size(60, 34)),
                                            maximumSize: WidgetStatePropertyAll(
                                                Size(60, 34)),
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    AppColor.red)),
                                        child: Text(
                                          "Reject",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      )),
                                ],
                              )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: HandyLabel(
                              text: "Customer Name:",
                              fontSize: 14,
                            ),
                          ),
                          HandyLabel(
                            textcolor: AppColor.lightGrey500,
                            text: customerName,
                            fontSize: 14,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: HandyLabel(
                              text: "Address:",
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            textAlign: TextAlign.justify,
                            address,
                            style: TextStyle(
                              color: AppColor.lightGrey500,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                      HandyLabel(
                        text: "Issue Details",
                        fontSize: 14,
                      ),
                      Text(
                        description,
                        style: TextStyle(color: AppColor.lightGrey500),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  thickness: 1,
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    child: RatingDisplay(
                      rating: 4.0,
                      reviewCount: 42,
                      isInHistory: false,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(spacing: 3, children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                      ),
                      HandyLabel(
                        text: "${_getformattedDate(date)}",
                        fontSize: 14,
                        isBold: false,
                      ),
                    ]),
                    Container(
                      margin: EdgeInsets.only(top: 12, bottom: 12),
                      width: 1,
                      height: 22,
                      color: AppColor.greyDark,
                    ),
                    Row(spacing: 3, children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                      ),
                      HandyLabel(
                        text: time,
                        fontSize: 14,
                        isBold: false,
                      ),
                    ]),
                    Container(
                      width: 1,
                      height: 22,
                      color: AppColor.greyDark,
                    ),
                    Row(spacing: 3, children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                      ),
                      HandyLabel(
                        text: "\$ $price",
                        fontSize: 14,
                        isBold: false,
                      ),
                      HandyLabel(
                        text: paymentStatus ? "Paid" : "Unpaid",
                        textcolor:
                            paymentStatus ? AppColor.green : AppColor.red,
                        fontSize: 14,
                      ),
                    ])
                  ],
                )
              ])),
    );
  }

  _getformattedDate(date) {
    DateFormat dateFormat = DateFormat("dd MMM");
    return dateFormat.format(date);
  }

  _buildStatus(status) {
    return Row(
      spacing: 3,
      children: [
        CircleAvatar(
          radius: 5,
          backgroundColor: status ? AppColor.green : AppColor.red,
        ),
        HandyLabel(
          textcolor: status ? AppColor.green : AppColor.red,
          text: status
              ? "Completed on ${_getformattedDate(completedDate)}"
              : "Cancelled",
          fontSize: 14,
        )
      ],
    );
  }
}
