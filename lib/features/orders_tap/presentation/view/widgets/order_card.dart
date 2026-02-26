import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:elevate_tracking_app/features/orders_tap/domain/entities/orders_page_entity.dart';
import 'package:elevate_tracking_app/features/orders_tap/presentation/view/widgets/status_padge.dart';
import 'package:elevate_tracking_app/features/orders_tap/presentation/view/widgets/store_card.dart';
import 'package:elevate_tracking_app/features/orders_tap/presentation/view/widgets/user_card.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});
  final OrderEntity order;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 287,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.whiteF9,
        boxShadow: [
          BoxShadow(color: AppColors.gray53.withAlpha(63), blurRadius: 4),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text(LocaleKeys.my_orders_flower_order.tr(), style: 16.medium),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatusPadgeWidget(
                status: StatusPadgeWidget.fromString(order.orderDetails.state),
              ),
              Text(order.orderDetails.orderNumber, style: 16.semiBold),
            ],
          ),

          StoreCard(store: order.store),
          UserCard(user: order.orderDetails.user),
        ],
      ),
    );
  }
}
