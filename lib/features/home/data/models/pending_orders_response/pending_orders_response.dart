import 'package:elevate_tracking_app/features/home/domain/entities/pending_orders_entity.dart';
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

  PendingOrdersEntity toPendingOrderEntity() {
    return PendingOrdersEntity(
      id: id ?? "",
      storeAvatar: store?.image ?? "",
      storeName: store?.name ?? "",
      storeAddress: store?.address ?? "",
      userAvatar: user?.photo ?? "",
      userName: user?.firstName ?? "",
      userAddress: "DUMMY ADDRESS",
      totalPrice: totalPrice?.toDouble() ?? 0.0,
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
}
