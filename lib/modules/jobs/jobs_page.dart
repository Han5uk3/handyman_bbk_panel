import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';

import 'package:handyman_bbk_panel/common_widget/jobcard.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar("Jobs", context, isCenter: true, isneedtopop: false),
      body: JobCard(
          customerName: "Hansuke",
          paymentStatus: true,
          description:
              "testikjlfhcvnkdsfugksruglasifchlaskgvjalsfga ;sgfikdfubsaygvcrsifgyvrskyi lasygfawv lrsfwgszugf uklsfg lasgflsruifn aufgvvvvvvvbksurfgnlsAIfcnlasuitgvnauchfl",
          date: DateTime.now(),
          price: 110.00,
          time: "12:00 AM",
          imagePath: "",
          jobID: "#101",
          jobType: "Electrical",
          address: "PKC Building, Karuvambram, Manjeri"),
    );
  }
}
