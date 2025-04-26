import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/loader.dart';
import 'package:handyman_bbk_panel/models/products_model.dart';
import 'package:handyman_bbk_panel/modules/products/add_product_page.dart';
import 'package:handyman_bbk_panel/services/app_services.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: handyAppBar(
        AppLocalizations.of(context)!.products,
        context,
        isCenter: true,
        isneedtopop: false,
        iswhite: true,
      ),
      body: _buildProductsList(),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        backgroundColor: AppColor.black,
        child: Icon(
          Icons.add,
          size: 32,
          color: AppColor.white,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddProductPage(isEdit: false),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsList() {
    return StreamBuilder<List<ProductsModel>>(
      stream: AppServices.getProductsList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return HandymanLoader();
        }
        if (snapshot.hasError) {
          return Center(
              child: Text(
                  '${AppLocalizations.of(context)!.error}: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(AppLocalizations.of(context)!.noproductsavailable));
        }
        final products = snapshot.data!;
        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return _buildProductCard(product);
          },
        );
      },
    );
  }

  Widget _buildProductCard(ProductsModel productData) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddProductPage(
            isEdit: true,
            productModel: productData,
          ),
        ));
      },
      child: Card(
        elevation: 0,
        color: AppColor.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColor.lightGrey200)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 5,
              children: [
                SizedBox(
                  height: 80,
                  width: 100,
                  child: CachedNetworkImage(
                    imageUrl: productData.image ?? "",
                    placeholder: (context, url) => HandymanLoader(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Flexible(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HandyLabel(
                          text: productData.name ?? "",
                          fontSize: 14,
                          isBold: false,
                          textcolor: AppColor.greyDark,
                        ),
                        HandyLabel(
                          text:
                              "${AppLocalizations.of(context)!.sar}: ${productData.price}",
                          isBold: true,
                          fontSize: 16,
                        ),
                        _buildStatusCard(
                            productData.availability == "in stock"),
                      ]),
                )
              ]),
        ),
      ),
    );
  }

  Widget _buildStatusCard(status) {
    return Container(
      width: status ? 80 : 100,
      decoration: BoxDecoration(
          color: status ? AppColor.lightGreen : AppColor.lightRed,
          borderRadius: BorderRadius.all(Radius.circular(18))),
      padding: EdgeInsets.all(4),
      child: Center(
        child: Row(
          spacing: 3,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 4,
              backgroundColor: status ? AppColor.green : AppColor.red,
            ),
            HandyLabel(
              text: status
                  ? AppLocalizations.of(context)!.instock
                  : AppLocalizations.of(context)!.outofstock,
              isBold: false,
              fontSize: 12,
              textcolor: status ? AppColor.green : AppColor.red,
            ),
          ],
        ),
      ),
    );
  }
}
