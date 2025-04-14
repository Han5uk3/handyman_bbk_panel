import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/modules/products/add_product_page.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Map<String, dynamic>> productData = [
    {
      "title": "MCB/Fuse Repair",
      "price": "5.00",
      "status": true,
      "image": "assets/images/image.png"
    },
    {
      "title": "MCB/Fuse Repair",
      "price": "5.00",
      "status": false,
      "image": "assets/images/image.png"
    },
    {
      "title": "MCB/Fuse Repair",
      "price": "5.00",
      "status": true,
      "image": "assets/images/image.png"
    },
    {
      "title": "MCB/Fuse Repair",
      "price": "5.00",
      "status": true,
      "image": "assets/images/image.png"
    },
    {
      "title": "MCB/Fuse Repair",
      "price": "5.00",
      "status": false,
      "image": "assets/images/image.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddProductPage(isEdit: false),
            ));
            //add product page
          }),
      appBar: handyAppBar("Products", context,
          isCenter: true,
          isneedtopop: false,
          iswhite: true,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.filter_list))
          ]),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: productData.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddProductPage(isEdit: true),
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
                    Container(
                      height: 80,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          image: DecorationImage(
                              image: AssetImage(productData[index]["image"]))),
                    ),
                    Flexible(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HandyLabel(
                              text: productData[index]["title"],
                              fontSize: 14,
                              isBold: false,
                              textcolor: AppColor.greyDark,
                            ),
                            HandyLabel(
                              text: "\$${productData[index]["price"]}",
                              isBold: true,
                              fontSize: 16,
                            ),
                            _buildStatusCard(productData[index]["status"]),
                          ]),
                    )
                  ]),
            ),
          ),
        );
      },
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 4,
              backgroundColor: status ? AppColor.green : AppColor.red,
            ),
            HandyLabel(
              text: status ? " in stock" : " out of stock",
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
