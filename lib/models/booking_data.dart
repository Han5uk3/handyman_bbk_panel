class BookingData {
  final String? id;
  final String? uid;
  final String? name;
  final String? imageUrl;
  final String? audioUrl;
  final bool? isUrgent;
  final DateTime? date;
  final String? time;
  final String? issue;
  final String? status;
  final bool? isWorkerAssign;
  final bool? isBookingcancel;
  final Location? location;
  final double? serviceFee;
  final double? taxFee;
  final double? totalFee;

  BookingData({
    this.id,
    this.uid,
    this.name,
    this.imageUrl,
    this.audioUrl,
    this.isUrgent,
    this.date,
    this.time,
    this.issue,
    this.isBookingcancel,
    this.status,
    this.location,
    this.isWorkerAssign,
    this.serviceFee,
    this.taxFee,
    this.totalFee,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      id: json['id'] as String?,
      uid: json['uid'] as String?,
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      isUrgent: json['isUrgent'] as bool?,
      date:
          json['date'] != null
              ? (json['date'] is String
                  ? DateTime.parse(json['date'])
                  : json['date'] as DateTime)
              : null,
      time: json['time'] as String?,
      issue: json['issue'] as String?,
      status: json['status'] as String?,
      isBookingcancel: json['isBookingcancel'] as bool?,
      location: Location.fromJson(json['location']),
      isWorkerAssign: json['isWorkerAssign'] as bool?,
      serviceFee: (json['serviceFee'] as num).toDouble(),
      taxFee: (json['taxFee'] as num).toDouble(),
      totalFee: (json['totalFee'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'isUrgent': isUrgent,
      'date': date?.toIso8601String(),
      'time': time,
      'issue': issue,
      'isBookingcancel': isBookingcancel,
      'status': status,
      'isWorkerAssign': isWorkerAssign,
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
