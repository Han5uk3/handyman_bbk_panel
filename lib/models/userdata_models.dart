class UserData {
  final String? email;
  final double? latitude;
  final String? location;
  final String? loginType;
  final double? longitude;
  final String? name;
  final String? phoneNumber;
  final String? uid;

  // New fields
  final String? title;
  final String? userType;
  final String? gender;
  final String? dateOfBirth;
  final String? address;
  final String? service;
  final String? experience;
  final bool? hasProfileImage;
  final bool? hasIdProof;

  UserData({
    this.email,
    this.latitude,
    this.location,
    this.loginType,
    this.longitude,
    this.name,
    this.phoneNumber,
    this.uid,
    this.title,
    this.userType,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.service,
    this.experience,
    this.hasProfileImage,
    this.hasIdProof,
  });

  factory UserData.fromMap(Map map) {
    return UserData(
      email: map['email'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      location: map['location'] ?? '',
      loginType: map['loginType'] ?? '',
      longitude: (map['longitude'] ?? 0).toDouble(),
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'],
      uid: map['uid'] ?? '',
      title: map['title'] ?? '',
      userType: map['userType'] ?? '',
      gender: map['gender'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      address: map['address'] ?? '',
      service: map['service'] ?? '',
      experience: map['experience'] ?? '',
      hasProfileImage: map['hasProfileImage'] ?? false,
      hasIdProof: map['hasIdProof'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'latitude': latitude,
      'location': location,
      'loginType': loginType,
      'longitude': longitude,
      'name': name,
      'phoneNumber': phoneNumber,
      'uid': uid,
      'title': title,
      'gender': gender,
      'userType': userType,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'service': service,
      'experience': experience,
      'hasProfileImage': hasProfileImage,
      'hasIdProof': hasIdProof,
    };
  }
}