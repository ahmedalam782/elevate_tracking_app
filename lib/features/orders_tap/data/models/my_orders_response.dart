import 'package:json_annotation/json_annotation.dart';

part 'my_orders_response.g.dart';

@JsonSerializable()
class OrdersResponse {
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'metadata')
  final Metadata? metadata;
  @JsonKey(name: 'orders')
  final List<Orders?>? orders;

  OrdersResponse({
    this.message,
    this.metadata,
    this.orders,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) => _$OrdersResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OrdersResponseToJson(this);
}

@JsonSerializable()
class Orders {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'driver')
  final String? driver;
  @JsonKey(name: 'order')
  final Order? order;
  @JsonKey(name: '__v')
  final int? v;
  @JsonKey(name: 'createdAt')
  final String? createdAt;
  @JsonKey(name: 'updatedAt')
  final String? updatedAt;
  @JsonKey(name: 'store')
  final Store? store;

  Orders({
    this.id,
    this.driver,
    this.order,
    this.v,
    this.createdAt,
    this.updatedAt,
    this.store,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => _$OrdersFromJson(json);
  Map<String, dynamic> toJson() => _$OrdersToJson(this);
}

@JsonSerializable()
class Store {
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'image')
  final String? image;
  @JsonKey(name: 'address')
  final String? address;
  @JsonKey(name: 'phoneNumber')
  final String? phoneNumber;
  @JsonKey(name: 'latLong')
  final String? latLong;

  Store({
    this.name,
    this.image,
    this.address,
    this.phoneNumber,
    this.latLong,
  });

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);
}

@JsonSerializable()
class Order {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'user')
  final User? user;
  @JsonKey(name: 'orderItems')
  final List<OrderItems?>? orderItems;
  @JsonKey(name: 'totalPrice')
  final int? totalPrice;
  @JsonKey(name: 'paymentType')
  final String? paymentType;
  @JsonKey(name: 'isPaid')
  final bool? isPaid;
  @JsonKey(name: 'isDelivered')
  final bool? isDelivered;
  @JsonKey(name: 'state')
  final String? state;
  @JsonKey(name: 'createdAt')
  final String? createdAt;
  @JsonKey(name: 'updatedAt')
  final String? updatedAt;
  @JsonKey(name: 'orderNumber')
  final String? orderNumber;
  @JsonKey(name: '__v')
  final int? v;

  Order({
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
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

@JsonSerializable()
class OrderItems {
  @JsonKey(name: 'product')
  final Product? product;
  @JsonKey(name: 'price')
  final int? price;
  @JsonKey(name: 'quantity')
  final int? quantity;
  @JsonKey(name: '_id')
  final String? id;

  OrderItems({
    this.product,
    this.price,
    this.quantity,
    this.id,
  });

  factory OrderItems.fromJson(Map<String, dynamic> json) => _$OrderItemsFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemsToJson(this);
}

@JsonSerializable()
class Product {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'price')
  final int? price;

  Product({
    this.id,
    this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable()
class User {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'firstName')
  final String? firstName;
  @JsonKey(name: 'lastName')
  final String? lastName;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'gender')
  final String? gender;
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'photo')
  final String? photo;
  @JsonKey(name: 'passwordChangedAt')
  final String? passwordChangedAt;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.phone,
    this.photo,
    this.passwordChangedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Metadata {
  @JsonKey(name: 'currentPage')
  final int? currentPage;
  @JsonKey(name: 'totalPages')
  final int? totalPages;
  @JsonKey(name: 'totalItems')
  final int? totalItems;
  @JsonKey(name: 'limit')
  final int? limit;

  Metadata({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.limit,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => _$MetadataFromJson(json);
  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}