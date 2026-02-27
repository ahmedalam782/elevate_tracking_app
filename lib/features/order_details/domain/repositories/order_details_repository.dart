// TODO: domain Order_detailsRepository
import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import '../entities/order_details_entity.dart';

abstract class OrderDetailsRepo {
  Future<Result<OrderDetailsEntity>> getOrderDetails(String driverOrderId);
}