import 'package:elevate_tracking_app/core/config/base_state/base_state.dart';
import 'package:elevate_tracking_app/core/errors/handle_errors/handle_errors.dart';
import 'package:elevate_tracking_app/features/orders_tap/domain/use_cases/get_orders_use_case.dart';
import 'package:elevate_tracking_app/features/orders_tap/presentation/view_model/cubit/orders_events.dart';
import 'package:elevate_tracking_app/features/orders_tap/presentation/view_model/cubit/orders_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OrdersCubit extends Cubit<OrdersState> {
  final GetOrdersUseCase getOrdersUseCase;
  OrdersCubit(this.getOrdersUseCase) : super(OrdersState());

  Future<void> doInit(OrdersEvents event) async {
    if (event is GetOrdersEvent) {
      await _getOrders(page: event.page);
    }
  }

  Future<void> _getOrders({required int page}) async {
    emit(state.copyWith(orders: const BaseState.loading()));
    final result = await getOrdersUseCase.call(page: page);
    result.when(
      success: (value) {
        emit(state.copyWith(orders: BaseState.success(value), page: page));
      },
      error: (failure) {
        emit(
          state.copyWith(
            orders: BaseState.error(failure),
            message: handleError(failure),
          ),
        );
      },
    );
  }
}
