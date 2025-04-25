import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/outline_button.dart';
import 'package:handyman_bbk_panel/common_widget/svgicon.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EarningsPage extends StatefulWidget {
  const EarningsPage({super.key});

  @override
  State<EarningsPage> createState() => _EarningsPageState();
}

int _selectedPayoutMethod = 0;

class _EarningsPageState extends State<EarningsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16, 5, 16, 28),
        child: HandymanButton(
            text: AppLocalizations.of(context)!.payoutavailalebalance,
            onPressed: () {
              _showPayoutMethodBottomSheet(context);
            }),
      ),
      appBar: handyAppBar(AppLocalizations.of(context)!.earnings, context,
          isCenter: true, iswhite: true, isneedtopop: true),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: AppColor.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColor.lightGrey300),
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                spacing: 10,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        color: AppColor.green),
                    child:
                        loadsvg("assets/icons/profileIcons/earningsWhite.svg"),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HandyLabel(
                        text: AppLocalizations.of(context)!.totalearnings,
                        fontSize: 14,
                        textcolor: AppColor.lightGrey600,
                      ),
                      HandyLabel(
                        text: "${AppLocalizations.of(context)!.sar} 500.00",
                        isBold: true,
                      ),
                    ],
                  ),
                ],
              ),
              Container(height: 50, color: AppColor.greyDark, width: 1),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HandyLabel(
                    text: AppLocalizations.of(context)!.availablebalance,
                    fontSize: 14,
                    textcolor: AppColor.lightGrey600,
                  ),
                  HandyLabel(
                    text: "${AppLocalizations.of(context)!.sar} 100.00",
                    isBold: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPayoutMethodBottomSheet(BuildContext context) {
    List<String> payoutMethods = [
      AppLocalizations.of(context)!.paypal,
      AppLocalizations.of(context)!.upi,
      AppLocalizations.of(context)!.banktransfer,
    ];
    showModalBottomSheet(
      backgroundColor: AppColor.white,
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.75,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 6),
                          child: HandyLabel(
                            text: AppLocalizations.of(context)!.payout,
                            isBold: true,
                            fontSize: 18,
                          ),
                        ),
                        Divider(thickness: 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: HandyLabel(
                            text: AppLocalizations.of(context)!
                                .choosepayoutmethod,
                            isBold: false,
                            fontSize: 16,
                          ),
                        ),
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: payoutMethods.length,
                            itemBuilder: (context, index) {
                              return _buildPayoutOption(
                                  payoutMethods[index], index, setModalState);
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: HandymanOutlineButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  text: AppLocalizations.of(context)!.cancel,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: HandymanButton(
                                  onPressed:
                                      () {}, //depending on payout method, show different content in bottom sheet
                                  text: AppLocalizations.of(context)!.next,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPayoutOption(
      String method, int value, void Function(void Function()) setModalState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          if (_selectedPayoutMethod != value) {
            setModalState(() {
              _selectedPayoutMethod = value;
            });
          }
        },
        child: Row(
          children: [
            Expanded(
              child: HandyLabel(
                text: method,
                fontSize: 16,
                isBold: false,
              ),
            ),
            Radio<int>(
              activeColor: AppColor.green,
              value: value,
              groupValue: _selectedPayoutMethod,
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setModalState(() {
                    _selectedPayoutMethod = newValue;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
