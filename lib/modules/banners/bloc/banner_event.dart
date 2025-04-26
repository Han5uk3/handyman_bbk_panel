import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class BannerEvent extends Equatable {
  const BannerEvent();

  @override
  List<Object?> get props => [];
}

class LoadBanners extends BannerEvent {}

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

class DeleteBannerEvent extends BannerEvent {
  final String id;
  const DeleteBannerEvent(this.id);
  @override
  List<Object> get props => [id];
}
