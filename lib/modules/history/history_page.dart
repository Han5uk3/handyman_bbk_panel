import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/loader.dart';
import 'package:handyman_bbk_panel/models/booking_data.dart';
import 'package:handyman_bbk_panel/modules/workers/widgets/jobcard.dart';
import 'package:handyman_bbk_panel/services/app_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar(
        AppLocalizations.of(context)!.history,
        context,
        iswhite: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<List<BookingModel>>(
      stream: AppServices.getHistoryBookingsByWorkerId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return HandymanLoader();
        }

        if (snapshot.hasError) {
          return Center(
              child: Text(
                  '${AppLocalizations.of(context)!.somethingwentwrong}: ${snapshot.error}'));
        }

        final historyList = snapshot.data ?? [];

        if (historyList.isEmpty) {
          return Center(
              child: Text(
                  AppLocalizations.of(context)!.nobookinghistoryavailable));
        }

        return ListView.builder(
          itemCount: historyList.length,
          itemBuilder: (context, index) {
            final booking = historyList[index];
            return JobCard(
              bookingData: booking,
              isHistoryPage: true,
            );
          },
        );
      },
    );
  }
}
