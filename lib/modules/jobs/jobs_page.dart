// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';

import 'package:handyman_bbk_panel/common_widget/jobcard.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/outline_button.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

List<String> workers = [
  'Alice',
  'Bob',
  'Charlie',
  'Bob',
  'Charlie',
  'Bob',
  'Charlie',
  'Bob',
  'Bob',
  'Charlie',
  'Bob',
  'Bob',
  'Charlie',
  'Bob',
];
int? workerChoice;

class _JobsPageState extends State<JobsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar("Jobs", context, isCenter: true, isneedtopop: false),
      body: GestureDetector(
        onTap: () {
          _showWorkerAssignmentBottomSheet(context);
        },
        child: JobCard(
            completedDate: DateTime.now(),
            isinHistory: false,
            status: false,
            customerName: "Hansuke",
            paymentStatus: true,
            description:
                "testikjlfhcvnkdsfugksruglasifchlaskgvjalsfga ;sgfikdfubsaygvcrsifgyvrskyi lasygfawv lrsfwgszugf uklsfg lasgflsruifn aufgvvvvvvvbksurfgnlsAIfcnlasuitgvnauchfl",
            date: DateTime.now(),
            price: 110.00,
            time: "12:00 AM",
            jobID: "#101",
            jobType: "Electrical",
            address: "PKC Building, Karuvambram, Manjeri"),
      ),
    );
  }

  void _showWorkerAssignmentBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      backgroundColor: AppColor.white,
      isScrollControlled: true,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: StatefulBuilder(
            builder: (context, setState) {
              final screenHeight = MediaQuery.of(context).size.height;
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: screenHeight * 0.65,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: HandyLabel(
                            text: "Search Worker",
                            isBold: true,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(thickness: 1),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 5, 16, 10),
                          child: SearchBar(
                            elevation: WidgetStatePropertyAll(0),
                            constraints: const BoxConstraints(
                              maxHeight: 40,
                              minHeight: 40,
                              maxWidth: double.infinity,
                            ),
                            shape: const WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                            hintText: "Search Worker",
                            hintStyle: const WidgetStatePropertyAll(
                              TextStyle(color: AppColor.greyDark),
                            ),
                            leading: const Icon(Icons.search,
                                color: AppColor.greyDark),
                            backgroundColor:
                                WidgetStatePropertyAll(AppColor.lightGrey200),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: HandyLabel(
                            text: "Choose Worker",
                            isBold: false,
                            textcolor: AppColor.green,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: workers.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                trailing: Radio<int>(
                                  value: index,
                                  groupValue: workerChoice,
                                  onChanged: (value) {
                                    setState(() {
                                      workerChoice = value!;
                                    });
                                  },
                                ),
                                title: HandyLabel(text: workers[index]),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: HandymanOutlineButton(
                                  text: "Cancel",
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: HandymanButton(
                                  text: "Assign",
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
