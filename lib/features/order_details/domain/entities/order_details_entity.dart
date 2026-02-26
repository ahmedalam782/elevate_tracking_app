class OrderDetailsEntity {
  final String driverOrderId;
  final String orderNumber;
  final String orderState;
  final String createdAt;
  final StoreEntity store;
  final UserEntity user;
  final List<OrderItemEntity> orderItems;
  final double totalPrice;
  final String paymentType;

  OrderDetailsEntity({
    required this.driverOrderId,
    required this.orderNumber,
    required this.orderState,
    required this.createdAt,
    required this.store,
    required this.user,
    required this.orderItems,
    required this.totalPrice,
    required this.paymentType,
  });
}

class StoreEntity {
  final String name;
  final String image;
  final String address;
  final String phoneNumber;

  StoreEntity({
    required this.name,
    required this.image,
    required this.address,
    required this.phoneNumber,
  });
}

class UserEntity {
  final String firstName;
  final String lastName;
  final String phone;
  final String? photo;

  String get fullName => '$firstName $lastName';

  UserEntity({
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.photo,
  });
}

class OrderItemEntity {
  final String productId;
  final double price;
  final int quantity;

  OrderItemEntity({
    required this.productId,
    required this.price,
    required this.quantity,
  });
}