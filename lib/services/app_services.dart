import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:handyman_bbk_panel/helpers/collections.dart';
import 'package:handyman_bbk_panel/helpers/hive_helpers.dart';
import 'package:handyman_bbk_panel/models/banners_model.dart';
import 'package:handyman_bbk_panel/models/booking_data.dart';
import 'package:handyman_bbk_panel/models/orders_model.dart';
import 'package:handyman_bbk_panel/models/product_review_model.dart';
import 'package:handyman_bbk_panel/models/products_model.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';

class AppServices {
  static String? uid = HiveHelper.getUID();

  static Stream<UserData> getUserData({String? uid, bool? isFromPanel}) {
    if (isFromPanel ?? false) {
      return FirebaseCollections.workers.doc(uid).snapshots().map((event) {
        return UserData.fromMap(event.data() as Map<String, dynamic>);
      });
    }
    return FirebaseCollections.users.doc(uid).snapshots().map((event) {
      return UserData.fromMap(event.data() as Map<String, dynamic>);
    });
  }

  static Stream<int> getWorkersCount() {
    return FirebaseCollections.workers
        .where("userType", isEqualTo: "Worker")
        .snapshots()
        .map((event) => event.docs.length);
  }

  static Stream<int> getScheduleUrgentCount({bool isUrgent = false}) {
    return FirebaseCollections.bookings
        .where("isUrgent", isEqualTo: isUrgent)
        .snapshots()
        .map((event) => event.docs.length);
  }

  static Stream<int> getProductsCount() {
    return FirebaseCollections.products.snapshots().map((event) {
      return event.docs.length;
    });
  }

  static Stream<List<ProductsModel>> getProductsList() {
    return FirebaseCollections.products.snapshots().map((event) => event.docs
        .map((e) => ProductsModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }

  static Stream<List<UserData>> getWorkersList() {
    return FirebaseCollections.workers
        .where("userType", isEqualTo: "Worker")
        .snapshots()
        .map((event) => event.docs
            .map((e) => UserData.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  static Stream<List<BookingModel>> getBookingDataList() {
    return FirebaseCollections.bookings.snapshots().map((event) => event.docs
        .map((e) => BookingModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }

  static Future<UserData?> getUserById(
      {String? uid, bool isWorkerData = false}) async {
    try {
      if (isWorkerData) {
        final DocumentSnapshot doc =
            await FirebaseCollections.workers.doc(uid).get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          return UserData.fromMap(data);
        } else {
          return null;
        }
      }
      final DocumentSnapshot doc =
          await FirebaseCollections.users.doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return UserData.fromMap(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Stream<UserData?> getUserStream(String uid) {
    return FirebaseCollections.users.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserData.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

  static Stream<List<BookingModel>> getBookingsStream(
      {bool? isUrgent,
      String? status,
      String? secondStatus,
      String? workingStatus,
      String? completedStatus}) {
    Query query = FirebaseCollections.bookings;

    if (isUrgent != null) {
      query = query.where('isUrgent', isEqualTo: isUrgent);
    }

    if (status != null && secondStatus != null) {
      // If both status and secondStatus are provided, use `in` for an OR condition
      query = query.where('status',
          whereIn: [status, secondStatus, workingStatus, completedStatus]);
    } else if (status != null) {
      // If only status is provided
      query = query.where('status', isEqualTo: status);
    }

    // Uncomment the orderBy if you want to order by date
    // query = query.orderBy('date', descending: true);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return BookingModel.fromMap(data);
      }).toList();
    });
  }

  static Stream<List<BookingModel>> getUrgentBookingsForWorker(
      {bool isAdmin = false}) {
    var query = FirebaseCollections.bookings.where('isUrgent', isEqualTo: true);

    if (isAdmin) {
      query = query.where('status', whereIn: ['no_workers', 'U', 'A', 'W']);
    } else {
      query = query.where('status', whereIn: ['U', 'A', 'W']).where(
          'visibleToWorkers',
          arrayContains: uid);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return BookingModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  static Stream<List<BookingModel>> getBookingsByWorkerId() {
    return FirebaseCollections.bookings
        .where('workerData.uid', isEqualTo: uid)
        .where('status', whereIn: ["P", "W"])
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return BookingModel.fromMap(data);
          }).toList();
        });
  }

  static Stream<List<BookingModel>> getHistoryBookingsByWorkerId() {
    return FirebaseCollections.bookings
        .where('workerData.uid', isEqualTo: uid)
        .where('status', isEqualTo: "C")
        // .where('isBookingcancel', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return BookingModel.fromMap(data);
      }).toList();
    });
  }

  static Stream<int> getWorkerTotalJobsCount() {
    return FirebaseCollections.bookings
        .where('workerData.uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  static Stream<int> getWorkerUrgentJobsCount() {
    return FirebaseCollections.bookings
        .where('workerData.uid', isEqualTo: uid)
        .where('isUrgent', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  static Stream<int> getWorkerScheduledJobsCount() {
    return FirebaseCollections.bookings
        .where('workerData.uid', isEqualTo: uid)
        .where('isUrgent', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  static Stream<List<OrdersModel>> getAllOrders() {
    return FirebaseCollections.orders.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return OrdersModel.fromJson(data);
      }).toList();
    });
  }

  static Future<void> updateFCMToken(String token) async {
    if (uid == null && uid!.isEmpty) {
      return;
    } else {
      try {
        return FirebaseCollections.workers.doc(uid).update({'fcmToken': token});
      } catch (e) {
        if (kDebugMode) {
          print('Error updating FCM token: $e');
        }
      }
    }
  }

  static Stream<List<BannerModel>> getBanners({bool isHome = false}) {
    return FirebaseCollections.banners
        .where('type', isEqualTo: isHome ? 'home' : 'product')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return BannerModel.fromMap(data);
      }).toList();
    });
  }

  static Stream<List<ProductReviewModel>> fetchProductReviews(
      String productId) {
    return FirebaseCollections.products.doc(productId).snapshots().map((event) {
      final data = event.data() as Map<String, dynamic>?;
      if (data == null) {
        throw Exception("Product data not found");
      }

      final reviews = data['reviews'] as List<dynamic>?;

      return reviews
              ?.map(
                  (e) => ProductReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
    });
  }
}
