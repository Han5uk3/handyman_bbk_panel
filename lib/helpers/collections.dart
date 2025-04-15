import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCollections {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static CollectionReference users = firestore.collection(CollectionPath.users);
}

class CollectionPath {
  static const String users = 'users';
}
