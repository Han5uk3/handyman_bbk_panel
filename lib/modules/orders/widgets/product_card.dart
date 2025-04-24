import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/models/products_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class ProductCard extends StatelessWidget {
  final ProductsModel products;
  const ProductCard({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.white,
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColor.lightGrey300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Container(
                height: 100,
                width: 150,
                color: AppColor.lightGrey100,
                child: CachedNetworkImage(
                  imageUrl: products.image ?? '',
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 36,
                      color: AppColor.lightGrey400,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${products.name}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (products.discount != '0')
                        _buildDiscountBadge(products.discount ?? ''),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "${products.price}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _buildAvailabilityBadge(products.availability ?? '', context),
                  Text(
                    "${products.price}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountBadge(String discount) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColor.lightGreen,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        "$discount %",
        style: TextStyle(
          color: AppColor.green,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAvailabilityBadge(String availability, context) {
    final isInStock = availability.toLowerCase() == "in stock";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: isInStock ? AppColor.lightGreen : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _getLocalizedName(availability, context),
        style: TextStyle(
          color: isInStock ? AppColor.green : Colors.red[700],
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  _getLocalizedName(String text, context) {
    AppLocalizations locn = AppLocalizations.of(context)!;
    switch (text) {
      case "in stock":
        return locn.instock;
      case "out of stock":
        return locn.outofstock;
      default:
        return text;
    }
  }
}
