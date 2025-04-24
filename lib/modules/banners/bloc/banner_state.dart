import 'package:equatable/equatable.dart';
import 'package:handyman_bbk_panel/models/banners_model.dart';

abstract class BannerState extends Equatable {
  const BannerState();

  @override
  List<Object?> get props => [];
}

class BannerInitial extends BannerState {}

class BannerLoading extends BannerState {}

class HomeBannersLoadedState extends BannerState {
  final List<Banner> banners;

  const HomeBannersLoadedState(this.banners);

  @override
  List<Object> get props => [banners];
}

class ProductBannersLoaded extends BannerState {
  final List<Banner> banners;
  final String category;

  const ProductBannersLoaded(this.banners, this.category);

  @override
  List<Object> get props => [banners, category];
}

class BannerOperationSuccess extends BannerState {
  final String message;

  const BannerOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class BannerOperationFailure extends BannerState {
  final String error;

  const BannerOperationFailure(this.error);

  @override
  List<Object> get props => [error];
}
class ProductBannersLoading extends BannerState {
  final String category;
  const ProductBannersLoading(this.category);
}