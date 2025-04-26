import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/models/orders_model.dart';
import 'package:handyman_bbk_panel/modules/orders/bloc/orders_bloc.dart';
import 'package:handyman_bbk_panel/modules/orders/widgets/product_card.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderDetailsPage extends StatefulWidget {
  final String userName;
  final OrdersModel order;
  const OrderDetailsPage(
      {super.key, required this.userName, required this.order});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

bool isPicked = false;

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state is MarkingSuccessState) {
          setState(() {
            isPicked = true;
          });
        }
      },
      child: Scaffold(
        appBar: handyAppBar(widget.userName, context, isneedtopop: true),
        body: _buildBody(context),
        bottomNavigationBar: _buildBottomNavBarContent(isPicked),
      ),
    );
  }

  Widget _buildBody(context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final products = widget.order.orderDetails?[index];
        return ProductCard(products: products!);
      },
      itemCount: widget.order.orderDetails?.length,
    );
  }

  Widget _buildBottomNavBarContent(bool isPacked) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 5, 16, 28),
          color: Colors.white,
          child: Column(
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
                    text:
                        "${AppLocalizations.of(context)!.sar} ${widget.order.totalPrice}",
                    isBold: true,
                    fontSize: 16,
                    textcolor: isPacked ? AppColor.greyDark : AppColor.black,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              IgnorePointer(
                ignoring: isPicked,
                child: HandymanButton(
                  color: isPicked ? AppColor.greyDark : AppColor.black,
                  isLoading: state is MarkingLoadingState,
                  text: isPicked
                      ? AppLocalizations.of(context)!.packed
                      : AppLocalizations.of(context)!.pack,
                  onPressed: () => context
                      .read<OrdersBloc>()
                      .add(MarkAsPackedEvent(orderId: widget.order.orderId!)),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
