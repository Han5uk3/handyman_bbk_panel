part of 'products_bloc.dart';

sealed class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

final class ProductsInitial extends ProductsState {}

final class ProductAddingLoadingState extends ProductsState {}

final class ProductAddingSuccessState extends ProductsState {}

final class ProductAddingErrorState extends ProductsState {
  final String errorMessage;
  const ProductAddingErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class ProductDeletingLoadingState extends ProductsState {}
final class ProductDeletingSuccessState extends ProductsState {}
final class ProductDeletingErrorState extends ProductsState {
  final String errorMessage;
  const ProductDeletingErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class UpdateProductLoadingState extends ProductsState {}
final class UpdateProductSuccessState extends ProductsState {}
final class UpdateProductErrorState extends ProductsState {
  final String errorMessage;
  const UpdateProductErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}