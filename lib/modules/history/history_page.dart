import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/jobcard.dart';
import 'package:handyman_bbk_panel/models/booking_data.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';
import 'package:handyman_bbk_panel/modules/jobs/job_details_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

List<Map<String, dynamic>> historyItems = [
  {
    "completedDate": DateTime.now(),
    "isinHistory": true,
    "status": true,
    "customerName": "Hansuke",
    "description": "plumber needed",
    "date": DateTime.now(),
    "jobType": "Plumbing",
    "address": "Karuvambram, Manjeri",
    "time": "12:00 PM",
    "price": 110.00,
    "paymentStatus": true
  },
  {
    "completedDate": DateTime.now(),
    "isinHistory": true,
    "status": false,
    "customerName": "Hansuke",
    "description": "plumber needed",
    "date": DateTime.now(),
    "jobType": "Plumbing",
    "address": "Karuvambram, Manjeri",
    "time": "12:50 PM",
    "price": 110.00,
    "paymentStatus": false
  },
  {
    "completedDate": DateTime.now(),
    "isinHistory": true,
    "status": true,
    "customerName": "Nasih",
    "description": "plumber needed",
    "date": DateTime.now(),
    "jobID": "#101",
    "jobType": "Plumbing",
    "address": "Karuvambram, Manjeri",
    "time": "12:00 PM",
    "price": 110.00,
    "paymentStatus": false
  }
];

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar(
        "History",
        context,
        iswhite: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(context) {
    return ListView.builder(
      itemCount: historyItems.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => JobDetailsPage(
              isWorkerHistory: true,
              bookingModel: BookingModel(),
              userData: UserData(),
            ),
          ));
        },
        child: JobCard(
            completedDate: historyItems[index]["completedDate"],
            isinHistory: historyItems[index]["isinHistory"],
            status: historyItems[index]["status"],
            customerName: historyItems[index]["customerName"],
            description: historyItems[index]["description"],
            date: historyItems[index]["date"],
            jobType: historyItems[index]["jobType"],
            address: historyItems[index]["address"],
            time: historyItems[index]["time"],
            price: historyItems[index]["price"],
            paymentStatus: historyItems[index]["paymentStatus"]),
      ),
    );
  }
}
