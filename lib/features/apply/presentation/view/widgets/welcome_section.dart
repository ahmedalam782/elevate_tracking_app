import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: LocaleKeys.apply_welcome.tr(),
            style: 20.medium.copyWith(color: AppColors.black0C),
          ),
          TextSpan(
            text: '\n${LocaleKeys.apply_discription.tr()}',
            style: 16.medium.copyWith(color: AppColors.gray53),
          ),
        ],
      ),
    );
  }
}
