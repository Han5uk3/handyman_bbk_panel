import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:handyman_bbk_panel/models/banners_model.dart';

abstract class BannerEvent extends Equatable {
  const BannerEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeBanners extends BannerEvent {}

class LoadProductBanners extends BannerEvent {
  final String category;

  const LoadProductBanners(this.category);

  @override
  List<Object> get props => [category];
}

class HomeBannersLoaded extends BannerEvent {
  final List<Banner> banners;

  const HomeBannersLoaded(this.banners);

  @override
  List<Object> get props => [banners];
}

class BannerErrorOccurred extends BannerEvent {
  final String error;

  const BannerErrorOccurred(this.error);

  @override
  List<Object> get props => [error];
}

class AddHomeBanner extends BannerEvent {
  final File image;

  const AddHomeBanner(this.image);

  @override
  List<Object> get props => [image];
}

class AddProductBanner extends BannerEvent {
  final File image;
  final String category;

  const AddProductBanner(this.image, this.category);

  @override
  List<Object> get props => [image, category];
}

class DeleteBanner extends BannerEvent {
  final String id;

  const DeleteBanner(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateBannerStatus extends BannerEvent {
  final String id;
  final bool isActive;

  const UpdateBannerStatus(this.id, this.isActive);

  @override
  List<Object> get props => [id, isActive];
}
class ProductBannersLoadedEvent extends BannerEvent {
  final List<Banner> banners;
  final String category;

  ProductBannersLoadedEvent(this.banners, this.category);
}