class UserData {
  final String? email;
  final double? latitude;
  final String? location;
  final String? loginType;
  final double? longitude;
  final String? name;
  final String? phoneNumber;
  final String? uid;
  final bool? isAdmin;
  final bool? isUserOnline;
  final bool? isVerified;
  final String? profilePic;
  final String? idProof;
  final String? title;
  final String? userType;
  final String? gender;
  final String? dateOfBirth;
  final String? address;
  final String? service;
  final String? experience;

  UserData({
    this.email,
    this.latitude,
    this.location,
    this.loginType,
    this.longitude,
    this.name,
    this.isAdmin,
    this.isVerified,
    this.isUserOnline,
    this.phoneNumber,
    this.uid,
    this.profilePic,
    this.idProof,
    this.title,
    this.userType,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.service,
    this.experience,
  });

  factory UserData.fromMap(Map map) {
    return UserData(
      email: map['email'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      location: map['location'] ?? '',
      loginType: map['loginType'] ?? '',
      longitude: (map['longitude'] ?? 0).toDouble(),
      name: map['name'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
      isUserOnline: map['isUserOnline'] ?? false,
      isVerified: map['isVerified'] ?? false,
      phoneNumber: map['phoneNumber'],
      uid: map['uid'] ?? '',
      title: map['title'] ?? '',
      userType: map['userType'] ?? '',
      gender: map['gender'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      address: map['address'] ?? '',
      service: map['service'] ?? '',
      profilePic: map['profilePic'] ?? '',
      idProof: map['idProof'] ?? '',
      experience: map['experience'] ?? '',
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
      'isAdmin': isAdmin,
      'isVerified': isVerified,
      'isUserOnline': isUserOnline,
      'title': title,
      'gender': gender,
      'userType': userType,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'service': service,
      'experience': experience,
    };
  }
}
