import 'package:elevate_tracking_app/features/orders_tap/data/models/my_orders_response.dart';
import 'package:elevate_tracking_app/features/orders_tap/domain/entities/orders_page_entity.dart';

extension OrdersMapper on OrdersResponse {
  OrdersPageEntity toEntity() {
    return OrdersPageEntity(
      totalPages: metadata?.totalPages ?? 0,
      orders: (orders ?? [])
          .map(
            (order) =>
                order?.toEntity() ??
                const OrderEntity(
                  driver: "",

                  orderDetails: OrderDetailsEntity(
                    orderId: "",
                    user: OrderUserEntity(
                      firstName: "",
                      lastName: "",
                      email: "",
                      gender: "",
                      phone: "",
                      photo: "",
                    ),
                    orderNumber: "",
                    totalPrice: 0,
                    paymentType: "",
                    isPaid: false,
                    isDelivered: false,
                    state: "",
                  ),
                  store: StoreEntity(name: "", image: "", address: ""),
                ),
          )
          .toList(),
    );
  }
}

extension OrderMapper on Orders {
  OrderEntity toEntity() {
    return OrderEntity(
      driver: driver ?? "",
      orderDetails:
          order?.toEntity() ??
          const OrderDetailsEntity(
            orderId: "",
            user: OrderUserEntity(
              firstName: "",
              lastName: "",
              email: "",
              gender: "",
              phone: "",
              photo: "",
            ),
            orderNumber: "",
            totalPrice: 0,
            paymentType: "",
            isPaid: false,
            isDelivered: false,
            state: "",
          ),
      store:
          store?.toEntity() ??
          const StoreEntity(name: "", image: "", address: ""),
    );
  }
}

extension OrderDetailsMapper on Order {
  OrderDetailsEntity toEntity() {
    return OrderDetailsEntity(
      orderId: id ?? "",
      user:
          user?.toEntity() ??
          const OrderUserEntity(
            firstName: "",
            lastName: "",
            email: "",
            gender: "",
            phone: "",
            photo: "",
          ),
      orderNumber: orderNumber ?? "",
      totalPrice: totalPrice ?? 0,
      paymentType: paymentType ?? "",
      isPaid: isPaid ?? false,
      isDelivered: isDelivered ?? false,
      state: state ?? "",
    );
  }
}

extension StoreMapper on Store {
  StoreEntity toEntity() {
    return StoreEntity(
      name: name ?? "",
      image: image ?? "",
      address: address ?? "",
    );
  }
}

extension UserMapper on User {
  OrderUserEntity toEntity() {
    return OrderUserEntity(
      firstName: firstName ?? "",
      lastName: lastName ?? "",
      email: email ?? "",
      gender: gender ?? "",
      phone: phone ?? "",
      photo: photo ?? "",
    );
  }
}
