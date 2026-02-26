import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/order_details/domain/repositories/order_details_repository.dart';
import 'package:injectable/injectable.dart';
import '../entities/order_details_entity.dart';

@lazySingleton
class GetOrderDetailsUseCase {
  final OrderDetailsRepo repo;

  GetOrderDetailsUseCase(this.repo);

  Future<Result<OrderDetailsEntity>> call(String driverOrderId) =>
      repo.getOrderDetails(driverOrderId);
}