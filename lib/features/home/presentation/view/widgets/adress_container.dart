import 'package:elevate_tracking_app/core/helper/extensions/string_extensions.dart';
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
  final String? phone;
  final TextStyle? textStyle;
  const AddressContainer({
    super.key,
    required this.addressTypText,
    required this.image,
    required this.name,
    required this.address,
    this.textStyle,
    this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          addressTypText,
          style: textStyle ?? 12.regular.copyWith(color: AppColors.gray53),
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
                    Text(
                      address,
                      style: 12.regular.copyWith(color: AppColors.gray53),
                    ),
                  ],
                ),
              ),
              if (phone != null)
                InkWell(
                  onTap: () {
                    phone?.callPhone();
                  },
                  child: Icon(
                    Icons.call_rounded,
                    color: AppColors.primerColor,
                    size: 20.sp,
                  ),
                ),
              SizedBox(width: 8.w),
              if (phone != null)
                InkWell(
                  onTap: () {
                    phone?.openWhatsApp();
                  },
                  child: Icon(
                    Icons.whatshot_outlined,
                    color: AppColors.primerColor,
                    size: 20.sp,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
