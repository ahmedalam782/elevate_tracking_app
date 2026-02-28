// TODO: presentation Order_trackingBody

import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/core/shared/widgets/custom_button.dart';
import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:elevate_tracking_app/features/home/presentation/view/widgets/adress_container.dart';
import 'package:elevate_tracking_app/features/order_tracking/presentation/view/widgets/order_tracking_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderTrackingBody extends StatelessWidget {
  const OrderTrackingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 24.h),
              Row(
                children: [
                  Icon(Icons.chevron_left, size: 36.sp),

                  Text(
                    LocaleKeys.order_track_order_track.tr(),
                    style: 20.medium,
                  ),
                  SizedBox(width: 8.w),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                children: List.generate(5, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 8.w),
                      child: OrderTrackingStep(),
                    ),
                  );
                }),
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: const Color(0xffF9ECF0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "${LocaleKeys.order_track_status.tr()} : ${LocaleKeys.order_track_accepted.tr()}",
                      style: 16.semiBold.copyWith(
                        color: const Color(0xff0CB359),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "${LocaleKeys.order_track_order_id.tr()}: #123456",
                      style: 16.semiBold,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Wed, 03 Sep 2024, 11:00 AM ",
                      style: 16.medium.copyWith(color: Color(0xff535353)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              AddressContainer(
                addressTypText: LocaleKeys.order_track_pickup_address.tr(),
                image: "https://placehold.co/600x400",
                name: "name",
                address: "address",
                textStyle: 18.medium,
              ),
              SizedBox(height: 24.h),

              AddressContainer(
                addressTypText: LocaleKeys.order_track_pickup_address.tr(),
                image: "https://placehold.co/600x400",
                name: "name",
                address: "address",
                textStyle: 18.medium,
              ),
              SizedBox(height: 24.h),
              Text(LocaleKeys.order_track_order_details.tr(), style: 18.medium),
              // SizedBox(height: 16.h),
              // TODO ORDER DETAILS
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      blurRadius: 4,
                      color: Color(0xff53535340).withOpacity(0.25),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(LocaleKeys.order_track_total.tr(), style: 16.medium),
                    Text(
                      LocaleKeys.order_track_total.tr(),
                      style: 14.medium.copyWith(color: Color(0xff535353)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      blurRadius: 4,
                      color: Color(0xff53535340).withOpacity(0.25),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.order_track_payment_method.tr(),
                      style: 16.medium,
                    ),
                    Text(
                      LocaleKeys.order_track_total.tr(),
                      style: 14.medium.copyWith(color: Color(0xff535353)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              CustomButton(
                onPressed: () {},
                title: LocaleKeys.order_track_arrived_at_pcikup_point.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
