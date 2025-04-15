import 'package:flutter/material.dart';

import 'package:handyman_bbk_panel/common_widget/label.dart';

import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:intl/intl.dart';

class JobCard extends StatelessWidget {
  final String customerName;
  final String description;

  final String imagePath;
  final String jobID;
  final String jobType;
  final String address;
  final DateTime date;
  final String time;
  final double price;
  final bool paymentStatus;

  const JobCard({
    super.key,
    required this.customerName,
    required this.description,
    required this.date,
    required this.imagePath,
    required this.jobID,
    required this.jobType,
    required this.address,
    required this.time,
    required this.price,
    required this.paymentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
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
                      spacing: 5,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Text(
                            "$jobID $jobType",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: AppColor.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                  minimumSize:
                                      WidgetStatePropertyAll(Size(60, 34)),
                                  maximumSize:
                                      WidgetStatePropertyAll(Size(60, 34)),
                                  backgroundColor:
                                      WidgetStatePropertyAll(AppColor.green)),
                              child: Text(
                                "Accept",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                  minimumSize:
                                      WidgetStatePropertyAll(Size(60, 34)),
                                  maximumSize:
                                      WidgetStatePropertyAll(Size(60, 34)),
                                  backgroundColor:
                                      WidgetStatePropertyAll(AppColor.red)),
                              child: Text(
                                "Reject",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            )),
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
                              color: AppColor.black,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                      HandyLabel(
                        text: "Issue Details",
                        fontSize: 14,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          imagePath,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        description,
                        textAlign: TextAlign.justify,
                      ),
                    ],
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
                        text: "${_getformattedDate(date)}",
                        fontSize: 14,
                        isBold: true,
                      ),
                    ]),
                    Container(
                      width: 1,
                      height: 40,
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
                        isBold: true,
                      ),
                    ]),
                    Container(
                      width: 1,
                      height: 40,
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
                        isBold: true,
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
}
