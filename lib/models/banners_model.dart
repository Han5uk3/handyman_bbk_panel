import 'package:cloud_firestore/cloud_firestore.dart';

class Banner {
  final String id;
  final String image;
  final String type; // 'home' or 'product'
  final String? category; // 'electrical', 'plumbing', or null for home banner
  final bool isActive;
  final DateTime? createdAt;

  Banner({
    required this.id,
    required this.image,
    required this.type,
    this.category,
    required this.isActive,
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

  factory Banner.fromMap(Map<String, dynamic> map) {
    return Banner(
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
