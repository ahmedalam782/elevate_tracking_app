// order_details_mapper.dart
import 'order_details_response.dart';
import '../../domain/entities/order_details_entity.dart';

extension OrderDetailsMapper on OrderDetailsResponse {
  OrderDetailsEntity toEntity() {
    return OrderDetailsEntity(
      driverOrderId: id,
      orderNumber: order.orderNumber,
      orderState: order.state,
      createdAt: order.createdAt,
      totalPrice: order.totalPrice,
      paymentType: order.paymentType,
      store: StoreEntity(
        name: store.name,
        image: store.image,
        address: store.address,
        phoneNumber: store.phoneNumber,
      ),
      user: UserEntity(
        firstName: order.user.firstName,
        lastName: order.user.lastName,
        phone: order.user.phone,
        photo: order.user.photo,
      ),
      orderItems: order.orderItems
          .map((item) => OrderItemEntity(
                productId: item.product.id,
                price: item.price,
                quantity: item.quantity,
              ))
          .toList(),
    );
  }
}