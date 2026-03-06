import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/firebase_store_service.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_details_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_model.dart';
import 'package:elevate_tracking_app/core/helper/location/location_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';

part 'order_tracking_state.dart';

@injectable
class OrderTrackingCubit extends Cubit<OrderTrackingState> {
  OrderTrackingCubit({
    required this.fireStoreService,
    required this.locationService,
  }) : super(OrderTrackingInitial());
  final FirebaseStoreService fireStoreService;
  final LocationService locationService;

  StreamSubscription<LocationData>? _locationSubscription;
  String? _listenedDriverId;

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

  Future<void> startListeningToLocation({
    required String orderId,
    required String driverId,
  }) async {
    if (_locationSubscription != null && _listenedDriverId == driverId) {
      return; // Already listening for this driver
    }
    await stopListeningToLocation();
    _listenedDriverId = driverId;

    try {
      _locationSubscription = await locationService.getLocationAsStream((
        locationData,
      ) {
        if (locationData.latitude != null && locationData.longitude != null) {
          print("LAT ${locationData.latitude!}");
          print("LNG ${locationData.longitude!}");
          fireStoreService.updateOrderDriverLocation(
            orderId: orderId,
            driverId: driverId,
            lat: locationData.latitude!,
            lng: locationData.longitude!,
          );
        }
      });
    } catch (e) {
      // Handle or log location permission/service exceptions
    }
  }

  Future<void> stopListeningToLocation() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
    _listenedDriverId = null;
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
