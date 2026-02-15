import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/core/shared/widgets/custom_button.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 1.35,
              child: Lottie.asset('assets/animations/motorcycle.json'),
            ),
            SizedBox(height: 24.h),

            Text(
              LocaleKeys.on_boarding_welcome_text.tr(),
              style: 20.medium,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 24.h),
            CustomButton(
              onPressed: () {},
              title: LocaleKeys.on_boarding_login.tr(),
            ),
            SizedBox(height: 16.h),
            CustomButton(
              backGroundColor: Colors.white,
              borderColor: Colors.black,
              titleStyle: 16.medium.copyWith(color: Colors.black),
              onPressed: () {},
              title: LocaleKeys.on_boarding_apply_now.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
