import 'package:elevate_tracking_app/core/shared/widgets/optimized_cached_image.dart';
import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressContainer extends StatelessWidget {
  final String addressTypText;
  final String image;
  final String name;
  final String address;
  const AddressContainer({
    super.key,
    required this.addressTypText,
    required this.image,
    required this.name,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          addressTypText,
          style: 12.regular.copyWith(color: AppColors.gray53),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 0),
                blurRadius: 4.r,
                // ignore: use_full_hex_values_for_flutter_colors
                color: const Color(0xff53535340).withAlpha(63),
              ),
            ],
          ),
          child: Row(
            children: [
              OptimizedCachedImage(
                imageUrl: image,
                width: 45.w,
                height: 45.w,
                borderRadius: BorderRadius.circular(1000.r),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: 12.regular.copyWith(color: AppColors.gray53),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Text(
                          address,
                          style: 12.regular.copyWith(color: AppColors.gray53),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
