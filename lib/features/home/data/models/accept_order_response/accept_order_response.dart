import 'package:json_annotation/json_annotation.dart';

part "accept_order_response.g.dart";

@JsonSerializable()
class AcceptOrderResponse {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "orders")
  final Orders? orders;

  AcceptOrderResponse({this.message, this.orders});

  factory AcceptOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$AcceptOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AcceptOrderResponseToJson(this);
}

@JsonSerializable()
class Orders {
  @JsonKey(name: "_id")
  final String? id;
  @JsonKey(name: "user")
  final String? user;
  @JsonKey(name: "orderItems")
  final List<AcceptOrder>? AcceptOrders;
  @JsonKey(name: "totalPrice")
  final int? totalPrice;
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
  final int? v;

  Orders({
    this.id,
    this.user,
    this.AcceptOrders,
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

  factory Orders.fromJson(Map<String, dynamic> json) => _$OrdersFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersToJson(this);
}

@JsonSerializable()
class AcceptOrder {
  @JsonKey(name: "product")
  final String? product;
  @JsonKey(name: "price")
  final int? price;
  @JsonKey(name: "quantity")
  final int? quantity;
  @JsonKey(name: "_id")
  final String? id;

  AcceptOrder({this.product, this.price, this.quantity, this.id});

  factory AcceptOrder.fromJson(Map<String, dynamic> json) =>
      _$AcceptOrderFromJson(json);

  Map<String, dynamic> toJson() => _$AcceptOrderToJson(this);
}
