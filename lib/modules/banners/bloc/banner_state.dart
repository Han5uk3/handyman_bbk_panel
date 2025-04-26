import 'package:equatable/equatable.dart';

abstract class BannerState extends Equatable {
  const BannerState();

  @override
  List<Object?> get props => [];
}

class BannerInitial extends BannerState {}

class BannerLoading extends BannerState {}

class BannerAdded extends BannerState {}

class BannerOperationFailure extends BannerState {
  final String error;
  const BannerOperationFailure(this.error);
}

class BannerDeletedSuccess extends BannerState {}
