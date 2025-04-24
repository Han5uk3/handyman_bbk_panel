import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/loader.dart';
import 'package:handyman_bbk_panel/models/orders_model.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';
import 'package:handyman_bbk_panel/modules/orders/order_details_page.dart';
import 'package:handyman_bbk_panel/services/app_services.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

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
    return StreamBuilder<List<OrdersModel>>(
      stream: AppServices.getAllOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return HandymanLoader();
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No orders found'));
        }

        final orders = snapshot.data!;

        return SingleChildScrollView(
          child: Column(
            children:
                orders.map((order) => _buildOrderCard(context, order)).toList(),
          ),
        );
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, OrdersModel order) {
    return StreamBuilder<UserData>(
      stream: AppServices.getUserData(uid: order.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: HandymanLoader(),
            ),
          );
        }

        final userData = snapshot.data;
        final customerName = userData?.name ?? 'Unknown Customer';

        String dateStr = 'N/A';
        String timeStr = 'N/A';

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OrderDetailsPage(
                    order: order, userName: userData?.name ?? "")));
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            color: AppColor.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                side: BorderSide(color: AppColor.lightGrey300)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(children: [
                Container(
                    decoration: BoxDecoration(
                        color: AppColor.lightGrey200,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    padding: const EdgeInsets.all(20),
                    child: Icon(
                      size: 32,
                      order.isPackaged == true
                          ? Icons.check_circle
                          : Icons.shopping_bag_outlined,
                      color: order.isPackaged == true
                          ? Colors.green
                          : AppColor.black,
                    )),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HandyLabel(
                          text: customerName,
                          isBold: true,
                          fontSize: 14,
                        ),
                        const SizedBox(height: 12),
                        HandyLabel(
                          text: dateStr,
                          isBold: false,
                          fontSize: 14,
                        ),
                      ]),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HandyLabel(
                      text: timeStr,
                      isBold: false,
                      fontSize: 14,
                    ),
                    const SizedBox(height: 12),
                    HandyLabel(
                      text:
                          "\$${order.totalPrice?.toStringAsFixed(2) ?? '0.00'}",
                      isBold: true,
                      fontSize: 14,
                    ),
                  ],
                )
              ]),
            ),
          ),
        );
      },
    );
  }
}
