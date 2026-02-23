import 'package:elevate_tracking_app/core/config/base_state/base_state.dart';
import 'package:elevate_tracking_app/core/errors/handle_errors/handle_errors.dart';
import 'package:elevate_tracking_app/features/orders_tap/domain/entities/orders_page_entity.dart';
import 'package:elevate_tracking_app/features/orders_tap/domain/use_cases/get_orders_use_case.dart';
import 'package:elevate_tracking_app/features/orders_tap/presentation/view_model/cubit/orders_events.dart';
import 'package:elevate_tracking_app/features/orders_tap/presentation/view_model/cubit/orders_states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OrdersCubit extends Cubit<OrdersState> {
  final GetOrdersUseCase getOrdersUseCase;
  OrdersCubit(this.getOrdersUseCase) : super(OrdersState());

  Future<void> doInit(OrdersEvents event) async {
    if (event is GetOrdersEvent) {
      await _getOrders(page: event.page);
    } else if (event is GetMoreOrders) {
      await _getMoreOrders(page: event.page);
    }
  }

  Future<void> _getOrders({int? page}) async {
    emit(state.copyWith(orders: const BaseState.loading()));
    final result = await getOrdersUseCase(page: page ?? state.page);
    result.when(
      success: (value) {
        _getCompletedAndCanceledOrders(value!);
        emit(
          state.copyWith(
            orders: BaseState.success(value),
            page: page ?? state.page,
          ),
        );
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

  Future<void> _getMoreOrders({required int page}) async {
    if (state.orders.state == StateType.moreLoading) return;
    emit(
      state.copyWith(
        orders: BaseState(
          state: StateType.moreLoading,
          data: state.orders.data,
        ),
      ),
    );
    final result = await getOrdersUseCase(page: page);
    result.when(
      success: (value) {
        value!.orders.insertAll(0, state.orders.data?.orders ?? []);
        _getCompletedAndCanceledOrders(value);
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

  Future<void> _getCompletedAndCanceledOrders(
    OrdersPageEntity ordersPageEntity,
  ) async {
    (int completedCount, int canceledCount) result = await compute(
      completedOrdersCount,
      ordersPageEntity,
    );
    emit(
      state.copyWith(
        completedOrdersCount: result.$1,
        canceledOrdersCount: result.$2,
      ),
    );
  }
}

(int, int) completedOrdersCount(OrdersPageEntity ordersPageEntity) {
  if (ordersPageEntity.orders.isEmpty) return (0, 0);
  int completedCount = 0;
  int canceledCount = 0;
  for (int i = 0; i < ordersPageEntity.orders.length; i++) {
    if (ordersPageEntity.orders[i].orderDetails.state == "completed") {
      completedCount++;
    } else if (ordersPageEntity.orders[i].orderDetails.state == "canceled") {
      canceledCount++;
    }
  }
  return (completedCount, canceledCount);
}
