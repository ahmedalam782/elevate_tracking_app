import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreOrderUserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final num lat;
  final num lng;
  final String photo;

  const FirestoreOrderUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.lat,
    required this.lng,
    required this.photo,
  });

  FirestoreOrderUserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phone,
    num? lat,
    num? lng,
    String? photo,
  }) {
    return FirestoreOrderUserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      photo: photo ?? this.photo,
    );
  }

  FirestoreUserLocationModel get location =>
      FirestoreUserLocationModel(lat: lat, lng: lng);

  factory FirestoreOrderUserModel.fromJson(Map<String, dynamic> json) {
    return FirestoreOrderUserModel(
      id: (json['id'] ?? '').toString(),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      lat: _parseCoordinate(json['lat']),
      lng: _parseCoordinate(json['lng']),
      photo: (json['photo'] ?? '').toString(),
    );
  }

  factory FirestoreOrderUserModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    if (data == null) {
      throw StateError('User document ${document.id} has no data.');
    }

    return FirestoreOrderUserModel.fromJson({
      ...data,
      'id': data['id'] ?? document.id,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'lat': lat,
      'lng': lng,
      'photo': photo,
    };
  }

  static num _parseCoordinate(dynamic value) {
    if (value is num) {
      return value;
    }

    if (value is String) {
      return num.tryParse(value) ?? 0;
    }

    return 0;
  }
}

class FirestoreUserLocationModel {
  final num lat;
  final num lng;

  const FirestoreUserLocationModel({
    required this.lat,
    required this.lng,
  });

  FirestoreUserLocationModel copyWith({
    num? lat,
    num? lng,
  }) {
    return FirestoreUserLocationModel(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  factory FirestoreUserLocationModel.fromJson(Map<String, dynamic> json) {
    return FirestoreUserLocationModel(
      lat: FirestoreOrderUserModel._parseCoordinate(json['lat']),
      lng: FirestoreOrderUserModel._parseCoordinate(json['lng']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}
