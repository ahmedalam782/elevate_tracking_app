import 'package:flutter/material.dart';

class OrderItemsCard extends StatelessWidget {
  final String orderNumber;
  final double totalPrice;
  final String paymentType;
  final bool isPaid;

  static const _grey = Color(0xFF9E9E9E);

  const OrderItemsCard({
    super.key,
    required this.orderNumber,
    required this.totalPrice,
    required this.paymentType,
    required this.isPaid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order details',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),

          // Total Card
          _InfoCard(
            left: 'Total',
            right: 'EGP ${totalPrice.toStringAsFixed(0)}',
            rightStyle: const TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          // Payment Method Card
          _InfoCard(
            left: 'Payment method',
            right: paymentType == 'cash' ? 'Cash on delivery' : paymentType,
            rightStyle: const TextStyle(color: _grey, fontSize: 13),
          ),

          const SizedBox(height: 10),

          // // Paid Status Card
          // _InfoCard(
          //   left: 'Payment status',
          //   right: isPaid ? 'Paid' : 'Not paid',
          //   rightStyle: TextStyle(
          //     color: isPaid ? const Color(0xFF4CAF50) : const Color(0xFFE91E8C),
          //     fontSize: 13,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
        ],
      ),
    );
  }
}

// ─── Info Card ────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final String left;
  final String right;
  final TextStyle rightStyle;

  const _InfoCard({
    required this.left,
    required this.right,
    required this.rightStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(right, style: rightStyle),
        ],
      ),
    );
  }
}