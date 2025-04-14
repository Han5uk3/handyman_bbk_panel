import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/custom_drop_drown.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/outline_button.dart';
import 'package:handyman_bbk_panel/common_widget/text_field.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key, required this.isEdit});
  final bool isEdit;

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController discountController = TextEditingController();

  List<String> availability = ['in stock', 'out of stock'];
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        child: HandymanButton(
            text: widget.isEdit ? "Save Changes" : "Add Product",
            onPressed: () {}),
      ),
      appBar: handyAppBar(
          widget.isEdit ? "MCB/Fuse Repair" : "Add New Product", context,
          actions: widget.isEdit
              ? [
                  IconButton(
                    onPressed: () {
                      _showProductDeleteBottomSheet(context);
                    },
                    icon: Icon(
                      CupertinoIcons.trash,
                      color: AppColor.red,
                    ),
                  )
                ]
              : [],
          isCenter: true,
          isneedtopop: true,
          iswhite: true),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 16,
            ),
            IgnorePointer(
              ignoring: widget.isEdit,
              child: HandyLabel(
                text: "Product Name",
                isBold: false,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            IgnorePointer(
              ignoring: widget.isEdit,
              child: HandyTextField(
                  hintText: "Enter Product Name", controller: nameController),
            ),
            SizedBox(
              height: 16,
            ),
            HandyLabel(text: "Upload Image", isBold: false, fontSize: 16),
            SizedBox(
              height: 10,
            ),
            IgnorePointer(ignoring: widget.isEdit, child: _buildImagePicker()),
            SizedBox(
              height: 16,
            ),
            HandyLabel(
              text: "Price",
              isBold: false,
              fontSize: 16,
            ),
            SizedBox(
              height: 10,
            ),
            IgnorePointer(
              ignoring: widget.isEdit,
              child: HandyTextField(
                  hintText: "Enter Price", controller: priceController),
            ),
            SizedBox(
              height: 16,
            ),
            HandyLabel(text: "Item Details", isBold: false, fontSize: 16),
            SizedBox(
              height: 10,
            ),
            IgnorePointer(
              ignoring: widget.isEdit,
              child: SizedBox(
                height: 120,
                child: HandyTextField(
                  hintText: "Enter Item Details",
                  controller: detailsController,
                  maxlines: 9,
                  minLines: 4,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            HandyLabel(text: "Availability", isBold: false, fontSize: 16),
            SizedBox(
              height: 10,
            ),
            CustomDropdown(items: availability, hasBorder: true),
            SizedBox(
              height: 16,
            ),
            HandyLabel(
                text: "Discounts (optional)", isBold: false, fontSize: 16),
            SizedBox(
              height: 10,
            ),
            HandyTextField(
              hintText: "Enter discount percentage",
              controller: discountController,
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: _imageFile != null
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 85,
                  width: 85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: -5,
                  right: -15,
                  child: Container(
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white, // white background
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      iconSize: 17,
                      padding: EdgeInsets.all(4),
                      constraints: BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          _imageFile = null;
                        });
                      },
                    ),
                  ),
                ),
              ],
            )
          : DottedBorder(
              borderType: BorderType.RRect,
              strokeWidth: 2,
              radius: Radius.circular(12),
              color: AppColor.lightGrey400,
              dashPattern: [6, 5],
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Icon(Icons.add_photo_alternate_outlined,
                    color: AppColor.lightGrey400, size: 40),
              ),
            ),
    );
  }

  _showProductDeleteBottomSheet(context) {
    showModalBottomSheet(
      isDismissible: false,
      backgroundColor: AppColor.white,
      context: context,
      builder: (context) {
        return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                child: HandyLabel(
                  text: "Delete Product",
                  isBold: true,
                  fontSize: 16,
                ),
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: HandyLabel(
                    text: "Are you sure you want to delete this product?",
                    isBold: false,
                    fontSize: 14),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: HandyLabel(
                    text: "Note: This will remove the product from listing.",
                    isBold: false,
                    textcolor: AppColor.red,
                    fontSize: 14),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 28),
                child: Row(children: [
                  Expanded(
                    child: HandymanOutlineButton(
                      text: "Cancel",
                      textColor: AppColor.red,
                      borderColor: AppColor.red,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: HandymanButton(
                    color: AppColor.red,
                    text: "Delete",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )),
                ]),
              ),
            ]);
      },
    );
  }
}
