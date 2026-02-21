// TODO: domain HomeRepository

import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/home/data/models/accept_order_response/accept_order_response.dart';
import 'package:elevate_tracking_app/features/home/domain/entities/pending_orders_entity.dart';

abstract class HomeRepository {
  Future<Result<List<OrderEntity>>> getPendingOrders();
  Future<Result<AcceptOrderResponse>> acceptOrder(String id);
}
