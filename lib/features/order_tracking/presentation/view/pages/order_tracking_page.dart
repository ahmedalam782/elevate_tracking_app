import 'package:elevate_tracking_app/features/order_tracking/presentation/view/widgets/order_tracking_body.dart';
import 'package:flutter/material.dart';

class OrderTrackingPage extends StatelessWidget {
  final String id;
  const OrderTrackingPage({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OrderTrackingBody(id: id));
  }
}
