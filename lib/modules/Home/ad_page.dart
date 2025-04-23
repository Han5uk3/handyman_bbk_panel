import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:image_picker/image_picker.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/styles/color.dart';

class AdPage extends StatefulWidget {
  const AdPage({super.key, required this.isHomeBanner});
  final bool isHomeBanner;
  @override
  State<AdPage> createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {
  final List<File> _images = [];
  File? _electricalImage;
  File? _plumbingImage;

  Future<void> _pickImageList() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _pickImage(bool imageType) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null && imageType == true) {
      setState(() {
        _electricalImage = File(pickedFile.path);
      });
    }
    if (pickedFile != null && imageType == false) {
      setState(() {
        _plumbingImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.isHomeBanner
          ? FloatingActionButton(
              backgroundColor: AppColor.black,
              onPressed: _pickImageList,
              child: Icon(
                size: 30,
                Icons.add,
                color: AppColor.white,
              ),
            )
          : SizedBox.shrink(),
      appBar: handyAppBar(
        widget.isHomeBanner ? "Home Ads" : "Product Ads",
        context,
        isCenter: true,
        isneedtopop: true,
        iswhite: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (widget.isHomeBanner) {
      return _images.isEmpty ? _buildEmptyBanner() : _buildHomeBanner();
    } else {
      return _buildProductBanners();
    }
  }

  Widget _buildHomeBanner() {
    return ListView.builder(
      itemCount: _images.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Image.file(
                    _images[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _images.removeAt(index);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    padding: EdgeInsets.all(9),
                    child:
                        Icon(CupertinoIcons.trash, color: Colors.red, size: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyBanner() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No advertisements found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Click the button below to add a new banner.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductBanners() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HandyLabel(
            text: "Electricity Advertisement",
            fontSize: 18,
            isBold: true,
          ),
          SizedBox(
            height: 10,
          ),
          _buildImageCard(true),
          SizedBox(
            height: 25,
          ),
          HandyLabel(
            text: "Plumbing Advertisement",
            isBold: true,
            fontSize: 18,
          ),
          SizedBox(
            height: 10,
          ),
          _buildImageCard(false),
        ],
      ),
    );
  }

  Widget _buildImageCard(bool isElectrical) {
    final image = isElectrical ? _electricalImage : _plumbingImage;

    return image == null
        ? GestureDetector(
            onTap: () => _pickImage(isElectrical),
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(12),
              dashPattern: [4, 6],
              strokeWidth: 2,
              child: SizedBox(
                height: 155,
                width: double.infinity,
                child: Center(
                    child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_photo_alternate_rounded, size: 40),
                    HandyLabel(
                      text: "Click here to upload Image",
                      fontSize: 14,
                    )
                  ],
                )),
              ),
            ),
          )
        : Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Image.file(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isElectrical) {
                        _electricalImage = null;
                      } else {
                        _plumbingImage = null;
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    padding: EdgeInsets.all(9),
                    child:
                        Icon(CupertinoIcons.trash, color: Colors.red, size: 18),
                  ),
                ),
              ),
            ],
          );
  }
}
