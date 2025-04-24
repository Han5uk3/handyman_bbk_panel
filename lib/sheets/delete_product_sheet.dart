import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/outline_button.dart';
import 'package:handyman_bbk_panel/modules/products/bloc/products_bloc.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteProductSheet extends StatelessWidget {
  final String productId;
  const DeleteProductSheet({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                  child: HandyLabel(
                    text: AppLocalizations.of(context)!.deleteproduct,
                    isBold: true,
                    fontSize: 16,
                  ),
                ),
                const Divider(thickness: 1),
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HandyLabel(
                          text: AppLocalizations.of(context)!.areyousureyouwanttodeletethisproduct,
                          isBold: false,
                          fontSize: 14),
                      HandyLabel(
                          text:
                              AppLocalizations.of(context)!.thiswillremovetheproductfromlisting,
                          isBold: false,
                          textcolor: AppColor.red,
                          fontSize: 14),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 28),
                  child: Row(children: [
                    Expanded(
                      child: HandymanOutlineButton(
                        text: AppLocalizations.of(context)!.cancel,
                        textColor: AppColor.red,
                        borderColor: AppColor.red,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: HandymanButton(
                      color: AppColor.red,
                      text: AppLocalizations.of(context)!.delete,
                      isLoading: state is ProductDeletingLoadingState,
                      onPressed: () => context
                          .read<ProductsBloc>()
                          .add(DeleteProductEvent(productId: productId)),
                    )),
                  ]),
                ),
              ]),
        );
      },
    );
  }
}
