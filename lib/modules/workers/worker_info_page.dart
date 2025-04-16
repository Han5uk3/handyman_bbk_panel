import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class WorkerInfoPage extends StatelessWidget {
  const WorkerInfoPage({super.key, required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16, 5, 16, 28),
        child: HandymanButton(
          text: !isActive ? "Verify ID" : "De-activate Worker",
          onPressed: () {},
          color: !isActive ? AppColor.black : AppColor.red,
        ),
      ),
      appBar: handyAppBar("John Doe", context,
          isneedtopop: true, isCenter: true, iswhite: true),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(context) {
    return Column(
      children: [
        _buildWorkerCard(),
        !isActive
            ? _buildNewInfoSection(context)
            : _buildActiveInfoSection(context),
      ],
    );
  }

  Widget _buildWorkerCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 15,
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColor.skyBlue),
            ),
            Expanded(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HandyLabel(
                      text: "Worker",
                      isBold: false,
                      fontSize: 16,
                    ),
                    SizedBox(height: 10),
                    HandyLabel(
                      text: "John Doe",
                      isBold: true,
                      fontSize: 18,
                    ),
                  ]),
            ),
            IconButton(
              constraints: BoxConstraints(
                  minHeight: 60, maxHeight: 60, maxWidth: 60, minWidth: 60),
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                AppColor.lightGreen,
              )),
              onPressed: () {},
              icon: Icon(
                size: 32.5,
                Icons.location_on_outlined,
                color: AppColor.green,
              ),
            ),
            IconButton(
              constraints: BoxConstraints(
                  minHeight: 60, maxHeight: 60, maxWidth: 60, minWidth: 60),
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                AppColor.lightGreen,
              )),
              onPressed: () {},
              icon: Icon(
                size: 32.5,
                Icons.phone,
                color: AppColor.green,
              ),
            ),
          ]),
    );
  }

  Widget _buildNewInfoSection(context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Container(
                height: 20,
                color: AppColor.lightGrey200,
              ),
              SizedBox(height: 10),
              _detailRow("Gender", "Male"),
              _detailRow("Service Type", "Plumber"),
              _detailRow("Years of Experience", "2"),
              _detailRow("Email ID", "john@doe.com"),
              _detailRow("Address", "PKC Building, Karuvambram, Manjeri"),
              _detailRow("ID Proof", ""),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: Container(
                  color: AppColor.shammaam,
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.48,
                ),
              ),
              Divider(
                thickness: 1,
              ),
              _detailRow("Registered On", "12 Feb 2025, 10:00 AM")
            ]));
  }

  Widget _detailRow(title, content) {
    return Row(
      children: [
        Expanded(
          child: HandyLabel(
            text: title,
            isBold: false,
            fontSize: 14,
          ),
        ),
        HandyLabel(
          textcolor: AppColor.lightGrey500,
          text: content,
          isBold: false,
          fontSize: 14,
        )
      ],
    );
  }

  Widget _buildActiveInfoSection(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Divider(
            thickness: 1,
          ),
          Row(
            children: [
              HandyLabel(
                text: "4.0",
                isBold: true,
                fontSize: 16,
              ),
              Expanded(
                child: RatingBar.builder(
                  initialRating: 4.0,
                  minRating: 0.5,
                  maxRating: 5.0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  unratedColor: AppColor.lightGrey300,
                  itemCount: 5,
                  itemSize: 20,
                  ignoreGestures: true,
                  itemPadding: EdgeInsets.zero,
                  itemBuilder: (context, _) =>
                      Icon(Icons.star, color: AppColor.yellow),
                  onRatingUpdate: (rating) {},
                ),
              ),
              HandyLabel(
                text: "42 Reviews",
                isBold: false,
                fontSize: 16,
              )
            ],
          ),
          SizedBox(height: 20),
          _detailRow("Total Jobs", "24"),
          SizedBox(height: 16),
          _detailRow("Jobs In Queue", "1"),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
