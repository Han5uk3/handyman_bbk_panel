import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/models/review_model.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';
import 'package:handyman_bbk_panel/services/app_services.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RatingreviewCard extends StatefulWidget {
  const RatingreviewCard({super.key, this.reviewModel});

  final ReviewModel? reviewModel;

  @override
  State<RatingreviewCard> createState() => _RatingreviewCardState();
}

class _RatingreviewCardState extends State<RatingreviewCard> {
  UserData? userData;

  @override
  void initState() {
    fetchWorkerData();
    super.initState();
  }

  void fetchWorkerData() async {
    userData = await AppServices.getUserById(
        uid: widget.reviewModel?.uid, isWorkerData: false);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[200]!, width: 0.5),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey[50]!],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: userData?.profilePic != null &&
                              userData!.profilePic!.isNotEmpty
                          ? NetworkImage(userData!.profilePic!) as ImageProvider
                          : const AssetImage(
                              'assets/images/avatar_placeholder.png'),
                      child: userData?.profilePic == null ||
                              userData!.profilePic!.isEmpty
                          ? Icon(Icons.person,
                              size: 30, color: Colors.grey[400])
                          : null,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HandyLabel(
                            text: userData?.name ?? "User",
                            isBold: true,
                            fontSize: 18,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${AppLocalizations.of(context)!.ratedon} : ${widget.reviewModel?.createdAt}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.reviewModel?.rating.toStringAsFixed(1) ?? "0.0",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 8),
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
                ),
                const SizedBox(height: 16),
                if (widget.reviewModel?.review != null &&
                    widget.reviewModel!.review.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    child: Text(
                      widget.reviewModel?.review ?? "",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[800],
                        height: 1.4,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
