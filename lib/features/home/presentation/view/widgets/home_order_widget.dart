import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/config/api/end_points.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/core/shared/widgets/custom_button.dart';
import 'package:elevate_tracking_app/core/shared/widgets/optimized_cached_image.dart';
import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:elevate_tracking_app/features/home/domain/entities/pending_orders_entity.dart';
import 'package:elevate_tracking_app/features/home/presentation/view/widgets/adress_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeOrderWidget extends StatelessWidget {
  final OrderEntity order;
  final void Function()? onRejectCallback;
  final void Function()? onAcceptCallback;
  const HomeOrderWidget({
    super.key,
    required this.order,
    this.onRejectCallback,
    this.onAcceptCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 4.r,
            color: Color(0xff53535340).withAlpha(63),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(LocaleKeys.home_flower_order.tr(), style: 14.medium),
          SizedBox(height: 16.h),
          AddressContainer(
            addressTypText: LocaleKeys.home_pickup_address.tr(),
            image: order.storeAvatar,
            name: order.storeName,
            address: order.storeAddress,
          ),
          SizedBox(height: 16.h),
          AddressContainer(
            addressTypText: LocaleKeys.home_user_address.tr(),
            image: order.userAvatar,
            name: order.userName,
            address: order.userAddress,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Text(
                "${LocaleKeys.home_egp.tr()} ${order.totalPrice}",
                style: 12.semiBold.copyWith(color: Color(0xff0C1015)),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Skeleton.shade(
                  child: CustomButton(
                    onPressed: onRejectCallback,
                    backGroundColor: Colors.white,
                    title: LocaleKeys.home_reject.tr(),
                    titleStyle: 14.medium.copyWith(
                      color: AppColors.primerColor,
                    ),
                    height: 45.h,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Skeleton.shade(
                  child: CustomButton(
                    onPressed: onAcceptCallback,
                    backGroundColor: AppColors.primerColor,
                    title: LocaleKeys.home_accept.tr(),
                    titleStyle: 14.medium.copyWith(color: Colors.white),
                    height: 45.h,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
