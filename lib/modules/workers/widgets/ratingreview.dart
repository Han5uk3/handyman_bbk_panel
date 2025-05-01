import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class RatingreviewCard extends StatelessWidget {
  const RatingreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Row(
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
                    HandyLabel(text: "John Doe", isBold: true, fontSize: 18),
                    HandyLabel(
                        text: "Rated on : 12/12/2022",
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
                text: "0.0",
                isBold: true,
                fontSize: 16,
              ),
              RatingBar.builder(
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                initialRating: 0,
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
          const HandyLabel(
              text: "Review text here", isBold: false, fontSize: 14),
        ],
      ),
    );
  }
}
