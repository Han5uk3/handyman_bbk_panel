import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/models/review_model.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';
import 'package:handyman_bbk_panel/services/app_services.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class RatingreviewCard extends StatefulWidget {
  const RatingreviewCard({super.key, this.reviewModel});

  final ReviewModel? reviewModel;

  @override
  State<RatingreviewCard> createState() => _RatingreviewCardState();
}

class _RatingreviewCardState extends State<RatingreviewCard> {
  UserData? workerData;

  @override
  void initState() {
    fetchWorkerData();
    super.initState();
  }

  void fetchWorkerData() async {
    workerData =
        await AppServices.getUserById(isWorkerData: true, uid: AppServices.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            spacing: 10,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.green,
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HandyLabel(
                        text: workerData?.name ?? "",
                        isBold: true,
                        fontSize: 18),
                    HandyLabel(
                        text: "Rated on : ${widget.reviewModel?.createdAt}",
                        isBold: false,
                        fontSize: 14),
                  ])
            ],
          ),
          SizedBox(height: 8),
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HandyLabel(
                text: widget.reviewModel?.rating.toString() ?? "",
                isBold: true,
                fontSize: 16,
              ),
              RatingBar.builder(
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                initialRating: widget.reviewModel?.rating ?? 0.0,
                onRatingUpdate: (rating) {},
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 22,
                ignoreGestures: true,
                unratedColor: AppColor.lightGrey400,
              ),
            ],
          ),
          const SizedBox(height: 8),
          HandyLabel(
              text: widget.reviewModel?.review ?? "",
              isBold: false,
              fontSize: 14),
        ],
      ),
    );
  }
}
