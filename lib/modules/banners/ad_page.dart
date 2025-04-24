import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/loader.dart';
import 'package:handyman_bbk_panel/common_widget/snakbar.dart';
import 'package:handyman_bbk_panel/modules/banners/bloc/banner_bloc.dart';
import 'package:handyman_bbk_panel/modules/banners/bloc/banner_event.dart';
import 'package:handyman_bbk_panel/modules/banners/bloc/banner_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:handyman_bbk_panel/common_widget/appbar.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdPage extends StatefulWidget {
  const AdPage({super.key, required this.isHomeBanner});
  final bool isHomeBanner;
  @override
  State<AdPage> createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {
  bool _isUploading = false;
  Map<String, bool> _categoryUploading = {
    'electrical': false,
    'plumbing': false,
  };

  @override
  void initState() {
    super.initState();
    _loadBanners();
  }

  void _loadBanners() {
    if (widget.isHomeBanner) {
      context.read<BannerBloc>().add(LoadHomeBanners());
    } else {
      // For product page, load both electrical and plumbing banners
      context.read<BannerBloc>().add(LoadProductBanners('electrical'));
      context.read<BannerBloc>().add(LoadProductBanners('plumbing'));
    }
  }

  Future<void> _pickAndUploadImage({String? category}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (category != null) {
          _categoryUploading[category] = true;
        } else {
          _isUploading = true;
        }
      });

      try {
        final File imageFile = File(pickedFile.path);
        if (category != null) {
          // Log the category for debugging
          log('Uploading image for category: $category');
          // Upload category-specific banner (electrical/plumbing)
          context.read<BannerBloc>().add(AddProductBanner(imageFile, category));
        } else {
          // Upload home banner
          context.read<BannerBloc>().add(AddHomeBanner(imageFile));
        }
      } finally {
        setState(() {
          if (category != null) {
            _categoryUploading[category] = false;
          } else {
            _isUploading = false;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BannerBloc, BannerState>(
      listener: (context, state) {
        if (state is BannerOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          // Reload banners after successful operation
          _loadBanners();
        } else if (state is BannerOperationFailure) {
          log('Banner operation failed: ${state.error}');
          HandySnackBar.show(
            context: context,
            message: state.error,
            isTrue: false,
          );
        }
      },
      child: Scaffold(
        floatingActionButton: _buildFloatingActionButton(),
        appBar: handyAppBar(
          widget.isHomeBanner
              ? AppLocalizations.of(context)!.homeads
              : AppLocalizations.of(context)!.productads,
          context,
          isCenter: true,
          isneedtopop: true,
          iswhite: true,
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    // Show loading FAB when uploading
    if (_isUploading) {
      return FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.grey,
        child: CircularProgressIndicator(
          color: AppColor.white,
        ),
      );
    }

    // Only show FAB for home banner page
    if (widget.isHomeBanner) {
      return FloatingActionButton(
        heroTag: "add",
        backgroundColor: AppColor.black,
        onPressed: () => _pickAndUploadImage(),
        child: Icon(
          Icons.add,
          size: 30,
          color: AppColor.white,
        ),
      );
    } else {
      return SizedBox.shrink(); // No FAB for product banners
    }
  }

  Widget _buildBody() {
    return widget.isHomeBanner
        ? _buildHomeBannerList()
        : _buildProductBanners();
  }

  Widget _buildHomeBannerList() {
    return BlocBuilder<BannerBloc, BannerState>(
      builder: (context, state) {
        if (state is BannerLoading) {
          return HandymanLoader();
        } else if (state is HomeBannersLoadedState &&
            state.banners.isNotEmpty) {
          // Show list of home banners
          return ListView.builder(
            itemCount: state.banners.length,
            itemBuilder: (context, index) {
              final banner = state.banners[index];
              return _buildBannerItem(banner);
            },
          );
        } else {
          // Show empty state when no banners
          return _buildEmptyBanner();
        }
      },
    );
  }

  Widget _buildBannerItem(dynamic banner) {
    final bool hasValidImage = banner.image.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 160,
              width: double.infinity,
              child: hasValidImage
                  ? _buildNetworkImage(banner.image)
                  : _buildNoImagePlaceholder(),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: _buildDeleteButton(banner.id),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkImage(String imageUrl) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red[300]),
              SizedBox(height: 8),
              Text(
                'Failed to load image',
                style: TextStyle(color: Colors.red[300]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoImagePlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            'No image available',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(String bannerId) {
    return GestureDetector(
      onTap: () {
        log('Deleting banner with ID: $bannerId');
        context.read<BannerBloc>().add(DeleteBanner(bannerId));
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: EdgeInsets.all(9),
        child: Icon(CupertinoIcons.trash, color: Colors.red, size: 18),
      ),
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
              AppLocalizations.of(context)!.noadvertisementsfound,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.clickthebuttonbelowtoaddanewbanner,
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductBanners() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Electrical section
          HandyLabel(
            text: AppLocalizations.of(context)!.electricity,
            fontSize: 18,
            isBold: true,
          ),
          SizedBox(height: 10),
          _buildElectricalBanner(),
          SizedBox(height: 25),

          // Plumbing section
          HandyLabel(
            text: AppLocalizations.of(context)!.plumbing,
            isBold: true,
            fontSize: 18,
          ),
          SizedBox(height: 10),
          _buildPlumbingBanner(),
        ],
      ),
    );
  }

  // Dedicated builder for electrical banner
  Widget _buildElectricalBanner() {
    return BlocBuilder<BannerBloc, BannerState>(
      buildWhen: (previous, current) {
        // Only rebuild for electrical banner states
        if (current is ProductBannersLoaded) {
          return current.category == 'electrical';
        }
        if (current is ProductBannersLoading) {
          return current.category == 'electrical';
        }
        return current is BannerOperationSuccess ||
            current is BannerOperationFailure;
      },
      builder: (context, state) {
        // Show loading indicator when uploading
        if (_categoryUploading['electrical'] == true) {
          return Container(
            height: 155,
            width: double.infinity,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }

        // Show banner if loaded
        if (state is ProductBannersLoaded &&
            state.category == 'electrical' &&
            state.banners.isNotEmpty) {
          log('Found electrical banner: ${state.banners.first.id}');
          return _buildBannerItem(state.banners.first);
        }

        // Show placeholder by default
        return _buildImagePlaceholder('electrical');
      },
    );
  }

  // Dedicated builder for plumbing banner
  Widget _buildPlumbingBanner() {
    return BlocBuilder<BannerBloc, BannerState>(
      buildWhen: (previous, current) {
        // Only rebuild for plumbing banner states
        if (current is ProductBannersLoaded) {
          return current.category == 'electrical';
        }
        if (current is ProductBannersLoaded) {
          return current.category == 'plumbing';
        }
        if (current is ProductBannersLoading) {
          return current.category == 'electrical';
        }
        if (current is ProductBannersLoading) {
          return current.category == 'plumbing';
        }
        return current is BannerOperationSuccess ||
            current is BannerOperationFailure;
      },
      builder: (context, state) {
        // Show loading indicator when uploading
        if (_categoryUploading['plumbing'] == true) {
          return Container(
            height: 155,
            width: double.infinity,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
        if (_categoryUploading['electrical'] == true) {
          return Container(
            height: 155,
            width: double.infinity,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }

        // Show banner if loaded
        if (state is ProductBannersLoaded &&
            state.category == 'plumbing' &&
            state.banners.isNotEmpty) {
          log('Found plumbing banner: ${state.banners.first.id}');
          return _buildBannerItem(state.banners.first);
        }
        if (state is ProductBannersLoaded &&
            state.category == 'electrical' &&
            state.banners.isNotEmpty) {
          log('Found electrical banner: ${state.banners.first.id}');
          return _buildBannerItem(state.banners.first);
        }

        // Show placeholder by default
        return _buildImagePlaceholder('plumbing');
      },
    );
  }

  Widget _buildImagePlaceholder(String category) {
    return GestureDetector(
      onTap: () => _pickAndUploadImage(category: category),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        dashPattern: [4, 6],
        strokeWidth: 2,
        color: Colors.grey,
        child: SizedBox(
          height: 155,
          width: double.infinity,
          child: _categoryUploading[category] == true
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_photo_alternate_rounded, size: 40),
                      SizedBox(width: 8),
                      HandyLabel(
                        text: AppLocalizations.of(context)!
                            .clickheretouploadimage,
                        fontSize: 14,
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
