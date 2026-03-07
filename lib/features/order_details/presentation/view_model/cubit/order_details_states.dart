import 'package:elevate_tracking_app/core/config/base_state/base_state.dart';
import 'package:elevate_tracking_app/features/order_details/domain/entities/order_details_entity.dart';

class OrderDetailsState {
  final String message;
  final BaseState<OrderDetailsEntity> orderDetails;

  OrderDetailsState({
    this.message = "",
    this.orderDetails = const BaseState.initial(),
  });

  OrderDetailsState copyWith({
    String? message,
    BaseState<OrderDetailsEntity>? orderDetails,
  }) {
    return OrderDetailsState(
      message: message ?? this.message,
      orderDetails: orderDetails ?? this.orderDetails,
    );
  }
}