import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/models/products_model.dart';
import 'package:handyman_bbk_panel/modules/orders/widgets/product_card.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

bool isPicked = false;
ProductsModel products = ProductsModel();

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar("Customername", context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomNavBarContent(isPicked),
    );
  }

  Widget _buildBody(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProductCard(products: products),
          ProductCard(products: products),
          ProductCard(products: products),
          ProductCard(products: products),
        ],
      ),
    );
  }

  Widget _buildBottomNavBarContent(isPacked) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 5, 16, 28),
      child: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HandyLabel(
                text: "${AppLocalizations.of(context)!.totalcost}: ",
                isBold: true,
                fontSize: 16,
                textcolor: isPacked ? AppColor.greyDark : AppColor.black,
              ),
              HandyLabel(
                text: "${AppLocalizations.of(context)!.sar} 20",
                isBold: true,
                fontSize: 16,
                textcolor: isPacked ? AppColor.greyDark : AppColor.black,
              ),
            ],
          ),
          IgnorePointer(
            ignoring: isPacked,
            child: HandymanButton(
                color: isPacked ? AppColor.greyDark : AppColor.black,
                text: isPacked
                    ? AppLocalizations.of(context)!.packed
                    : AppLocalizations.of(context)!.pack,
                onPressed: () {
                  setState(() {
                    isPicked = true;
                  });
                }),
          ),
        ],
      ),
    );
  }
}
