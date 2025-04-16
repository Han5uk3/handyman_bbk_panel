import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/svgicon.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class EarningsPage extends StatefulWidget {
  const EarningsPage({super.key});

  @override
  State<EarningsPage> createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16, 5, 16, 28),
        child: HandymanButton(
            text: "Payout Available Balance",
            onPressed: () {
              // show payment methout bottom sheet
            }),
      ),
      appBar: handyAppBar("Earnings", context,
          isCenter: true, iswhite: true, isneedtopop: true),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: AppColor.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColor.lightGrey300),
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                spacing: 10,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        color: AppColor.green),
                    child:
                        loadsvg("assets/icons/profileIcons/earningsWhite.svg"),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HandyLabel(
                        text: "Total Earnings",
                        fontSize: 14,
                        textcolor: AppColor.lightGrey600,
                      ),
                      HandyLabel(
                        text: "\$500.00",
                        isBold: true,
                      ),
                    ],
                  ),
                ],
              ),
              Container(height: 50, color: AppColor.greyDark, width: 1),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HandyLabel(
                    text: "Available Balance",
                    fontSize: 14,
                    textcolor: AppColor.lightGrey600,
                  ),
                  HandyLabel(
                    text: "\$100.00",
                    isBold: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
