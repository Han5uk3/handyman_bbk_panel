import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:handyman_bbk_panel/common_widget/loader.dart';
import 'package:handyman_bbk_panel/models/review_model.dart';
import 'package:handyman_bbk_panel/modules/workers/widgets/ratingreview.dart';
import 'package:handyman_bbk_panel/services/app_services.dart';

class WorkerRatingPage extends StatefulWidget {
  final String workerId;

  const WorkerRatingPage({
    super.key,
    required this.workerId,
  });

  @override
  State<WorkerRatingPage> createState() => _WorkerRatingPageState();
}

class _WorkerRatingPageState extends State<WorkerRatingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar(AppLocalizations.of(context)!.reviews, context,
          isCenter: true, isneedtopop: true, iswhite: true),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<List<ReviewModel>>(
      stream: AppServices.getWorkerReviews(widget.workerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return HandymanLoader();
        }

        if (snapshot.hasError) {
          log('snapshot.error');
          log(snapshot.error.toString());
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final reviews = snapshot.data ?? [];

        if (reviews.isEmpty) {
          return Center(
            child: Text('No reviews available'),
          );
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            return RatingreviewCard(reviewModel: reviews[index]);
          },
          itemCount: reviews.length,
        );
      },
    );
  }
}
