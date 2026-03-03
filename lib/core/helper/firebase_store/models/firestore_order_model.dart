import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreOrderModel {
  final String id;
  final String paymentType;
  final String state;
  final num totalPrice;

  const FirestoreOrderModel({
    required this.id,
    required this.paymentType,
    required this.state,
    required this.totalPrice,
  });

  FirestoreOrderModel copyWith({
    String? id,
    String? paymentType,
    String? state,
    num? totalPrice,
  }) {
    return FirestoreOrderModel(
      id: id ?? this.id,
      paymentType: paymentType ?? this.paymentType,
      state: state ?? this.state,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  factory FirestoreOrderModel.fromJson(Map<String, dynamic> json) {
    return FirestoreOrderModel(
      id: (json['id'] ?? '').toString(),
      paymentType: (json['paymentType'] ?? '').toString(),
      state: (json['state'] ?? '').toString(),
      totalPrice: _parseTotalPrice(json['totalPrice']),
    );
  }

  factory FirestoreOrderModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    if (data == null) {
      throw StateError('Order document ${document.id} has no data.');
    }

    return FirestoreOrderModel.fromJson({
      ...data,
      'id': data['id'] ?? document.id,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paymentType': paymentType,
      'state': state,
      'totalPrice': totalPrice,
    };
  }

  static num _parseTotalPrice(dynamic value) {
    if (value is num) {
      return value;
    }

    if (value is String) {
      return num.tryParse(value) ?? 0;
    }

    return 0;
  }
}
