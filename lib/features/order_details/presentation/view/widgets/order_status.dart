import 'package:flutter/material.dart';

enum OrderStatus {
  accepted,
  arrivedAtPickup,
  picked,
  outForDelivery,
  arrived,
  delivered,
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.accepted:
        return 'Accepted';
      case OrderStatus.arrivedAtPickup:
        return 'Accepted';
      case OrderStatus.picked:
        return 'Picked';
      case OrderStatus.outForDelivery:
        return 'Out for delivery';
      case OrderStatus.arrived:
        return 'Arrived';
      case OrderStatus.delivered:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.accepted:
      case OrderStatus.arrivedAtPickup:
        return const Color(0xFFE91E8C);
      case OrderStatus.picked:
        return const Color(0xFF2196F3);
      case OrderStatus.outForDelivery:
        return const Color(0xFFFF9800);
      case OrderStatus.arrived:
        return const Color(0xFF9C27B0);
      case OrderStatus.delivered:
        return const Color(0xFF4CAF50);
    }
  }

  int get stepIndex {
    switch (this) {
      case OrderStatus.accepted:
        return 0;
      case OrderStatus.arrivedAtPickup:
        return 1;
      case OrderStatus.picked:
        return 2;
      case OrderStatus.outForDelivery:
        return 3;
      case OrderStatus.arrived:
        return 4;
      case OrderStatus.delivered:
        return 5;
    }
  }

  String get actionButtonLabel {
    switch (this) {
      case OrderStatus.accepted:
      case OrderStatus.arrivedAtPickup:
        return 'Arrived at Pickup point';
      case OrderStatus.picked:
        return 'Start deliver';
      case OrderStatus.outForDelivery:
        return 'Arrived to the user';
      case OrderStatus.arrived:
        return 'Delivered to the user';
      case OrderStatus.delivered:
        return 'Delivered to the user';
    }
  }

  bool get isButtonEnabled => this != OrderStatus.delivered;
}