import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_item_model.dart';
import 'package:elevate_tracking_app/core/shared/widgets/optimized_cached_image.dart';
import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:injectable/injectable.dart';

class OrderItemWidget extends StatelessWidget {
  final FirestoreOrderItemModel orderItemModel;
  const OrderItemWidget({super.key, required this.orderItemModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            color: Color(0xff53535340).withOpacity(0.25),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          OptimizedCachedImage(
            imageUrl: orderItemModel.image,
            width: 45.w,
            height: 45.w,
            borderRadius: BorderRadius.circular(1000.r),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        orderItemModel.title,
                        style: 13.regular.copyWith(color: Color(0xff535353)),
                      ),
                    ),
                    Text(
                      "${orderItemModel.quantity}x ",
                      style: 13.medium.copyWith(color: AppColors.primerColor),
                    ),
                  ],
                ),
                Text(orderItemModel.price.toStringAsFixed(1), style: 13.medium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
