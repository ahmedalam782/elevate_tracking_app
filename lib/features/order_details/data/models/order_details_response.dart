import 'package:json_annotation/json_annotation.dart';

part 'order_details_response.g.dart';

@JsonSerializable()
class OrderDetailsResponse {
  @JsonKey(name: '_id')
  final String id;
  final OrderInDetailsResponse order;
  final StoreDetailsResponse store;
  final String createdAt;

  OrderDetailsResponse({
    required this.id,
    required this.order,
    required this.store,
    required this.createdAt,
  });

  factory OrderDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailsResponseToJson(this);
}

@JsonSerializable()
class OrderInDetailsResponse {
  @JsonKey(name: '_id')
  final String id;
  final UserDetailsResponse user;
  final List<OrderItemResponse> orderItems;
  final double totalPrice;
  final String paymentType;
  final bool isPaid;
  final bool isDelivered;
  final String state;
  final String orderNumber;
  final String createdAt;

  OrderInDetailsResponse({
    required this.id,
    required this.user,
    required this.orderItems,
    required this.totalPrice,
    required this.paymentType,
    required this.isPaid,
    required this.isDelivered,
    required this.state,
    required this.orderNumber,
    required this.createdAt,
  });

  factory OrderInDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderInDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderInDetailsResponseToJson(this);
}

@JsonSerializable()
class UserDetailsResponse {
  @JsonKey(name: '_id')
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final String? photo;

  UserDetailsResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.photo,
  });

  factory UserDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsResponseToJson(this);
}

@JsonSerializable()
class OrderItemResponse {
  final ProductResponse product;
  final double price;
  final int quantity;

  OrderItemResponse({
    required this.product,
    required this.price,
    required this.quantity,
  });

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemResponseToJson(this);
}

@JsonSerializable()
class ProductResponse {
  @JsonKey(name: '_id')
  final String id;
  final double price;

  ProductResponse({required this.id, required this.price});

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductResponseToJson(this);
}

@JsonSerializable()
class StoreDetailsResponse {
  final String name;
  final String image;
  final String address;
  final String phoneNumber;
  final String latLong;

  StoreDetailsResponse({
    required this.name,
    required this.image,
    required this.address,
    required this.phoneNumber,
    required this.latLong,
  });

  factory StoreDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$StoreDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoreDetailsResponseToJson(this);
}