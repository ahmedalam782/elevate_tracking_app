import 'package:equatable/equatable.dart';

class OrdersPageEntity extends Equatable {
  final List<OrderEntity> orders;
  final int totalPages;
  const OrdersPageEntity({required this.orders, required this.totalPages});

  @override
  List<Object?> get props => [orders, totalPages];
}

class OrderEntity extends Equatable {
  final String driver;
  final OrderDetailsEntity orderDetails;

  final StoreEntity store;

  const OrderEntity({
    required this.driver,
    required this.orderDetails,
    required this.store,
  });

  @override
  List<Object?> get props => [driver, orderDetails, store];
}

class OrderDetailsEntity extends Equatable {
  final String orderNumber;
  final int totalPrice;
  final String paymentType;
  final bool isPaid;
  final bool isDelivered;
  final String state;
  final OrderUserEntity user;

  const OrderDetailsEntity({
    required this.orderNumber,
    required this.totalPrice,
    required this.paymentType,
    required this.isPaid,
    required this.isDelivered,
    required this.state,
    required this.user,
  });

  @override
  List<Object?> get props => [
    orderNumber,
    totalPrice,
    paymentType,
    isPaid,
    isDelivered,
    state,
    user,
  ];
}

class StoreEntity extends Equatable {
  final String name;
  final String image;
  final String address;

  const StoreEntity({
    required this.name,
    required this.image,
    required this.address,
  });

  @override
  List<Object?> get props => [name, image, address];
}

class OrderUserEntity extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String phone;
  final String photo;

  const OrderUserEntity({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.phone,
    required this.photo,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, gender, phone, photo];
}
