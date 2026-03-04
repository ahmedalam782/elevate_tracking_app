import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_driver_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_item_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_store_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_user_model.dart';

class FirestoreOrderDetailsModel {
  final FirestoreOrderModel order;
  final List<FirestoreOrderDriverModel> drivers;
  final List<FirestoreOrderUserModel> users;
  final List<FirestoreOrderStoreModel> stores;
  final List<FirestoreOrderItemModel> items;

  const FirestoreOrderDetailsModel({
    required this.order,
    required this.drivers,
    required this.users,
    required this.stores,
    required this.items,
  });

  FirestoreOrderDriverModel? get driver =>
      drivers.isEmpty ? null : drivers.first;

  FirestoreOrderUserModel? get user => users.isEmpty ? null : users.first;

  FirestoreOrderStoreModel? get store => stores.isEmpty ? null : stores.first;
}
