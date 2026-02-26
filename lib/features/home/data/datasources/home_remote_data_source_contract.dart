// TODO: data HomeRemoteDataSourceContract

import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/home/data/models/accept_order_response/accept_order_response.dart';
import 'package:elevate_tracking_app/features/home/data/models/pending_orders_response/pending_orders_response.dart';

abstract class HomeRemoteDataSourceContract {
  Future<Result<PendingOrdersResponse>> getAllPendingOrders();
  Future<Result<AcceptOrderResponse>> acceptOrder(String id);
}
