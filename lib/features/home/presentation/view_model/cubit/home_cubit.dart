// TODO: presentation HomeCubit

import 'package:elevate_tracking_app/core/shared/widgets/loading_flower_widget.dart';
import 'package:elevate_tracking_app/features/home/domain/entities/pending_orders_entity.dart';
import 'package:elevate_tracking_app/features/home/domain/use_cases/accept_order_use_case.dart';
import 'package:elevate_tracking_app/features/home/domain/use_cases/get_pending_orders_use_case.dart';
import 'package:elevate_tracking_app/features/home/presentation/view_model/cubit/home_events.dart';
import 'package:elevate_tracking_app/features/home/presentation/view_model/cubit/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeCubit extends Cubit<HomeStates> {
  final GetPendingOrdersUseCase getPendingOrdersUseCase;
  final AcceptOrderUsercase acceptOrderUsercase;

  HomeCubit({
    required this.getPendingOrdersUseCase,
    required this.acceptOrderUsercase,
  }) : super(HomeStates.initial());

  Future<void> doIntent(HomeEvents event) async {
    switch (event) {
      case GetPendingOrdersEvent():
        return _getPendingOrders();
      case RejectOrderEvent():
        rejectOrder(event.index);
      case AcceptOrderEvent():
        _acceptOrder(event.index);
    }
  }

  Future<void> _getPendingOrders() async {
    emit(
      state.copyWith(
        pendingOrders: state.pendingOrders.copyWith(
          isInitialLoading: true,
          items: OrderEntity.getDummyData(),
        ),
      ),
    );
    final result = await getPendingOrdersUseCase.call();
    result.when(
      success: (data) {
        emit(
          state.copyWith(
            pendingOrders: state.pendingOrders.copyWith(
              isInitialLoading: false,
              items: data,
            ),
          ),
        );
      },
      error: (exception) {
        emit(
          state.copyWith(
            pendingOrders: state.pendingOrders.copyWith(
              isInitialLoading: false,
              items: [],
              error: exception.toString(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _acceptOrder(int index) async {
    showOverLayLoading();
    final result = await acceptOrderUsercase.call(
      state.pendingOrders.items[index].id,
    );
    result.when(
      success: (data) {
        hideOverlayLoading();
        emit(
          state.copyWith(
            pendingOrders: state.pendingOrders.copyWith(
              items: List<OrderEntity>.from(state.pendingOrders.items)
                ..removeAt(index),
            ),
          ),
        );
      },
      error: (exception) {
        hideOverlayLoading();
      },
    );
  }

  void rejectOrder(int index) {
    final data = List<OrderEntity>.from(state.pendingOrders.items);
    data.removeAt(index);
    emit(
      state.copyWith(pendingOrders: state.pendingOrders.copyWith(items: data)),
    );
  }
}
