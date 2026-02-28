import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderTrackingStep extends StatelessWidget {
  const OrderTrackingStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3.h,

      decoration: BoxDecoration(
        color: Color(0xff0CB359),
        borderRadius: BorderRadius.circular(300.r),
      ),
    );
  }
}
