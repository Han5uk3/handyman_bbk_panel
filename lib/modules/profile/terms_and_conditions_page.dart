import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar(
        AppLocalizations.of(context)!.termsAndConditions,
        context,
        isCenter: true,
        isneedtopop: true,
        iswhite: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 5, right: 16, left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.justify,
                style: TextStyle(color: AppColor.lightGrey500, fontSize: 14),
                AppLocalizations.of(context)!.termswelcome,
              ),
              _buildtermscontent(
                "1. ${AppLocalizations.of(context)!.overview}",
                AppLocalizations.of(context)!.overviewdesc,
              ),
              _buildtermscontent(
                "2. ${AppLocalizations.of(context)!.workerreg}",
                AppLocalizations.of(context)!.workerregdesc,
              ),
              _buildtermscontent(
                "3. ${AppLocalizations.of(context)!.adminrole}",
                AppLocalizations.of(context)!.adminroledesc,
              ),
              _buildtermscontent(
                "4. ${AppLocalizations.of(context)!.locationtracking}",
                AppLocalizations.of(context)!.locationtrackingdesc,
              ),
              _buildtermscontent(
                "5. ${AppLocalizations.of(context)!.servicerequestmanagement}",
                AppLocalizations.of(context)!.servicerequestmanagementdesc,
              ),
              _buildtermscontent(
                "6. ${AppLocalizations.of(context)!.paymentsandEarnings}",
                AppLocalizations.of(context)!.paymentsandEarningsdesc,
              ),
              _buildtermscontent(
                  "7. ${AppLocalizations.of(context)!.reviewaandratings}",
                  AppLocalizations.of(context)!.reviewsandratingsdesc),
              _buildtermscontent(
                  "8. ${AppLocalizations.of(context)!.dataprivacyandsecuirity}",
                  AppLocalizations.of(context)!.dataprivacyandsecuiritydesc),
              _buildtermscontent(
                  "9. ${AppLocalizations.of(context)!.termination}",
                  AppLocalizations.of(context)!.terminationdesc),
              _buildtermscontent(
                "10. ${AppLocalizations.of(context)!.updatesandnotifications}",
                AppLocalizations.of(context)!.updatesandnotificationsdesc,
              ),
              _buildtermscontent(
                "11. ${AppLocalizations.of(context)!.modifications}",
                AppLocalizations.of(context)!.modificationsdesc,
              ),
              _buildtermscontent(
                "12. ${AppLocalizations.of(context)!.governinglaw}",
                AppLocalizations.of(context)!.governinglawdesc,
              ),
              _buildtermscontent(
                "13. ${AppLocalizations.of(context)!.contact}",
                AppLocalizations.of(context)!.contactdesc,
              ),
              SizedBox(height: 12),
              Text(
                "${AppLocalizations.of(context)!.email}: [email]",
                style: TextStyle(color: AppColor.lightGrey500, fontSize: 14),
              ),
              Text(
                "${AppLocalizations.of(context)!.phone}: [phone number]",
                style: TextStyle(color: AppColor.lightGrey500, fontSize: 14),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  _buildtermscontent(head, desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        HandyLabel(text: head, isBold: true),
        SizedBox(height: 20),
        Text(
          textAlign: TextAlign.justify,
          style: TextStyle(color: AppColor.lightGrey500, fontSize: 14),
          desc,
        ),
      ],
    );
  }
}
