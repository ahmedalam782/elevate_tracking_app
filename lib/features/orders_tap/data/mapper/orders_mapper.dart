import 'package:elevate_tracking_app/features/orders_tap/data/models/my_orders_response.dart';
import 'package:elevate_tracking_app/features/orders_tap/domain/entities/orders_page_entity.dart';

extension OrdersMapper on OrdersResponse {
  OrdersPageEntity toEntity() {
    return OrdersPageEntity(
      totalPages: metadata?.totalPages,
      orders: orders?.map((order) => order?.toEntity()).toList(),
    );
  }
}

extension OrderMapper on Orders {
  OrderEntity toEntity() {
    return OrderEntity(
      driver: driver,
      orderDetails: order?.toEntity(),
      store: store?.toEntity(),
    );
  }
}

extension OrderDetailsMapper on Order {
  OrderDetailsEntity toEntity() {
    return OrderDetailsEntity(
      orderNumber: orderNumber,
      totalPrice: totalPrice,
      paymentType: paymentType,
      isPaid: isPaid,
      isDelivered: isDelivered,
      state: state,
    );
  }
}

extension StoreMapper on Store {
  StoreEntity toEntity() {
    return StoreEntity(
      name: name,
      image: image,
      address: address,
    );
  }
}

extension UserMapper on User {
  UserEntity toEntity() {
    return UserEntity(
      firstName: firstName,
      lastName: lastName,
      email: email,
      gender: gender,
      phone: phone,
      photo: photo,
    );
  }
}
