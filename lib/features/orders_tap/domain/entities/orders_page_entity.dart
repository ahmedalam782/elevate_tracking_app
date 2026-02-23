class OrdersPageEntity {
  final List<OrderEntity> orders;
  final int totalPages;
  OrdersPageEntity({required this.orders, required this.totalPages});
}

class OrderEntity {
  final String driver;
  final OrderDetailsEntity orderDetails;

  final StoreEntity store;

  OrderEntity({
    required this.driver,
    required this.orderDetails,
    required this.store,
  });
}

class OrderDetailsEntity {
  final String orderNumber;
  final int totalPrice;
  final String paymentType;
  final bool isPaid;
  final bool isDelivered;
  final String state;
  final OrderUserEntity user;

  OrderDetailsEntity({
    required this.orderNumber,
    required this.totalPrice,
    required this.paymentType,
    required this.isPaid,
    required this.isDelivered,
    required this.state, required this.user,
  });
}

class StoreEntity {
  final String name;
  final String image;
  final String address;

  StoreEntity({required this.name, required this.image, required this.address});
}

class OrderUserEntity {
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String phone;
  final String photo;

  OrderUserEntity({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.phone,
    required this.photo,
  });
}
