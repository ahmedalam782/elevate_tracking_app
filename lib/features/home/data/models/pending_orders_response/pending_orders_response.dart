import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_item_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_store_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_user_model.dart';
import 'package:json_annotation/json_annotation.dart';
part "pending_orders_response.g.dart";

@JsonSerializable()
class PendingOrdersResponse {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "metadata")
  final Metadata? metadata;
  @JsonKey(name: "orders")
  final List<PendingOrderData>? orders;

  PendingOrdersResponse({this.message, this.metadata, this.orders});

  factory PendingOrdersResponse.fromJson(Map<String, dynamic> json) =>
      _$PendingOrdersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PendingOrdersResponseToJson(this);
}

@JsonSerializable()
class Metadata {
  @JsonKey(name: "currentPage")
  final num? currentPage;
  @JsonKey(name: "totalPages")
  final num? totalPages;
  @JsonKey(name: "totalItems")
  final num? totalItems;
  @JsonKey(name: "limit")
  final num? limit;

  Metadata({this.currentPage, this.totalPages, this.totalItems, this.limit});

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}

@JsonSerializable()
class PendingOrderData {
  @JsonKey(name: "_id")
  final String? id;
  @JsonKey(name: "user")
  final PendingUser? user;
  @JsonKey(name: "orderItems")
  final List<PendingOrderItem>? orderItems;
  @JsonKey(name: "totalPrice")
  final num? totalPrice;
  @JsonKey(name: "paymentType")
  final String? paymentType;
  @JsonKey(name: "isPaid")
  final bool? isPaid;
  @JsonKey(name: "isDelivered")
  final bool? isDelivered;
  @JsonKey(name: "state")
  final String? state;
  @JsonKey(name: "createdAt")
  final DateTime? createdAt;
  @JsonKey(name: "updatedAt")
  final DateTime? updatedAt;
  @JsonKey(name: "orderNumber")
  final String? orderNumber;
  @JsonKey(name: "__v")
  final num? v;
  @JsonKey(name: "store")
  final PendingStore? store;
  @JsonKey(name: "shippingAddress")
  final ShippingAddress? shippingAddress;
  @JsonKey(name: "paidAt")
  final DateTime? paidAt;

  PendingOrderData({
    this.id,
    this.user,
    this.orderItems,
    this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.isDelivered,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    this.v,
    this.store,
    this.shippingAddress,
    this.paidAt,
  });

  factory PendingOrderData.fromJson(Map<String, dynamic> json) =>
      _$PendingOrderDataFromJson(json);

  Map<String, dynamic> toJson() => _$PendingOrderDataToJson(this);

  FirestoreOrderModel toFirestoreOrderModel() {
    return FirestoreOrderModel(
      id: id ?? "",
      paymentType: paymentType ?? "",
      state: state ?? "",
      totalPrice: totalPrice ?? 0,
    );
  }
}

@JsonSerializable()
class PendingOrderItem {
  @JsonKey(name: "product")
  final PendingProduct? product;
  @JsonKey(name: "price")
  final num? price;
  @JsonKey(name: "quantity")
  final num? quantity;
  @JsonKey(name: "_id")
  final String? id;

  PendingOrderItem({this.product, this.price, this.quantity, this.id});

  factory PendingOrderItem.fromJson(Map<String, dynamic> json) =>
      _$PendingOrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$PendingOrderItemToJson(this);

  FirestoreOrderItemModel toFirestoreOrderItemModel() {
    return FirestoreOrderItemModel(
      image: product?.imgCover ?? "",
      price: price ?? 0,
      quantity: quantity ?? 0,
      title: product?.title ?? "",
      id: id ?? "",
    );
  }
}

@JsonSerializable()
class PendingProduct {
  @JsonKey(name: "_id")
  final String? id;
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "slug")
  final String? slug;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "imgCover")
  final String? imgCover;
  @JsonKey(name: "images")
  final List<String>? images;
  @JsonKey(name: "price")
  final num? price;
  @JsonKey(name: "priceAfterDiscount")
  final num? priceAfterDiscount;
  @JsonKey(name: "quantity")
  final num? quantity;
  @JsonKey(name: "category")
  final String? category;
  @JsonKey(name: "occasion")
  final String? occasion;
  @JsonKey(name: "createdAt")
  final DateTime? createdAt;
  @JsonKey(name: "updatedAt")
  final DateTime? updatedAt;
  @JsonKey(name: "__v")
  final num? v;
  @JsonKey(name: "sold")
  final num? sold;
  @JsonKey(name: "isSuperAdmin")
  final bool? isSuperAdmin;
  @JsonKey(name: "rateAvg")
  final num? rateAvg;
  @JsonKey(name: "rateCount")
  final num? rateCount;

  PendingProduct({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.imgCover,
    this.images,
    this.price,
    this.priceAfterDiscount,
    this.quantity,
    this.category,
    this.occasion,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.sold,
    this.isSuperAdmin,
    this.rateAvg,
    this.rateCount,
  });

  factory PendingProduct.fromJson(Map<String, dynamic> json) =>
      _$PendingProductFromJson(json);

  Map<String, dynamic> toJson() => _$PendingProductToJson(this);
}

@JsonSerializable()
class ShippingAddress {
  @JsonKey(name: "street")
  final String? street;
  @JsonKey(name: "city")
  final String? city;
  @JsonKey(name: "phone")
  final String? phone;
  @JsonKey(name: "lat")
  final String? lat;
  @JsonKey(name: "long")
  final String? long;

  ShippingAddress({this.street, this.city, this.phone, this.lat, this.long});

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressToJson(this);
}

@JsonSerializable()
class PendingStore {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "image")
  final String? image;
  @JsonKey(name: "address")
  final String? address;
  @JsonKey(name: "phoneNumber")
  final String? phoneNumber;
  @JsonKey(name: "latLong")
  final String? latLong;

  PendingStore({
    this.name,
    this.image,
    this.address,
    this.phoneNumber,
    this.latLong,
  });

  factory PendingStore.fromJson(Map<String, dynamic> json) =>
      _$PendingStoreFromJson(json);

  Map<String, dynamic> toJson() => _$PendingStoreToJson(this);

  FirestoreOrderStoreModel toFirestoreOrderStoreModel() {
    List<num> latLngList =
        latLong?.split(",").map((value) {
          return num.parse(value.trim());
        }).toList() ??
        [];

    return FirestoreOrderStoreModel(
      address: address ?? "",
      image: image ?? "",
      name: name ?? "",
      lat: latLngList.isNotEmpty ? latLngList.first : 0,
      lng: latLngList.length > 1 ? latLngList[1] : 0,
      id: "",
      phoneNumber: phoneNumber ?? "",
    );
  }
}

@JsonSerializable()
class PendingUser {
  @JsonKey(name: "_id")
  final String? id;
  @JsonKey(name: "firstName")
  final String? firstName;
  @JsonKey(name: "lastName")
  final String? lastName;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "phone")
  final String? phone;
  @JsonKey(name: "photo")
  final String? photo;
  @JsonKey(name: "passwordChangedAt")
  final DateTime? passwordChangedAt;
  @JsonKey(name: "passwordResetCode")
  final String? passwordResetCode;
  @JsonKey(name: "passwordResetExpires")
  final DateTime? passwordResetExpires;
  @JsonKey(name: "resetCodeVerified")
  final bool? resetCodeVerified;

  PendingUser({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.phone,
    this.photo,
    this.passwordChangedAt,
    this.passwordResetCode,
    this.passwordResetExpires,
    this.resetCodeVerified,
  });

  factory PendingUser.fromJson(Map<String, dynamic> json) =>
      _$PendingUserFromJson(json);

  Map<String, dynamic> toJson() => _$PendingUserToJson(this);

  FirestoreOrderUserModel toFirestoreOrderUserModel({
    required num lat,
    required num lng,
  }) {
    return FirestoreOrderUserModel(
      id: id ?? "",
      lat: lat,
      lng: lng,
      firstName: firstName ?? "",
      lastName: lastName ?? "",
      phone: phone ?? "",
      photo: photo ?? "",
    );
  }
}

/// ======================================================================
/// 🔥🔥 DUMMY DATA FOR UI / TESTING / PAGINATION / SHIMMER
/// ======================================================================

final PendingOrdersResponse dummyPendingOrdersResponse = PendingOrdersResponse(
  message: "Orders fetched successfully",
  metadata: Metadata(currentPage: 1, totalPages: 1, totalItems: 2, limit: 10),
  orders: [
    PendingOrderData(
      id: "65f1a9c2e8a14b0012a10001",
      orderNumber: "ORD-2026-0001",
      paymentType: "Cash",
      isPaid: false,
      isDelivered: false,
      state: "Pending",
      totalPrice: 3450,
      createdAt: DateTime.parse("2026-03-01T10:00:00Z"),
      updatedAt: DateTime.parse("2026-03-01T10:00:00Z"),
      user: PendingUser(
        id: "u1001",
        firstName: "Mohamed",
        lastName: "Hassan",
        email: "mohamed@gmail.com",
        phone: "+201064354196",
        gender: "male",
      ),
      store: PendingStore(
        name: "Tech Store",
        image: "https://picsum.photos/200",
        address: "Nasr City, Cairo",
        phoneNumber: "+201122334455",
        latLong: "30.0561,31.3300",
      ),
      shippingAddress: ShippingAddress(
        street: "23 Abbas El Akkad",
        city: "Cairo",
        phone: "+201064354196",
        lat: "30.0561",
        long: "31.3300",
      ),
      orderItems: [
        PendingOrderItem(
          id: "oi1",
          quantity: 1,
          price: 3000,
          product: PendingProduct(
            id: "p1",
            title: "Samsung Galaxy S24",
            slug: "samsung-galaxy-s24",
            imgCover: "https://picsum.photos/300",
            price: 3000,
            priceAfterDiscount: 2800,
            quantity: 50,
            category: "Electronics",
            occasion: "Regular",
            rateAvg: 4.5,
            rateCount: 120,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ),
      ],
    ),
  ],
);
