import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handyman_bbk_panel/helpers/collections.dart';
import 'package:handyman_bbk_panel/models/banners_model.dart';
import 'package:handyman_bbk_panel/services/storage_services.dart';
import 'package:path/path.dart' as path;

import 'banner_event.dart';
import 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  StreamSubscription? _homeBannersSubscription;
  StreamSubscription? _productBannersSubscription;

  BannerBloc() : super(BannerInitial()) {
    on<LoadHomeBanners>(_onLoadHomeBanners);
    on<LoadProductBanners>(_onLoadProductBanners);
    on<AddHomeBanner>(_onAddHomeBanner);
    on<AddProductBanner>(_onAddProductBanner);
    on<DeleteBanner>(_onDeleteBanner);
    on<UpdateBannerStatus>(_onUpdateBannerStatus);
    on<HomeBannersLoaded>(_onHomeBannersLoaded);
    on<BannerErrorOccurred>(_onBannerErrorOccurred);
    on<ProductBannersLoadedEvent>((event, emit) {
      emit(ProductBannersLoaded(event.banners, event.category));
    });
  }

  void _onHomeBannersLoaded(
    HomeBannersLoaded event,
    Emitter<BannerState> emit,
  ) {
    emit(HomeBannersLoadedState(event.banners));
  }

  void _onBannerErrorOccurred(
    BannerErrorOccurred event,
    Emitter<BannerState> emit,
  ) {
    emit(BannerOperationFailure(event.error));
  }

  Future<void> _onLoadHomeBanners(
    LoadHomeBanners event,
    Emitter<BannerState> emit,
  ) async {
    emit(BannerLoading());
    try {
      await _homeBannersSubscription?.cancel();
      _homeBannersSubscription = FirebaseCollections.banners
          .where('type', isEqualTo: 'home')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
        final banners = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Banner.fromMap({...data, 'id': doc.id});
        }).toList();
        add(HomeBannersLoaded(banners));
      }, onError: (error) {
        add(BannerErrorOccurred(error.toString()));
      });
    } catch (e) {
      emit(BannerOperationFailure(e.toString()));
    }
  }

  Future<void> _onLoadProductBanners(
    LoadProductBanners event,
    Emitter<BannerState> emit,
  ) async {
    emit(ProductBannersLoading(event.category));
    try {
      await _productBannersSubscription?.cancel();
      _productBannersSubscription = FirebaseCollections.banners
          .where('type', isEqualTo: 'product')
          .where('category', isEqualTo: event.category)
          .snapshots()
          .listen((snapshot) {
        List<Banner> banners = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Banner.fromMap({...data, 'id': doc.id});
        }).toList();
        log(banners.toString());
        add(ProductBannersLoadedEvent(banners, event.category)); // ✅
      }, onError: (error) {
        add(BannerErrorOccurred(error.toString())); // ✅
      });
    } catch (e) {
      emit(BannerOperationFailure(e.toString()));
    }
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
        emit(BannerOperationSuccess('Home banner added successfully'));
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
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(event.image.path)}';
      final imageUrl = await StorageService.uploadFile(
        filePath: event.image.path,
        fileName: fileName,
        mainPath: 'banners/product/${event.category}',
      );

      await FirebaseCollections.banners.add({
        'image': imageUrl,
        'type': 'product',
        'category': event.category,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      emit(BannerOperationSuccess('Product banner added successfully'));
    } catch (e) {
      emit(BannerOperationFailure(e.toString()));
    }
  }

  Future<void> _onDeleteBanner(
    DeleteBanner event,
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

        emit(BannerOperationSuccess('Banner deleted successfully'));
      } else {
        emit(BannerOperationFailure('Banner data is empty.'));
      }
    } catch (e) {
      emit(BannerOperationFailure('Failed to delete banner: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateBannerStatus(
    UpdateBannerStatus event,
    Emitter<BannerState> emit,
  ) async {
    emit(BannerLoading());
    try {
      await FirebaseCollections.banners
          .doc(event.id)
          .update({'isActive': event.isActive});
      emit(BannerOperationSuccess('Banner status updated successfully'));
    } catch (e) {
      emit(BannerOperationFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _homeBannersSubscription?.cancel();
    _productBannersSubscription?.cancel();
    return super.close();
  }
}
