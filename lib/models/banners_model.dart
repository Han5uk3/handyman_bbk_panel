import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  final String? id;
  final String? image;
  final String? type;
  final String? category;
  final bool? isActive;
  final DateTime? createdAt;

  BannerModel({
    this.id,
    this.image,
    this.type,
    this.category,
    this.isActive,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'type': type,
      'category': category,
      'isActive': isActive,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      id: map['id'] ?? '',
      image: map['image'] ?? '',
      type: map['type'] ?? '',
      category: map['category'],
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is DateTime
              ? map['createdAt']
              : (map['createdAt'] is Timestamp
                  ? map['createdAt'].toDate()
                  : DateTime.fromMillisecondsSinceEpoch(map['createdAt'])))
          : null,
    );
  }
}
