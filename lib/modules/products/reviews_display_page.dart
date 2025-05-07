import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/loader.dart';
import 'package:handyman_bbk_panel/models/product_review_model.dart';
import 'package:handyman_bbk_panel/modules/products/widgets/product_review_card.dart';
import 'package:handyman_bbk_panel/services/app_services.dart';

class ReviewsDisplayPage extends StatelessWidget {
  final String productId;

  const ReviewsDisplayPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar(
        AppLocalizations.of(context)!.reviews,
        context,
        isCenter: true,
        isneedtopop: true,
        iswhite: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<List<ProductReviewModel>>(
      stream: AppServices.fetchProductReviews(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return HandymanLoader();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "${AppLocalizations.of(context)!.error}: ${snapshot.error}",
            ),
          );
        }

        final reviews = snapshot.data ?? [];

        if (reviews.isEmpty) {
          return Center(
              child: Text(AppLocalizations.of(context)!.noreviewsfound));
        }

        return ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            return ProductReviewCard(
              review: ProductReviewModel.fromJson(reviews[index].toJson()),
            );
          },
        );
      },
    );
  }
}
