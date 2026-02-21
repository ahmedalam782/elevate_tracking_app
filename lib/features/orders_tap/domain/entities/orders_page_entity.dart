class OrdersPageEntity {
  final List<OrderEntity?>? orders;
  final int? totalPages;
  OrdersPageEntity({this.orders, this.totalPages});
}

class OrderEntity {
  final String? driver;
  final OrderDetailsEntity? orderDetails;

  final StoreEntity? store;

  OrderEntity({
    this.driver,
    this.orderDetails,
    this.store,
  });
}

class OrderDetailsEntity {
  final String? orderNumber;
  final int? totalPrice;
  final String? paymentType;
  final bool? isPaid;
  final bool? isDelivered;
  final String? state;

  OrderDetailsEntity({
    this.orderNumber,
    this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.isDelivered,
    this.state,
  });
}

class StoreEntity {
  final String? name;
  final String? image;
  final String? address;

  StoreEntity({this.name, this.image, this.address});
}

class UserEntity {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? gender;
  final String? phone;
  final String? photo;

  UserEntity({this.firstName, this.lastName, this.email, this.gender, this.phone, this.photo});
}