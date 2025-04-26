import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handyman_bbk_panel/common_widget/label.dart';
import 'package:handyman_bbk_panel/common_widget/loader.dart';
import 'package:handyman_bbk_panel/common_widget/snakbar.dart';
import 'package:handyman_bbk_panel/models/banners_model.dart';
import 'package:handyman_bbk_panel/modules/banners/bloc/banner_bloc.dart';
import 'package:handyman_bbk_panel/modules/banners/bloc/banner_event.dart';
import 'package:handyman_bbk_panel/modules/banners/bloc/banner_state.dart';
import 'package:handyman_bbk_panel/services/app_services.dart';
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

class _AdPageState extends State<AdPage> with SingleTickerProviderStateMixin {
  bool _isUploading = false;
  final Map<String, bool> _categoryUploading = {
    'electrical': false,
    'electricity': false,
    'plumbing': false,
    'homeProductAds': false,
  };

  // Animation controllers
  late AnimationController _uploadAnimationController;
  late Animation<double> _uploadAnimation;

  @override
  void initState() {
    super.initState();
    _uploadAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _uploadAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _uploadAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _uploadAnimationController.dispose();
    super.dispose();
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

      // Start the upload animation
      _uploadAnimationController.reset();
      _uploadAnimationController.repeat();

      try {
        final File imageFile = File(pickedFile.path);
        if (category != null) {
          context.read<BannerBloc>().add(AddProductBanner(imageFile, category));
        } else {
          context.read<BannerBloc>().add(AddHomeBanner(imageFile));
        }
      } finally {
        // We'll stop the animation in the listener when the upload completes
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BannerBloc, BannerState>(
      listener: (context, state) {
        if (state is BannerAdded) {
          // Stop the animation when upload completes
          _uploadAnimationController.stop();

          // Reset upload states
          setState(() {
            _isUploading = false;
            _categoryUploading.forEach((key, value) {
              _categoryUploading[key] = false;
            });
          });

          HandySnackBar.show(
            context: context,
            message: "Banner added successfully",
            isTrue: true,
          );
          return;
        }
        if (state is BannerOperationFailure) {
          // Stop the animation when upload fails
          _uploadAnimationController.stop();

          // Reset upload states
          setState(() {
            _isUploading = false;
            _categoryUploading.forEach((key, value) {
              _categoryUploading[key] = false;
            });
          });

          Navigator.pop(context);
          HandySnackBar.show(
            context: context,
            message: state.error,
            isTrue: false,
          );
          return;
        } else if (state is BannerOperationFailure) {
          // Stop the animation when operation fails
          _uploadAnimationController.stop();

          // Reset upload states
          setState(() {
            _isUploading = false;
            _categoryUploading.forEach((key, value) {
              _categoryUploading[key] = false;
            });
          });

          HandySnackBar.show(
            context: context,
            message: state.error,
            isTrue: false,
          );
        }
        if (state is BannerDeletedSuccess) {
          HandySnackBar.show(
            context: context,
            message: "Banner deleted successfully",
            isTrue: true,
          );
          return;
        }
      },
      child: Scaffold(
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
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    if (_isUploading) {
      return FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.grey,
        child: AnimatedBuilder(
          animation: _uploadAnimationController,
          builder: (context, child) {
            return CircularProgressIndicator(
              value: _uploadAnimation.value,
              color: AppColor.white,
              strokeWidth: 3,
            );
          },
        ),
      );
    }

    if (widget.isHomeBanner) {
      return FloatingActionButton(
        heroTag: AppLocalizations.of(context)!.add,
        backgroundColor: AppColor.black,
        onPressed: () => _pickAndUploadImage(),
        child: Icon(
          Icons.add,
          size: 30,
          color: AppColor.white,
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildBody() {
    return widget.isHomeBanner
        ? _buildHomeBannerList()
        : _buildProductBanners();
  }

  Widget _buildHomeBannerList() {
    return StreamBuilder<List<BannerModel>>(
      stream: AppServices.getBanners(isHome: true),
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
          return _buildEmptyBanner();
        }
        final banners = snapshot.data!;

        return ListView.builder(
          itemCount: banners.length,
          itemBuilder: (context, index) {
            final banner = banners[index];
            return _buildBannerItem(banner);
          },
        );
      },
    );
  }

  Widget _buildBannerItem(BannerModel banner) {
    final bool hasValidImage = banner.image?.isNotEmpty ?? false;
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
                  ? _buildNetworkImage(banner.image ?? "")
                  : _buildNoImagePlaceholder(),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: _buildDeleteButton(banner.id ?? ''),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkImage(String imageUrl) {
    return SizedBox(
      height: 155,
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          return HandymanLoader();
        },
        errorListener: (value) => (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red[300]),
                SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.failedtoloadimage,
                  style: TextStyle(color: Colors.red[300]),
                ),
              ],
            ),
          );
        },
      ),
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
            AppLocalizations.of(context)!.noimageavailable,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(String bannerId) {
    return GestureDetector(
      onTap: () => context.read<BannerBloc>().add(DeleteBannerEvent(bannerId)),
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
    return StreamBuilder<List<BannerModel>>(
      stream: AppServices.getBanners(isHome: false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return HandymanLoader();
        }
        if (snapshot.hasError) {
          return Center(
              child: Text(
                  '${AppLocalizations.of(context)!.error}: ${snapshot.error}'));
        }

        List<BannerModel> banners = snapshot.data ?? [];

        BannerModel? getBannerFor(String category) {
          return banners.firstWhere(
            (banner) => banner.category == category,
            orElse: () => BannerModel(category: category),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HandyLabel(
                text: "Home Product Ads",
                fontSize: 18,
                isBold: true,
              ),
              SizedBox(height: 10),
              _buildImagePlaceholder('homeProductAds',
                  banner: getBannerFor('homeProductAds')),
              SizedBox(height: 25),
              HandyLabel(
                text: AppLocalizations.of(context)!.electricity,
                fontSize: 18,
                isBold: true,
              ),
              SizedBox(height: 10),
              _buildImagePlaceholder('electricity',
                  banner: getBannerFor('electricity')),
              SizedBox(height: 25),
              HandyLabel(
                text: AppLocalizations.of(context)!.plumbing,
                isBold: true,
                fontSize: 18,
              ),
              SizedBox(height: 10),
              _buildImagePlaceholder('plumbing',
                  banner: getBannerFor('plumbing')),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePlaceholder(String category, {BannerModel? banner}) {
    final isImageAvailable =
        banner?.image != null && (banner?.image?.isNotEmpty ?? false);
    final isUploading = _categoryUploading[category] == true;

    return GestureDetector(
      onTap: !isImageAvailable && !isUploading
          ? () => _pickAndUploadImage(category: category)
          : null,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        dashPattern: [4, 6],
        strokeWidth: 2,
        color: Colors.grey,
        child: isImageAvailable
            ? _buildBannerItem(banner ?? BannerModel(category: category))
            : SizedBox(
                height: 155,
                width: double.infinity,
                child: isUploading
                    ? _buildUploadingAnimation()
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

  Widget _buildUploadingAnimation() {
    // Reset and start animation
    if (!_uploadAnimationController.isAnimating) {
      _uploadAnimationController.reset();
      _uploadAnimationController.repeat();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _uploadAnimationController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Animated progress indicator
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      value: _uploadAnimation.value,
                      color: AppColor.black,
                      strokeWidth: 3,
                    ),
                  ),
                  // Upload icon in the center
                  Icon(Icons.cloud_upload, size: 28),
                ],
              );
            },
          ),
          SizedBox(height: 16),
          HandyLabel(
            text: "Uploading...",
            fontSize: 14,
          ),
          SizedBox(height: 8),
          HandyLabel(
            text: "Please wait...",
            fontSize: 12,
            textcolor: Colors.grey,
          ),
        ],
      ),
    );
  }
}
