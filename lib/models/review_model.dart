import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String bookingId;
  final String uid;
  final String workerId;
  final double rating;
  final String review;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.bookingId,
    required this.uid,
    required this.workerId,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  factory ReviewModel.fromDocument(Map<String, dynamic> doc, String docId) {
    return ReviewModel(
      id: docId,
      bookingId: doc['bookingId'] ?? '',
      uid: doc['uid'] ?? '',
      workerId: doc['workerId'] ?? '',
      rating: (doc['rating'] ?? 0).toDouble(),
      review: doc['review'] ?? '',
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
    );
  }
}
