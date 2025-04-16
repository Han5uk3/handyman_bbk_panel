import 'package:handyman_bbk_panel/helpers/collections.dart';
import 'package:handyman_bbk_panel/helpers/hive_helpers.dart';
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

  static Stream<List<ProductsModel>> getProductsList() {
    return FirebaseCollections.products.snapshots().map((event) => event.docs
        .map((e) => ProductsModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }
}
