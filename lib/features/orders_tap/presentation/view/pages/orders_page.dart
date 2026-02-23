import 'package:elevate_tracking_app/features/orders_tap/presentation/view/widgets/orders_body.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: OrdersBody(),
    );
  }
}
