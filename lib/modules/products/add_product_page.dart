import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/common_widget/button.dart';
import 'package:handyman_bbk_panel/common_widget/custom_drop_drown.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/snakbar.dart';
import 'package:handyman_bbk_panel/common_widget/text_field.dart';
import 'package:handyman_bbk_panel/models/products_model.dart';
import 'package:handyman_bbk_panel/modules/products/bloc/products_bloc.dart';
import 'package:handyman_bbk_panel/sheets/delete_product_sheet.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddProductPage extends StatefulWidget {
  final bool isEdit;
  final ProductsModel? productModel;
  const AddProductPage({super.key, required this.isEdit, this.productModel});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  late Map<String, String> _categoryMap;
  late Map<String, String> _availabilityMap;
  String _selectedCategory = 'Electricity';
  String _selectedAvailability = 'in stock';
  File? _imageFile;

  String? _imageUrl;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _detailsController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _logProductData() {
    if (_nameController.text.isEmpty) {
      _showErrorSnackBar(AppLocalizations.of(context)!.pleaseenterproductname);
      return;
    }

    if (_priceController.text.isEmpty) {
      _showErrorSnackBar(AppLocalizations.of(context)!.pleaseenterprice);
      return;
    }

    if (_detailsController.text.isEmpty) {
      _showErrorSnackBar(
          AppLocalizations.of(context)!.pleaseenterproductdetails);
      return;
    }

    if (_imageFile == null && !widget.isEdit) {
      _showErrorSnackBar(AppLocalizations.of(context)!.pleaseselectanimage);
      return;
    }

    widget.isEdit
        ? context.read<ProductsBloc>().add(UpdateProductEvent(
            avialability: _selectedAvailability,
            discount: _discountController.text,
            productId: widget.productModel!.id ?? ''))
        : context.read<ProductsBloc>().add(AddNewProductEvent(
            productModel: ProductsModel(
              name: _nameController.text,
              price: _priceController.text,
              details: _detailsController.text,
              discount: _discountController.text,
              availability: _selectedAvailability,
              category: _selectedCategory,
            ),
            productImage: _imageFile));
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _categoryMap = {
      'Electricity': AppLocalizations.of(context)!.electricity,
      'Plumbing': AppLocalizations.of(context)!.plumbing,
    };

    _availabilityMap = {
      'in stock': AppLocalizations.of(context)!.instock,
      'out of stock': AppLocalizations.of(context)!.outofstock,
    };

    if (widget.isEdit) {
      _nameController.text = widget.productModel?.name ?? "";
      _priceController.text = widget.productModel?.price ?? "";
      _detailsController.text = widget.productModel?.details ?? '';
      _discountController.text = widget.productModel?.discount ?? '';
      _selectedAvailability = widget.productModel?.availability ?? 'in stock';
      _selectedCategory = widget.productModel?.category ?? 'Electricity';
      _imageUrl = widget.productModel?.image;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is ProductAddingSuccessState) {
          Navigator.pop(context);
          HandySnackBar.show(
              context: context,
              message: AppLocalizations.of(context)!.productaddedsuccessfully,
              isTrue: true);
          return;
        }
        if (state is ProductAddingErrorState) {
          HandySnackBar.show(
              context: context, message: state.errorMessage, isTrue: false);
          return;
        }
        if (state is ProductDeletingSuccessState) {
          Navigator.pop(context);
          Navigator.pop(context);
          HandySnackBar.show(
              context: context,
              message: AppLocalizations.of(context)!.productdeletedsuccessfully,
              isTrue: true);
          return;
        }
        if (state is ProductDeletingErrorState) {
          HandySnackBar.show(
              context: context, message: state.errorMessage, isTrue: false);
          return;
        }
        if (state is UpdateProductSuccessState) {
          Navigator.pop(context);
          HandySnackBar.show(
              context: context,
              message: AppLocalizations.of(context)!.productupdatedsuccessfully,
              isTrue: true);
          return;
        }
        if (state is UpdateProductErrorState) {
          HandySnackBar.show(
              context: context, message: state.errorMessage, isTrue: false);
          return;
        }
      },
      child: Scaffold(
        bottomNavigationBar: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              child: HandymanButton(
                text: widget.isEdit
                    ? AppLocalizations.of(context)!.savechanges
                    : AppLocalizations.of(context)!.addproduct,
                isLoading: state is ProductAddingLoadingState ||
                    state is UpdateProductLoadingState,
                onPressed: _logProductData,
              ),
            );
          },
        ),
        appBar: handyAppBar(
            widget.isEdit
                ? (widget.productModel?.name ?? "")
                : AppLocalizations.of(context)!.addnewproduct,
            context,
            actions: widget.isEdit
                ? [
                    IconButton(
                      onPressed: () => _showProductDeleteBottomSheet(context),
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
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          IgnorePointer(
            ignoring: widget.isEdit,
            child: _buildFormField(
              label: AppLocalizations.of(context)!.productname,
              child: HandyTextField(
                  hintText: AppLocalizations.of(context)!.enterproductname,
                  controller: _nameController),
            ),
          ),
          _buildFormField(
            label: AppLocalizations.of(context)!.uploadImage,
            child: IgnorePointer(
                ignoring: widget.isEdit, child: _buildImagePicker()),
          ),
          _buildFormField(
            label: AppLocalizations.of(context)!.price,
            child: IgnorePointer(
              ignoring: widget.isEdit,
              child: HandyTextField(
                hintText: AppLocalizations.of(context)!.enterprice,
                controller: _priceController,
                keyboardType: TextInputType.number,
              ),
            ),
          ),
          _buildFormField(
            label: AppLocalizations.of(context)!.details,
            child: IgnorePointer(
              ignoring: widget.isEdit,
              child: SizedBox(
                height: 120,
                child: HandyTextField(
                  hintText: AppLocalizations.of(context)!.enteritemdetails,
                  controller: _detailsController,
                  maxlines: 9,
                  minLines: 4,
                ),
              ),
            ),
          ),
          _buildFormField(
            label: AppLocalizations.of(context)!.category,
            child: CustomDropdown(
              items: _categoryMap.values.toList(),
              hasBorder: true,
              selectedValue: _categoryMap[_selectedCategory],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = _categoryMap.entries
                      .firstWhere((entry) => entry.value == value)
                      .key; // Store English
                });
              },
            ),
          ),
          _buildFormField(
            label: AppLocalizations.of(context)!.availability,
            child: CustomDropdown(
              items: _availabilityMap.values.toList(),
              hasBorder: true,
              selectedValue: _availabilityMap[_selectedAvailability],
              onChanged: (value) {
                setState(() {
                  _selectedAvailability = _availabilityMap.entries
                      .firstWhere((entry) => entry.value == value)
                      .key;
                });
              },
            ),
          ),
          _buildFormField(
            label: AppLocalizations.of(context)!.discount,
            child: HandyTextField(
              hintText: AppLocalizations.of(context)!.enterdiscountpercentage,
              controller: _discountController,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFormField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HandyLabel(text: label, isBold: false, fontSize: 16),
        const SizedBox(height: 10),
        child,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildImagePicker() {
    final bool showNetworkImage =
        widget.isEdit && _imageUrl != null && _imageFile == null;

    return GestureDetector(
      onTap: _pickImage,
      child: _imageFile != null || showNetworkImage
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
                    child: _imageFile != null
                        ? Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            _imageUrl!,
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
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      iconSize: 17,
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          _imageFile = null;
                          if (showNetworkImage) _imageUrl = null;
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
              radius: const Radius.circular(12),
              color: AppColor.lightGrey400,
              dashPattern: const [6, 5],
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Icon(Icons.add_photo_alternate_outlined,
                    color: AppColor.lightGrey400, size: 40),
              ),
            ),
    );
  }

  void _showProductDeleteBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isDismissible: false,
      backgroundColor: AppColor.white,
      context: context,
      builder: (context) {
        return DeleteProductSheet(
          productId: widget.productModel?.id ?? "",
        );
      },
    );
  }
}
