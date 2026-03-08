import 'package:elevate_tracking_app/core/config/base_state/base_state.dart';
import 'package:elevate_tracking_app/features/order_details/domain/use_cases/get_order_details_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'order_details_events.dart';
import 'order_details_states.dart';

@lazySingleton
class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final GetOrderDetailsUseCase getOrderDetailsUseCase;

  OrderDetailsCubit(this.getOrderDetailsUseCase) : super(OrderDetailsState());

  Future<void> doInit(OrderDetailsEvents event) async {
    if (event is GetOrderDetailsEvent) {
      await _getOrderDetails(driverOrderId: event.driverOrderId);
    }
  }

  Future<void> _getOrderDetails({required String driverOrderId}) async {
    emit(state.copyWith(orderDetails: const BaseState.loading()));

    final result = await getOrderDetailsUseCase(driverOrderId);

    result.when(
      success: (value) => emit(state.copyWith(
        orderDetails: BaseState.success(value),
      )),
      error: (exception) => emit(state.copyWith(
        orderDetails: BaseState.error(exception),
        message: exception?.toString() ?? "Something went wrong",
      )),
    );
  }
}