import 'package:cloud_firestore/cloud_firestore.dart';

class ProductReviewModel {
  final String? comment;
  final DateTime? date;
  final String? uid;
  final String? id;
  final int? rating;

  ProductReviewModel({this.comment, this.uid, this.date, this.id, this.rating});

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewModel(
      comment: json['comment'] as String?,
      date:
          json['date'] is Timestamp
              ? (json['date'] as Timestamp).toDate()
              : json['date'] is String
              ? DateTime.tryParse(json['date'])
              : null,
      id: json['id'] as String?,
      uid: json['uid'] as String?,
      rating: json['rating'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
      'uid': uid,
      'date': date,
      'id': id,
      'rating': rating,
    };
  }
}
