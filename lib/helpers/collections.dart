import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCollections {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static CollectionReference users = firestore.collection(CollectionPath.users);
  static CollectionReference bookings =
      firestore.collection(CollectionPath.bookings);
  static CollectionReference products =
      firestore.collection(CollectionPath.products);
  static CollectionReference reviews =
      firestore.collection(CollectionPath.reviews);
}

class CollectionPath {
  static const String users = 'users';
  static const String bookings = 'bookings';
  static const String products = 'products';
  static const String reviews = 'reviews';
}
