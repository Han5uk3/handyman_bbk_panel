import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/models/products_model.dart';
import 'package:handyman_bbk_panel/modules/orders/order_details_page.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}
ProductsModel products = ProductsModel();
class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar(
        "Orders",
        context,
        isneedtopop: false,
      ),
      body: _buildbody(context),
    );
  }

  Widget _buildbody(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildOrderCard(context),
          _buildOrderCard(context),
          _buildOrderCard(context),
          _buildOrderCard(context),
        ],
      ),
    );
  }

  Widget _buildOrderCard(context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const OrderDetailsPage()));
      },
      child: Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          color: AppColor.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              side: BorderSide(color: AppColor.lightGrey300)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(spacing: 5, children: [
              Container(
                  decoration: BoxDecoration(
                      color: AppColor.lightGrey200,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  padding: EdgeInsets.all(20),
                  child: Icon(
                    size: 32,
                    Icons
                        .shopping_bag_outlined, // if ispacked true, change to check icon with green color
                    color: AppColor.black,
                  )),
              Expanded(
                child: Column(
                    spacing: 12,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HandyLabel(
                        text: "Customername",
                        isBold: false,
                        fontSize: 14,
                      ),
                      HandyLabel(
                        text: "Date",
                        isBold: false,
                        fontSize: 14,
                      ),
                    ]),
              ),
              Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  HandyLabel(
                    text: "Time",
                    isBold: false,
                    fontSize: 14,
                  ),
                  HandyLabel(
                    text: "Total Amount",
                    isBold: false,
                    fontSize: 14,
                  ),
                ],
              )
            ]),
          )),
    );
  }
}
