import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/jobcard.dart';

import 'package:handyman_bbk_panel/modules/jobs/job_details_page.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

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
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => JobDetailsPage(
              isCompleted: true,
              isHistory: true,
              date: _getformattedDate(DateTime.now()),
              jobType: "Plumbing",
              jobID: "#101",
              price: 110.00,
              time: "12:00 PM",
              isAccepted: true,
            ),
          ));
        },
        child: JobCard(
            completedDate: DateTime.now(),
            isinHistory: true,
            status: true,
            customerName: "Hansuke",
            description: "plumber needed",
            date: DateTime.now(),
            jobID: "#101",
            jobType: "Plumbing",
            address: "Karuvambram, Manjeri",
            time: "12:00 PM",
            price: 110.00,
            paymentStatus: true),
      ),
    );
  }

  _getformattedDate(date) {
    DateFormat dateFormat = DateFormat("dd MMM");
    return dateFormat.format(date);
  }
}
