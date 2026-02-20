// TODO: presentation HomeCubit

import 'package:elevate_tracking_app/features/home/domain/entities/pending_orders_entity.dart';
import 'package:elevate_tracking_app/features/home/domain/use_cases/get_pending_orders_use_case.dart';
import 'package:elevate_tracking_app/features/home/presentation/view_model/cubit/home_events.dart';
import 'package:elevate_tracking_app/features/home/presentation/view_model/cubit/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeCubit extends Cubit<HomeStates> {
  final GetPendingOrdersUseCase getPendingOrdersUseCase;

  HomeCubit({required this.getPendingOrdersUseCase})
    : super(HomeStates.initial());

  void doIntent(HomeEvents event) {
    switch (event) {
      case GetPendingOrdersEvent():
        return _getPendingOrders();
    }
  }

  void _getPendingOrders() async {
    emit(
      state.copyWith(
        pendingOrders: state.pendingOrders.copyWith(
          isInitialLoading: true,
          items: PendingOrdersEntity.getDummyData(),
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
}
