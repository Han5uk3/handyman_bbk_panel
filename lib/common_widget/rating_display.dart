import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class RatingDisplay extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final bool isInHistory;
  final double iconSize;

  const RatingDisplay(
      {super.key,
      required this.rating,
      required this.reviewCount,
      required this.isInHistory,
      this.iconSize = 20});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 3,
      children: [
        HandyLabel(
          text: rating.toString(),
          isBold: true,
          fontSize: isInHistory ? 16 : 14,
        ),
        RatingBar.builder(
            allowHalfRating: true,
            itemSize: iconSize,
            maxRating: 5,
            ignoreGestures: true,
            unratedColor: AppColor.lightGrey300,
            initialRating: rating,
            itemBuilder: (context, _) =>
                Icon(Icons.star, color: AppColor.yellow),
            onRatingUpdate: (rating) {}),
        Spacer(),
        !isInHistory
            ? HandyLabel(
                text: "$reviewCount ${AppLocalizations.of(context)!.reviews}",
                isBold: false,
                fontSize: 14,
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
