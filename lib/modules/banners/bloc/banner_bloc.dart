import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handyman_bbk_panel/helpers/collections.dart';
import 'package:handyman_bbk_panel/services/storage_services.dart';
import 'package:path/path.dart' as path;

import 'banner_event.dart';
import 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  BannerBloc() : super(BannerInitial()) {
    on<AddHomeBanner>(_onAddHomeBanner);
    on<AddProductBanner>(_onAddProductBanner);
    on<DeleteBannerEvent>(_onDeleteBanner);
  }

  Future<void> _onAddHomeBanner(
    AddHomeBanner event,
    Emitter<BannerState> emit,
  ) async {
    emit(BannerLoading());
    try {
      String? imageUrl;
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(event.image.path)}';
      if (event.image != null) {
        imageUrl = await StorageService.uploadFile(
          filePath: event.image.path,
          fileName: fileName,
          mainPath: 'banners/home',
        );
      }

      await FirebaseCollections.banners.add({
        'image': imageUrl,
        'type': 'home',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      }).then((_) {
        emit(BannerAdded());
      }).catchError((e) {
        emit(BannerOperationFailure(e.toString()));
      });
    } catch (e) {
      emit(BannerOperationFailure(e.toString()));
    }
  }

  Future<void> _onAddProductBanner(
    AddProductBanner event,
    Emitter<BannerState> emit,
  ) async {
    emit(BannerLoading());
    try {
      String? imageUrl;
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(event.image.path)}';
      if (event.image != null) {
        imageUrl = await StorageService.uploadFile(
          filePath: event.image.path,
          fileName: fileName,
          mainPath: 'banners/product/${event.category}',
        );
      }

      await FirebaseCollections.banners.add({
        'image': imageUrl,
        'type': 'product',
        'category': event.category,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      emit(BannerAdded());
    } catch (e) {
      emit(BannerOperationFailure(e.toString()));
    }
  }

  Future<void> _onDeleteBanner(
    DeleteBannerEvent event,
    Emitter<BannerState> emit,
  ) async {
    emit(BannerLoading());
    try {
      final bannerDoc = await FirebaseCollections.banners.doc(event.id).get();
      final data = bannerDoc.data() as Map<String, dynamic>?;

      if (data != null) {
        String? mainPath;
        if (data['type'] == 'home') {
          mainPath = 'banners/home';
        } else if (data['type'] == 'product') {
          mainPath = 'banners/product/${data['category']}';
        }
        if (mainPath != null && data.containsKey('image')) {
          final fileName = path.basename(data['image']);
          await StorageService.deleteFile(mainPath, fileName);
        }
        await FirebaseCollections.banners.doc(event.id).delete();
        emit(BannerDeletedSuccess());
      } else {
        emit(BannerOperationFailure('Banner data is empty.'));
      }
    } catch (e) {
      emit(BannerOperationFailure('Failed to delete banner: ${e.toString()}'));
    }
  }
}
