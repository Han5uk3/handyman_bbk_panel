import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handyman_bbk_panel/helpers/collections.dart';
import 'package:handyman_bbk_panel/models/products_model.dart';
import 'package:handyman_bbk_panel/services/storage_services.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsInitial()) {
    on<AddNewProductEvent>(_addNewProduct);
    on<DeleteProductEvent>(_deleteProduct);
    on<UpdateProductEvent>(_updateProduct);
  }

  void _addNewProduct(
      AddNewProductEvent event, Emitter<ProductsState> emit) async {
    emit(ProductAddingLoadingState());
    try {
      String? imageUrl;
      String? productId;

      productId = FirebaseCollections.products.doc().id;
      if (event.productImage != null) {
        try {
          imageUrl = await StorageService.uploadFile(
            mainPath: "products",
            filePath: event.productImage!.path,
            fileName: "$productId.jpg",
          );
        } catch (e) {
          // emit(
          //     ProductAddingErrorState(errorMessage: "Image upload failed: $e"));
          return;
        }
      }
      ProductsModel productsModel = ProductsModel(
          id: productId,
          name: event.productModel.name,
          price: event.productModel.price,
          details: event.productModel.details,
          discount: event.productModel.discount,
          availability: event.productModel.availability,
          category: event.productModel.category,
          image: imageUrl);

      await FirebaseCollections.products
          .doc(productId)
          .set(productsModel.toMap());
      emit(ProductAddingSuccessState());
    } catch (error) {
      emit(ProductAddingErrorState(errorMessage: error.toString()));
    }
  }

  void _deleteProduct(
      DeleteProductEvent event, Emitter<ProductsState> emit) async {
    try {
      emit(ProductDeletingLoadingState());
      await FirebaseCollections.products
          .doc(event.productId)
          .delete()
          .then((value) {
        emit(ProductDeletingSuccessState());
      }).catchError((error) {
        emit(ProductDeletingErrorState(errorMessage: error.toString()));
      });
    } catch (error) {
      emit(ProductDeletingErrorState(errorMessage: error.toString()));
    }
  }

  void _updateProduct(
      UpdateProductEvent event, Emitter<ProductsState> emit) async {
    emit(UpdateProductLoadingState());
    try {
      await FirebaseCollections.products.doc(event.productId).update({
        "discount": event.discount,
        "availability": event.avialability,
      });
      emit(UpdateProductSuccessState());
    } catch (e) {
      emit(UpdateProductErrorState(errorMessage: e.toString()));
    }
  }
}
