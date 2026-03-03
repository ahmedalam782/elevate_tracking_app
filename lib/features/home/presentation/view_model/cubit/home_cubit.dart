// TODO: presentation HomeCubit

import 'package:elevate_tracking_app/core/helper/firebase_store/firebase_store_service.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_driver_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_item_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_store_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_user_model.dart';
import 'package:elevate_tracking_app/core/helper/location/location_exceptions.dart';
import 'package:elevate_tracking_app/core/helper/location/location_helper.dart';
import 'package:elevate_tracking_app/core/routes/app_router.dart';
import 'package:elevate_tracking_app/core/routes/routes.dart';
import 'package:elevate_tracking_app/core/shared/widgets/loading_flower_widget.dart';
import 'package:elevate_tracking_app/features/home/data/models/pending_orders_response/pending_orders_response.dart';
import 'package:elevate_tracking_app/features/home/domain/use_cases/accept_order_use_case.dart';
import 'package:elevate_tracking_app/features/home/domain/use_cases/get_pending_orders_use_case.dart';
import 'package:elevate_tracking_app/features/home/presentation/view_model/cubit/home_events.dart';
import 'package:elevate_tracking_app/features/home/presentation/view_model/cubit/home_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeCubit extends Cubit<HomeStates> {
  final GetPendingOrdersUseCase getPendingOrdersUseCase;
  final AcceptOrderUsercase acceptOrderUsercase;
  final FirebaseStoreService fireStoreService;
  final LocationService locationService;

  HomeCubit({
    required this.getPendingOrdersUseCase,
    required this.acceptOrderUsercase,
    required this.fireStoreService,
    required this.locationService,
  }) : super(HomeStates.initial());

  Future<void> doIntent(
    HomeEvents event, {
    required BuildContext context,
  }) async {
    switch (event) {
      case GetPendingOrdersEvent():
        return _getPendingOrders();
      case RejectOrderEvent():
        rejectOrder(event.index);
      case AcceptOrderEvent():
        return _acceptOrder(event.index, context!);
    }
  }

  Future<void> _getPendingOrders() async {
    emit(
      state.copyWith(
        pendingOrders: state.pendingOrders.copyWith(
          isInitialLoading: true,
          // TODO CREATUE PENDING ORDER DUMMY DATA
          items: dummyPendingOrdersResponse.orders,
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

  Future<void> _acceptOrder(int index, BuildContext context) async {
    // storeDataInFirestore(state.pendingOrders.items[index]);

    // return;
    if (index < 0 || index >= state.pendingOrders.items.length) return;
    try {
      showOverLayLoading();

      final location = await locationService.getCurrentLocation();
      storeDataInFirestore(
        state.pendingOrders.items[index],
        lat: location.latitude,
        lng: location.longitude,
      );
      hideOverlayLoading();
      context.push(
        Routes.orderTrackingScreen,
        extra: state.pendingOrders.items[index].id ?? "",
      );
      return;
      final result = await acceptOrderUsercase.call(
        state.pendingOrders.items[index].id!,
      );
      result.when(
        success: (data) async {
          emit(
            state.copyWith(
              pendingOrders: state.pendingOrders.copyWith(
                items: List<PendingOrderData>.from(state.pendingOrders.items)
                  ..removeAt(index),
              ),
            ),
          );
          storeDataInFirestore(
            state.pendingOrders.items[index],
            lat: location.latitude,
            lng: location.longitude,
          );
        },
        error: (exception) {
          hideOverlayLoading();
        },
      );
    } on LocationException catch (e) {
      hideOverlayLoading();

      print(e);
    }
  }

  Future<void> storeDataInFirestore(
    PendingOrderData orderData, {
    required num lat,
    required num lng,
  }) async {
    await fireStoreService.createOrder(
      FirestoreOrderModel(
        id: orderData.id ?? "",
        paymentType: orderData.paymentType ?? "",
        state: "inProgress",
        totalPrice: orderData.totalPrice ?? 0,
      ),
    );
    await Future.wait([
      storeUserDatainFirestore(orderData),
      storeStoreDataInFireStore(orderData),
      storeDriverDataInFirestore(orderData, lat: lat, lng: lng),
      storeStoreOrderItInFireStore(orderData),
    ]);
  }

  Future<void> storeStoreDataInFireStore(PendingOrderData orderData) async {
    await fireStoreService.createOrderStore(
      store: orderData.store!.toFirestoreOrderStoreModel(),

      orderId: orderData.id ?? "",
    );
  }

  Future<void> storeStoreOrderItInFireStore(PendingOrderData orderData) async {
    for (PendingOrderItem item in orderData.orderItems ?? []) {
      await fireStoreService.createOrderItem(
        item: item.toFirestoreOrderItemModel(),

        orderId: orderData.id ?? "",
      );
    }
  }

  Future<void> storeUserDatainFirestore(PendingOrderData orderData) async {
    await fireStoreService.createOrderUser(
      user: orderData.user!.toFirestoreOrderUserModel(
        lat: num.parse(orderData.shippingAddress!.lat!),
        lng: num.parse(orderData.shippingAddress!.long!),
      ),

      orderId: orderData.id ?? "",
    );
  }

  Future<void> storeDriverDataInFirestore(
    PendingOrderData orderData, {
    required num lat,
    required num lng,
  }) async {
    await fireStoreService.createOrderDriver(
      driver: FirestoreOrderDriverModel(
        firstName: "Ahmed",
        id: "6993725ee364ef6140587e4a",
        lastName: "aswani",
        lat: lat,
        lng: lng,
        phoneNumber: "+201010700888",
        photo:
            "https://flower.elevateegy.com/uploads/18b10028-5922-4a34-8121-6b2386f2d5b5-Screenshot",
      ),

      orderId: orderData.id ?? "",
    );
  }

  void rejectOrder(int index) {
    final data = List<PendingOrderData>.from(state.pendingOrders.items);
    if (index < 0 || index >= data.length) return;

    data.removeAt(index);
    emit(
      state.copyWith(pendingOrders: state.pendingOrders.copyWith(items: data)),
    );
  }
}
