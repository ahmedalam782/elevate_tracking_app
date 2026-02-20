import 'package:elevate_tracking_app/core/config/base_state/base_state.dart';
import 'package:elevate_tracking_app/features/orders_tap/domain/entities/orders_page_entity.dart';

class OrdersState {
  final String message;
  final BaseState<OrdersPageEntity> orders;
  final int canceledOrdersCount;
  final int completedOrdersCount;
  final int page;
  final int totalPages;

  OrdersState({
    required this.message,
    required this.orders,
    required this.canceledOrdersCount,
    required this.completedOrdersCount,
    required this.page,
    required this.totalPages,
  });
}
