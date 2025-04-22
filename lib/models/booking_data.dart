import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handyman_bbk_panel/models/userdata_models.dart';

class BookingModel {
  final String? id;
  final String? audioUrl;
  final String? issue;
  final String? status;
  final String? uid;
  final double? taxFee;
  final String? time;
  final String? imageUrl;
  final String? imageAfterWork;
  final bool? isUrgent;
  final Location? location;
  final DateTime? date;
  final double? serviceFee;
  final double? totalFee;
  final bool? isWorkerAccept;
  final DateTime? createdAt;
  final DateTime? completedDateTime;
  final String? name;
  final bool? isBookingcancel;
  final UserData? workerData;

  BookingModel({
    this.id,
    this.audioUrl,
    this.issue,
    this.status,
    this.uid,
    this.taxFee,
    this.time,
    this.imageUrl,
    this.imageAfterWork,
    this.isUrgent,
    this.location,
    this.date,
    this.serviceFee,
    this.totalFee,
    this.isWorkerAccept,
    this.createdAt,
    this.name,
    this.isBookingcancel,
    this.completedDateTime,
    this.workerData,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] ?? '',
      audioUrl: map['audioUrl'],
      issue: map['issue'] ?? '',
      status: map['status'] ?? '',
      uid: map['uid'] ?? '',
      taxFee: (map['taxFee'] ?? 0).toDouble(),
      time: map['time'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      imageAfterWork: map['afterImage'] ?? '',
      isUrgent: map['isUrgent'] ?? false,
      location: Location.fromJson(map['location'] ?? {}),
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      serviceFee: (map['serviceFee'] ?? 0).toDouble(),
      totalFee: (map['totalFee'] ?? 0).toDouble(),
      isWorkerAccept: map['isWorkerAccept'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      completedDateTime: (map['completedDateTime'] as Timestamp).toDate(),
      name: map['name'] ?? '',
      isBookingcancel: map['isBookingcancel'] ?? false,
      workerData: map['workerData'] != null
          ? UserData.fromMap(map['workerData'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'imageUrl': imageUrl,
      'imageAfterWork': imageAfterWork,
      'audioUrl': audioUrl,
      'isUrgent': isUrgent,
      'date': date?.toIso8601String(),
      'time': time,
      'issue': issue,
      'isBookingcancel': isBookingcancel,
      'status': status,
      'isWorkerAccept': isWorkerAccept,
      'location': location?.toJson(),
      'serviceFee': serviceFee,
      'taxFee': taxFee,
      'totalFee': totalFee,
    };
  }

  String get statusText {
    switch (status) {
      case 'C':
        return 'Completed';
      case 'P':
        return 'Pending';
      case 'R':
        return 'Canceled';
      default:
        return 'Unknown';
    }
  }
}

class Location {
  final String address;
  final String subLocation;
  final double latitude;
  final double longitude;

  Location({
    required this.address,
    required this.subLocation,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      address: json['address'] as String,
      subLocation: json['subLocation'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'subLocation': subLocation,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
