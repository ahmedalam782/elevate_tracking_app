import 'package:elevate_tracking_app/core/config/base_state/base_state.dart';
import 'package:elevate_tracking_app/features/orders_tap/domain/entities/orders_page_entity.dart';
import 'package:equatable/equatable.dart';

class OrdersState extends Equatable {
  final String message;
  final BaseState<OrdersPageEntity> orders;
  final int canceledOrdersCount;
  final int completedOrdersCount;
  final int page;

  const OrdersState({
    this.message = "",
    this.orders = const BaseState.initial(),
    this.canceledOrdersCount = 0,
    this.completedOrdersCount = 0,
    this.page = 1,
  });

  OrdersState copyWith({
    String? message,
    BaseState<OrdersPageEntity>? orders,
    int? canceledOrdersCount,
    int? completedOrdersCount,
    int? page,
  }) {
    return OrdersState(
      message: message ?? this.message,
      orders: orders ?? this.orders,
      canceledOrdersCount: canceledOrdersCount ?? this.canceledOrdersCount,
      completedOrdersCount: completedOrdersCount ?? this.completedOrdersCount,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [
    message,
    orders,
    canceledOrdersCount,
    completedOrdersCount,
    page,
  ];
}
