import 'package:elevate_tracking_app/features/order_details/presentation/view/widgets/address_card.dart';
import 'package:elevate_tracking_app/features/order_details/presentation/view/widgets/order_item_card.dart';
import 'package:elevate_tracking_app/features/order_details/presentation/view/widgets/order_status.dart';
import 'package:elevate_tracking_app/features/orders_tap/domain/entities/orders_page_entity.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderEntity order; // ✅ بتستقبل الـ OrderEntity

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final orderDetails = order.orderDetails;
    final store = order.store;
    final user = orderDetails.user;

    // Map الـ state الجاي من الـ API للـ OrderStatus
    final status = _mapStatus(orderDetails.state);

    return Scaffold(
      backgroundColor:  Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Status + Order Number ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Status with icon
                  Row(
                    children: [
                      Icon(
                        _statusIcon(status),
                        color: status.color,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status.label,
                        style: TextStyle(
                          color: status.color,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  // Order Number
                  Text(
                    orderDetails.orderNumber,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Pickup Address (Store) ──────────────────────────────────────
            AddressCard(
              label: 'Pickup address',
              name: store.name,
              address: store.address,
              phone: '',
              imageUrl: store.image,
              isStore: true,
            ),

            const SizedBox(height: 20),

            // ── User Address ───────────────────────────────────────────────
            AddressCard(
              label: 'User address',
              name: '${user.firstName} ${user.lastName}',
              address: 'User delivery address',
              phone: user.phone,
              imageUrl: user.photo,
              isStore: false,
            ),

            const SizedBox(height: 20),

            // ── Order Info + Total + Payment ───────────────────────────────
            OrderItemsCard(
              orderNumber: orderDetails.orderNumber,
              totalPrice: orderDetails.totalPrice.toDouble(),
              paymentType: orderDetails.paymentType,
              isPaid: orderDetails.isPaid,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Map الـ String state للـ OrderStatus enum
  OrderStatus _mapStatus(String state) {
    switch (state.toLowerCase()) {
      case 'accepted':
        return OrderStatus.accepted;
      case 'picked':
        return OrderStatus.picked;
      case 'out_for_delivery':
      case 'outfordelivery':
        return OrderStatus.outForDelivery;
      case 'arrived':
        return OrderStatus.arrived;
      case 'completed':
      case 'delivered':
        return OrderStatus.delivered;
      default:
        return OrderStatus.accepted;
    }
  }

  IconData _statusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.accepted:
      case OrderStatus.arrivedAtPickup:
        return Icons.access_time;
      case OrderStatus.picked:
        return Icons.inventory_2_outlined;
      case OrderStatus.outForDelivery:
        return Icons.delivery_dining;
      case OrderStatus.arrived:
        return Icons.location_on;
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
      ),
      title: const Text(
        'Order details',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      
    );
  }
}