import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/features/order_details/domain/entities/order_details_entity.dart';
import 'package:elevate_tracking_app/features/order_details/presentation/view/widgets/order_item_row.dart';
import 'package:flutter/material.dart';

class OrderItemsCard extends StatelessWidget {
  final List<OrderItemEntity> items;
  final double totalPrice;
  final String paymentType;

  const OrderItemsCard({super.key, 
    required this.items,
    required this.totalPrice,
    required this.paymentType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteFF,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order details',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => OrderItemRow(item: item)),
          const Divider(color: AppColors.whiteFF, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'EGP ${totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.whiteFF, height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment method',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                paymentType == 'cash' ? 'Cash on delivery' : paymentType,
                style: const TextStyle(
                  color: AppColors.gray53,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}