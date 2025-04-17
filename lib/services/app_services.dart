import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handyman_bbk_panel/helpers/collections.dart';
import 'package:handyman_bbk_panel/helpers/hive_helpers.dart';
import 'package:handyman_bbk_panel/models/booking_data.dart';
import 'package:handyman_bbk_panel/models/products_model.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';

class AppServices {
  static final uid = HiveHelper.getUID();

  static Stream<UserData> getUserData() {
    return FirebaseCollections.users.doc(uid).snapshots().map((event) {
      return UserData.fromMap(event.data() as Map<String, dynamic>);
    });
  }

  static Stream<int> getWorkersCount() {
    return FirebaseCollections.users
        .where("userType", isEqualTo: "Worker")
        .snapshots()
        .map((event) => event.docs.length);
  }

  static Stream<int> getScheduleUrgentCount({bool? isUrgent}) {
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
    return FirebaseCollections.users
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

  static Future<UserData?> getUserById(String uid) async {
    try {
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

  static Stream<List<BookingModel>> getBookingsStream({
    bool? isUrgent,
    String? status,
  }) {
    Query query = FirebaseCollections.bookings;
    if (isUrgent != null) {
      query = query.where('isUrgent', isEqualTo: isUrgent);
    }
    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }
    // query = query.orderBy('date', descending: true);
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return BookingModel.fromMap(data);
      }).toList();
    });
  }

  static Stream<List<BookingModel>> getBookingsByWorkerId() {
    return FirebaseCollections.bookings
        .where('workerData.uid', isEqualTo: uid).where('status', isEqualTo: "P")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return BookingModel.fromMap(data);
      }).toList();
    });
  }
}
