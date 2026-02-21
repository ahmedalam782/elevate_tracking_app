// ignore_for_file: public_member_api_docs, sort_constructors_first
// TODO: presentation HomeStates

import 'package:elevate_tracking_app/features/home/domain/entities/pending_orders_entity.dart';
import 'package:elevate_tracking_app/shared/pagination/lodable_paginated_data.dart';

class HomeStates {
  LoadablePaginatedModel<OrderEntity> pendingOrders;
  HomeStates({required this.pendingOrders});

  factory HomeStates.initial() {
    return HomeStates(pendingOrders: LoadablePaginatedModel.initial());
  }
  HomeStates copyWith({LoadablePaginatedModel<OrderEntity>? pendingOrders}) {
    return HomeStates(pendingOrders: pendingOrders ?? this.pendingOrders);
  }
}
