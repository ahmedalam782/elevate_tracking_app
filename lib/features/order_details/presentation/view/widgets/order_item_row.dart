import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/features/order_details/domain/entities/order_details_entity.dart';
import 'package:flutter/material.dart';

class OrderItemRow extends StatelessWidget {
  final OrderItemEntity item;

  const OrderItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primerColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.local_florist,
                color: AppColors.primerColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product #${item.productId.substring(item.productId.length - 4)}',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'EGP ${item.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.gray53,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'X${item.quantity}',
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
