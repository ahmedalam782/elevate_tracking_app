import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/orders_tap/domain/entities/orders_page_entity.dart';
import 'package:elevate_tracking_app/features/orders_tap/domain/repositories/orders_repository.dart';

class GetOrdersUseCase {
  final OrdersRepository repository;
  GetOrdersUseCase(this.repository);
  Future<Result<OrdersPageEntity>> call({required int page}) async {
    return await repository.getOrders(page: page);
  }
}
