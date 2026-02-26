import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/orders_tap/data/models/my_orders_response.dart';

abstract class OrdersRemoteDataSourceContract {
  Future<Result<OrdersResponse>> getOrders({required int page});
}