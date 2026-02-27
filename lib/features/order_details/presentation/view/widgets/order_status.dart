import 'dart:ui';

import 'package:elevate_tracking_app/core/theme/app_colors.dart';

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
        return 'Delivered';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.accepted:
      case OrderStatus.arrivedAtPickup:
        return AppColorsStatus.statusAccepted;
      case OrderStatus.picked:
        return AppColorsStatus.statusPicked;
      case OrderStatus.outForDelivery:
        return AppColorsStatus.statusOutForDelivery;
      case OrderStatus.arrived:
        return AppColorsStatus.statusArrived;
      case OrderStatus.delivered:
        return AppColorsStatus.statusDelivered;
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
