import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_details_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_driver_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_item_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_store_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_user_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirebaseStoreService {
  static const String _ordersCollectionName = 'orders';
  static const String _driversCollectionName = 'drivers';
  static const String _orderItemsCollectionName = 'orderItems';
  static const String _userCollectionName = 'user';
  static const String _storeCollectionName = 'store';

  final FirebaseFirestore _firestore;

  FirebaseStoreService([FirebaseFirestore? firestore])
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _ordersCollection =>
      _firestore.collection(_ordersCollectionName);

  CollectionReference<Map<String, dynamic>> _driversCollection(
    String orderId,
  ) => _ordersCollection.doc(orderId).collection(_driversCollectionName);

  CollectionReference<Map<String, dynamic>> _orderItemsCollection(
    String orderId,
  ) => _ordersCollection.doc(orderId).collection(_orderItemsCollectionName);

  CollectionReference<Map<String, dynamic>> _userCollection(String orderId) =>
      _ordersCollection.doc(orderId).collection(_userCollectionName);

  CollectionReference<Map<String, dynamic>> _storeCollection(String orderId) =>
      _ordersCollection.doc(orderId).collection(_storeCollectionName);

  // ==================== Orders Collection ====================
  Future<void> createOrder(FirestoreOrderModel order) async {
    final document = _ordersCollection.doc(order.id);
    final snapshot = await document.get();

    if (snapshot.exists) {
      throw StateError('Order with id ${order.id} already exists.');
    }

    await document.set({
      ...order.toJson(),
      // Use Firestore server UTC time when order is accepted.
      'acceptedAt': FieldValue.serverTimestamp(),
      'arrivedAtPickUpAt': null,
      'deliveringAt': null,
      'deliveredAt': null,
      'completedAt': null,
    });
  }

  Future<void> upsertOrder(FirestoreOrderModel order) async {
    final document = _ordersCollection.doc(order.id);
    final snapshot = await document.get();

    if (snapshot.exists) {
      await document.set({
        'id': order.id,
        'paymentType': order.paymentType,
        'state': order.state,
        'totalPrice': order.totalPrice,
      }, SetOptions(merge: true));
      return;
    }

    await document.set({
      ...order.toJson(),
      'acceptedAt': FieldValue.serverTimestamp(),
      'arrivedAtPickUpAt': order.arrivedAtPickUpAt,
      'deliveringAt': order.deliveringAt,
      'deliveredAt': order.deliveredAt,
      'completedAt': order.completedAt,
    });
  }

  Future<FirestoreOrderModel?> getOrderById(String orderId) async {
    final snapshot = await _ordersCollection.doc(orderId).get();
    if (!snapshot.exists) {
      return null;
    }

    return FirestoreOrderModel.fromDocument(snapshot);
  }

  Future<List<FirestoreOrderModel>> getAllOrders() async {
    final snapshot = await _ordersCollection.get();
    return snapshot.docs.map(FirestoreOrderModel.fromDocument).toList();
  }

  Future<bool> orderExists(String orderId) async {
    final snapshot = await _ordersCollection.doc(orderId).get();
    return snapshot.exists;
  }

  Future<void> updateOrder(FirestoreOrderModel order) async {
    await _ordersCollection.doc(order.id).update({
      'id': order.id,
      'paymentType': order.paymentType,
      'state': order.state,
      'totalPrice': order.totalPrice,
    });
  }

  Future<void> updateOrderState({
    required String orderId,
    required String state,
    bool withTimestamp = true,
  }) async {
    await _ordersCollection.doc(orderId).update({
      'state': state,
      if (withTimestamp) ..._stateTimestampPatch(state),
    });
  }

  Future<void> deleteOrder(String orderId) async {
    await _ordersCollection.doc(orderId).delete();
  }

  Stream<FirestoreOrderModel?> listenToOrder(String orderId) {
    return _ordersCollection.doc(orderId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }

      return FirestoreOrderModel.fromDocument(snapshot);
    });
  }

  Stream<FirestoreOrderDetailsModel?> listenToOrderWithDetails(String orderId) {
    final controller = StreamController<FirestoreOrderDetailsModel?>();

    FirestoreOrderModel? order;
    List<FirestoreOrderDriverModel> drivers = const [];
    List<FirestoreOrderUserModel> users = const [];
    List<FirestoreOrderStoreModel> stores = const [];
    List<FirestoreOrderItemModel> items = const [];

    late final StreamSubscription<FirestoreOrderModel?> orderSubscription;
    late final StreamSubscription<List<FirestoreOrderDriverModel>>
    driverSubscription;
    late final StreamSubscription<List<FirestoreOrderUserModel>>
    userSubscription;
    late final StreamSubscription<List<FirestoreOrderStoreModel>>
    storeSubscription;
    late final StreamSubscription<List<FirestoreOrderItemModel>>
    itemSubscription;

    void emitCombined() {
      if (controller.isClosed) {
        return;
      }

      final currentOrder = order;
      if (currentOrder == null) {
        controller.add(null);
        return;
      }

      controller.add(
        FirestoreOrderDetailsModel(
          order: currentOrder,
          drivers: List.unmodifiable(drivers),
          users: List.unmodifiable(users),
          stores: List.unmodifiable(stores),
          items: List.unmodifiable(items),
        ),
      );
    }

    controller.onListen = () {
      orderSubscription = listenToOrder(orderId).listen((value) {
        order = value;
        emitCombined();
      }, onError: controller.addError);

      driverSubscription = listenToOrderDrivers(orderId).listen((value) {
        drivers = value;
        emitCombined();
      }, onError: controller.addError);

      userSubscription = listenToOrderUsers(orderId).listen((value) {
        users = value;
        emitCombined();
      }, onError: controller.addError);

      storeSubscription = listenToOrderStores(orderId).listen((value) {
        stores = value;
        emitCombined();
      }, onError: controller.addError);

      itemSubscription = listenToOrderItems(orderId).listen((value) {
        items = value;
        emitCombined();
      }, onError: controller.addError);
    };

    controller.onCancel = () async {
      await orderSubscription.cancel();
      await driverSubscription.cancel();
      await userSubscription.cancel();
      await storeSubscription.cancel();
      await itemSubscription.cancel();
    };

    return controller.stream;
  }

  Stream<List<FirestoreOrderModel>> listenToOrders() {
    return _ordersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map(FirestoreOrderModel.fromDocument).toList();
    });
  }

  Stream<String?> listenToOrderState(String orderId) {
    return _ordersCollection.doc(orderId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }

      final data = snapshot.data();
      return data?['state']?.toString();
    });
  }

  Map<String, dynamic> _stateTimestampPatch(String state) {
    switch (state) {
      case 'arrivedAtPickup':
        return {'arrivedAtPickUpAt': Timestamp.now()};
      case 'delivering':
        return {'deliveringAt': Timestamp.now()};
      case 'deliveredToTheUser':
        return {'deliveredAt': Timestamp.now()};
      case 'completed':
        return {'completedAt': Timestamp.now()};
      default:
        return const {};
    }
  }

  // ==================== Drivers Subcollection ====================
  // Path: orders/{orderId}/drivers/{driverId}
  Future<void> createOrderDriver({
    required String orderId,
    required FirestoreOrderDriverModel driver,
  }) async {
    final document = _driversCollection(orderId).doc(driver.id);
    final snapshot = await document.get();

    if (snapshot.exists) {
      throw StateError(
        'Driver with id ${driver.id} already exists in order $orderId.',
      );
    }

    await document.set(driver.toJson());
  }

  Future<void> upsertOrderDriver({
    required String orderId,
    required FirestoreOrderDriverModel driver,
  }) async {
    await _driversCollection(orderId).doc(driver.id).set(driver.toJson());
  }

  Future<FirestoreOrderDriverModel?> getOrderDriverById({
    required String orderId,
    required String driverId,
  }) async {
    final snapshot = await _driversCollection(orderId).doc(driverId).get();
    if (!snapshot.exists) {
      return null;
    }

    return FirestoreOrderDriverModel.fromDocument(snapshot);
  }

  Future<List<FirestoreOrderDriverModel>> getOrderDrivers(
    String orderId,
  ) async {
    final snapshot = await _driversCollection(orderId).get();
    return snapshot.docs.map(FirestoreOrderDriverModel.fromDocument).toList();
  }

  Future<bool> orderDriverExists({
    required String orderId,
    required String driverId,
  }) async {
    final snapshot = await _driversCollection(orderId).doc(driverId).get();
    return snapshot.exists;
  }

  Future<void> updateOrderDriver({
    required String orderId,
    required FirestoreOrderDriverModel driver,
  }) async {
    await _driversCollection(orderId).doc(driver.id).update(driver.toJson());
  }

  Future<void> updateOrderDriverLocation({
    required String orderId,
    required String driverId,
    required num lat,
    required num lng,
  }) async {
    await _driversCollection(
      orderId,
    ).doc(driverId).update({'lat': lat, 'lng': lng});
  }

  Future<void> deleteOrderDriver({
    required String orderId,
    required String driverId,
  }) async {
    await _driversCollection(orderId).doc(driverId).delete();
  }

  Stream<FirestoreOrderDriverModel?> listenToOrderDriver({
    required String orderId,
    required String driverId,
  }) {
    return _driversCollection(orderId).doc(driverId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists) {
        return null;
      }

      return FirestoreOrderDriverModel.fromDocument(snapshot);
    });
  }

  Stream<List<FirestoreOrderDriverModel>> listenToOrderDrivers(String orderId) {
    return _driversCollection(orderId).snapshots().map((snapshot) {
      return snapshot.docs.map(FirestoreOrderDriverModel.fromDocument).toList();
    });
  }

  Stream<FirestoreDriverLocationModel?> listenToOrderDriverLocation({
    required String orderId,
    required String driverId,
  }) {
    return _driversCollection(orderId).doc(driverId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists) {
        return null;
      }

      final data = snapshot.data();
      if (data == null) {
        return null;
      }

      return FirestoreDriverLocationModel.fromJson(data);
    });
  }

  // ==================== User Subcollection ====================
  // Path: orders/{orderId}/user/{userId}
  Future<void> createOrderUser({
    required String orderId,
    required FirestoreOrderUserModel user,
  }) async {
    final document = _userCollection(orderId).doc(user.id);
    final snapshot = await document.get();

    if (snapshot.exists) {
      throw StateError(
        'User with id ${user.id} already exists in order $orderId.',
      );
    }

    await document.set(user.toJson());
  }

  Future<void> upsertOrderUser({
    required String orderId,
    required FirestoreOrderUserModel user,
  }) async {
    await _userCollection(orderId).doc(user.id).set(user.toJson());
  }

  Future<FirestoreOrderUserModel?> getOrderUserById({
    required String orderId,
    required String userId,
  }) async {
    final snapshot = await _userCollection(orderId).doc(userId).get();
    if (!snapshot.exists) {
      return null;
    }

    return FirestoreOrderUserModel.fromDocument(snapshot);
  }

  Future<List<FirestoreOrderUserModel>> getOrderUsers(String orderId) async {
    final snapshot = await _userCollection(orderId).get();
    return snapshot.docs.map(FirestoreOrderUserModel.fromDocument).toList();
  }

  Future<bool> orderUserExists({
    required String orderId,
    required String userId,
  }) async {
    final snapshot = await _userCollection(orderId).doc(userId).get();
    return snapshot.exists;
  }

  Future<void> updateOrderUser({
    required String orderId,
    required FirestoreOrderUserModel user,
  }) async {
    await _userCollection(orderId).doc(user.id).update(user.toJson());
  }

  Future<void> updateOrderUserLocation({
    required String orderId,
    required String userId,
    required num lat,
    required num lng,
  }) async {
    await _userCollection(orderId).doc(userId).update({'lat': lat, 'lng': lng});
  }

  Future<void> deleteOrderUser({
    required String orderId,
    required String userId,
  }) async {
    await _userCollection(orderId).doc(userId).delete();
  }

  Stream<FirestoreOrderUserModel?> listenToOrderUser({
    required String orderId,
    required String userId,
  }) {
    return _userCollection(orderId).doc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }

      return FirestoreOrderUserModel.fromDocument(snapshot);
    });
  }

  Stream<List<FirestoreOrderUserModel>> listenToOrderUsers(String orderId) {
    return _userCollection(orderId).snapshots().map((snapshot) {
      return snapshot.docs.map(FirestoreOrderUserModel.fromDocument).toList();
    });
  }

  Stream<FirestoreUserLocationModel?> listenToOrderUserLocation({
    required String orderId,
    required String userId,
  }) {
    return _userCollection(orderId).doc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }

      final data = snapshot.data();
      if (data == null) {
        return null;
      }

      return FirestoreUserLocationModel.fromJson(data);
    });
  }

  // ==================== Store Subcollection ====================
  // Path: orders/{orderId}/store/{storeId}
  Future<FirestoreOrderStoreModel> createOrderStore({
    required String orderId,
    required FirestoreOrderStoreModel store,
  }) async {
    final document = _storeCollection(orderId).doc();
    final storeWithId = store.copyWith(id: document.id);

    await document.set(store.toJson());
    return storeWithId;
  }

  Future<FirestoreOrderStoreModel> upsertOrderStore({
    required String orderId,
    required FirestoreOrderStoreModel store,
  }) async {
    final storeId = (store.id == null || store.id!.isEmpty)
        ? _storeCollection(orderId).doc().id
        : store.id!;
    final storeWithId = store.copyWith(id: storeId);

    await _storeCollection(orderId).doc(storeId).set(storeWithId.toJson());
    return storeWithId;
  }

  Future<FirestoreOrderStoreModel?> getOrderStoreById({
    required String orderId,
    required String storeId,
  }) async {
    final snapshot = await _storeCollection(orderId).doc(storeId).get();
    if (!snapshot.exists) {
      return null;
    }

    return FirestoreOrderStoreModel.fromDocument(snapshot);
  }

  Future<List<FirestoreOrderStoreModel>> getOrderStores(String orderId) async {
    final snapshot = await _storeCollection(orderId).get();
    return snapshot.docs.map(FirestoreOrderStoreModel.fromDocument).toList();
  }

  Future<bool> orderStoreExists({
    required String orderId,
    required String storeId,
  }) async {
    final snapshot = await _storeCollection(orderId).doc(storeId).get();
    return snapshot.exists;
  }

  Future<void> updateOrderStore({
    required String orderId,
    required FirestoreOrderStoreModel store,
  }) async {
    final storeId = store.id;
    if (storeId == null || storeId.isEmpty) {
      throw ArgumentError('Store id is required for update.');
    }

    await _storeCollection(orderId).doc(storeId).update(store.toJson());
  }

  Future<void> updateOrderStoreLocation({
    required String orderId,
    required String storeId,
    required num lat,
    required num lng,
  }) async {
    await _storeCollection(
      orderId,
    ).doc(storeId).update({'lat': lat, 'lng': lng});
  }

  Future<void> deleteOrderStore({
    required String orderId,
    required String storeId,
  }) async {
    await _storeCollection(orderId).doc(storeId).delete();
  }

  Stream<FirestoreOrderStoreModel?> listenToOrderStore({
    required String orderId,
    required String storeId,
  }) {
    return _storeCollection(orderId).doc(storeId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }

      return FirestoreOrderStoreModel.fromDocument(snapshot);
    });
  }

  Stream<List<FirestoreOrderStoreModel>> listenToOrderStores(String orderId) {
    return _storeCollection(orderId).snapshots().map((snapshot) {
      return snapshot.docs.map(FirestoreOrderStoreModel.fromDocument).toList();
    });
  }

  Stream<FirestoreStoreLocationModel?> listenToOrderStoreLocation({
    required String orderId,
    required String storeId,
  }) {
    return _storeCollection(orderId).doc(storeId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }

      final data = snapshot.data();
      if (data == null) {
        return null;
      }

      return FirestoreStoreLocationModel.fromJson(data);
    });
  }

  // ==================== Order Items Subcollection ====================
  // Path: orders/{orderId}/orderItems/{itemId}
  Future<FirestoreOrderItemModel> createOrderItem({
    required String orderId,
    required FirestoreOrderItemModel item,
  }) async {
    final document = _orderItemsCollection(orderId).doc();
    final itemWithId = item.copyWith(id: document.id);

    await document.set(item.toJson());
    return itemWithId;
  }

  Future<FirestoreOrderItemModel> upsertOrderItem({
    required String orderId,
    required FirestoreOrderItemModel item,
  }) async {
    final itemId = (item.id == null || item.id!.isEmpty)
        ? _orderItemsCollection(orderId).doc().id
        : item.id!;
    final itemWithId = item.copyWith(id: itemId);

    await _orderItemsCollection(orderId).doc(itemId).set(itemWithId.toJson());
    return itemWithId;
  }

  Future<FirestoreOrderItemModel?> getOrderItemById({
    required String orderId,
    required String itemId,
  }) async {
    final snapshot = await _orderItemsCollection(orderId).doc(itemId).get();
    if (!snapshot.exists) {
      return null;
    }

    return FirestoreOrderItemModel.fromDocument(snapshot);
  }

  Future<List<FirestoreOrderItemModel>> getOrderItems(String orderId) async {
    final snapshot = await _orderItemsCollection(orderId).get();
    return snapshot.docs.map(FirestoreOrderItemModel.fromDocument).toList();
  }

  Future<bool> orderItemExists({
    required String orderId,
    required String itemId,
  }) async {
    final snapshot = await _orderItemsCollection(orderId).doc(itemId).get();
    return snapshot.exists;
  }

  Future<void> updateOrderItem({
    required String orderId,
    required FirestoreOrderItemModel item,
  }) async {
    final itemId = item.id;
    if (itemId == null || itemId.isEmpty) {
      throw ArgumentError('Order item id is required for update.');
    }

    await _orderItemsCollection(orderId).doc(itemId).update(item.toJson());
  }

  Future<void> deleteOrderItem({
    required String orderId,
    required String itemId,
  }) async {
    await _orderItemsCollection(orderId).doc(itemId).delete();
  }

  Stream<FirestoreOrderItemModel?> listenToOrderItem({
    required String orderId,
    required String itemId,
  }) {
    return _orderItemsCollection(orderId).doc(itemId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists) {
        return null;
      }

      return FirestoreOrderItemModel.fromDocument(snapshot);
    });
  }

  Stream<List<FirestoreOrderItemModel>> listenToOrderItems(String orderId) {
    return _orderItemsCollection(orderId).snapshots().map((snapshot) {
      return snapshot.docs.map(FirestoreOrderItemModel.fromDocument).toList();
    });
  }
}
