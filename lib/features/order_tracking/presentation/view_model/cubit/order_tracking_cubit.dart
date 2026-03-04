import 'package:bloc/bloc.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/firebase_store_service.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_details_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_model.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'order_tracking_state.dart';

@injectable
class OrderTrackingCubit extends Cubit<OrderTrackingState> {
  OrderTrackingCubit({required this.fireStoreService})
    : super(OrderTrackingInitial());
  final FirebaseStoreService fireStoreService;

  Stream<FirestoreOrderModel?> listenToOrder(String id) {
    return fireStoreService.listenToOrder(id);
  }

  Stream<FirestoreOrderDetailsModel?> listenToOrderWithDetails(String id) {
    return fireStoreService.listenToOrderWithDetails(id);
  }

  Future<void> updateOrderState({
    required String orderId,
    required String state,
    bool withTimestamp = true,
  }) {
    return fireStoreService.updateOrderState(
      orderId: orderId,
      state: state,
      withTimestamp: withTimestamp,
    );
  }
}
