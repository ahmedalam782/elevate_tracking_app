

import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/order_details/api/api_client/order_details_api_client.dart';
import 'package:elevate_tracking_app/features/order_details/data/models/order_details_mapper.dart';
import 'package:elevate_tracking_app/features/order_details/domain/entities/order_details_entity.dart';
import 'package:elevate_tracking_app/features/order_details/domain/repositories/order_details_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrderDetailsRepo)
class OrderDetailsRepoImpl implements OrderDetailsRepo {
  final OrderDetailsApiClient apiClient;

  OrderDetailsRepoImpl(this.apiClient);

  @override
  Future<Result<OrderDetailsEntity>> getOrderDetails(
      String driverOrderId) async {
    try {
      final response = await apiClient.getOrderDetails(driverOrderId);
      return Success(data: response.toEntity());
    } catch (e) {
      return Error(exception: e is Exception ? e : Exception(e.toString()));
    }
  }
}