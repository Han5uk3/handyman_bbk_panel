import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:handyman_bbk_panel/modules/workers/widgets/ratingreview.dart';

class WorkerRatingPage extends StatelessWidget {
  const WorkerRatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar(AppLocalizations.of(context)!.reviews, context,
          isCenter: true, isneedtopop: true, iswhite: true),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return RatingreviewCard();
      },
      itemCount: 3,
    );
  }
}
