import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handyman_bbk_panel/models/products_model.dart';

class OrdersModel {
  String? orderId;
  String? uid;
  List<ProductsModel>? orderDetails;
  DateTime? orderDate;
  double? totalPrice;
  final bool? isPackaged;

  OrdersModel({
    this.orderId,
    this.uid,
    this.orderDetails,
    this.orderDate,
    this.totalPrice,
    this.isPackaged,
  });

  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    return OrdersModel(
      orderId: json['id'],
      uid: json['uid'],
      orderDate: json['orderDate'] != null
          ? (json['orderDate'] as Timestamp).toDate()
          : null,
      isPackaged: json['isPackaged'] ?? false,
      totalPrice:
          (json['totalPrice'] != null) ? json['totalPrice'].toDouble() : null,
      orderDetails: json['orderedProducts'] != null
          ? (json['orderedProducts'] as List)
              .map((item) => ProductsModel.fromMap(item))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': orderId,
      'uid': uid,
      'orderDate': orderDate,
      'totalPrice': totalPrice,
      'orderedProducts': orderDetails?.map((e) => e.toMap()).toList(),
      'isPackaged': isPackaged
    };
  }
}
