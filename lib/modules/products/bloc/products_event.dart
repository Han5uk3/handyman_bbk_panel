part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class AddNewProductEvent extends ProductsEvent {
  final ProductsModel productModel;
  final File? productImage;
  const AddNewProductEvent({required this.productModel, this.productImage});

  @override
  List<Object> get props => [productModel, productImage!];
}

class DeleteProductEvent extends ProductsEvent {
  final String productId;
  const DeleteProductEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}

class UpdateProductEvent extends ProductsEvent {
  final String productId;
  final String avialability;
  final String discount;
  const UpdateProductEvent(
      {required this.productId,
      required this.avialability,
      required this.discount});

  @override
  List<Object> get props => [avialability, productId, discount];
}
