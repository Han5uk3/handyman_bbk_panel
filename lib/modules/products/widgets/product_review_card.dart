import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:handyman_bbk_panel/models/product_review_model.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';
import 'package:handyman_bbk_panel/services/app_services.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:intl/intl.dart';

class ProductReviewCard extends StatelessWidget {
  final ProductReviewModel review;

  const ProductReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final rating = review.rating?.toDouble() ?? 0.0;
    final formattedDate = review.date != null
        ? DateFormat('dd MMM yyyy • hh:mm a').format(review.date!.toLocal())
        : AppLocalizations.of(context)!.nodateavailable;

    return StreamBuilder<UserData>(
      stream: AppServices.getUserData(uid: review.uid),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildProfileImage(user?.profilePic),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HandyLabel(
                            text: user?.name ?? AppLocalizations.of(context)!.anonymoususer,
                            isBold: true,
                            fontSize: 16,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getRatingColor(rating),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                RatingBar.builder(
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  initialRating: rating,
                  onRatingUpdate: (_) {},
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 18,
                  ignoreGestures: true,
                  unratedColor: AppColor.lightGrey400,
                ),
                if (review.comment != null && review.comment!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Text(
                    review.comment!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade800,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileImage(String? profilePicUrl) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: ClipOval(
        child: profilePicUrl != null &&
                profilePicUrl.isNotEmpty &&
                profilePicUrl != "file:///"
            ? Image.network(
                profilePicUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackAvatar();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                      color: Colors.grey.shade400,
                    ),
                  );
                },
              )
            : _buildFallbackAvatar(),
      ),
    );
  }

  Widget _buildFallbackAvatar() {
    return Center(
      child: Icon(
        Icons.person,
        size: 30,
        color: Colors.grey.shade500,
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.5) return Colors.green;
    if (rating >= 3.5) return Colors.teal;
    if (rating >= 2.5) return Colors.orange;
    return Colors.redAccent;
  }
}
