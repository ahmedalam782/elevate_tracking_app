// ignore_for_file: public_member_api_docs, sort_constructors_first
// TODO: presentation HomeStates

import 'package:elevate_tracking_app/features/home/data/models/pending_orders_response/pending_orders_response.dart';
import 'package:elevate_tracking_app/shared/pagination/lodable_paginated_data.dart';

class HomeStates {
  LoadablePaginatedModel<PendingOrderData> pendingOrders;
  HomeStates({required this.pendingOrders});

  factory HomeStates.initial() {
    return HomeStates(pendingOrders: LoadablePaginatedModel.initial());
  }
  HomeStates copyWith({
    LoadablePaginatedModel<PendingOrderData>? pendingOrders,
  }) {
    return HomeStates(pendingOrders: pendingOrders ?? this.pendingOrders);
  }
}
