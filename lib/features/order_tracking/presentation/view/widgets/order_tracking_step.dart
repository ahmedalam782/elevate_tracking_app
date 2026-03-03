import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderTrackingStep extends StatelessWidget {
  final bool isActive;
  const OrderTrackingStep({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3.h,

      decoration: BoxDecoration(
        color: isActive ? Color(0xff0CB359) : Color(0xffA6A6A6),
        borderRadius: BorderRadius.circular(300.r),
      ),
    );
  }
}
