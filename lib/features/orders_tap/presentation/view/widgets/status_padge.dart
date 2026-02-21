import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_icons.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum StatusPadge { pending, completed, cancelled }

Widget statusPadge(StatusPadge status) {
  switch (status) {
    case StatusPadge.pending:
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primerColor.withAlpha(16),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          LocaleKeys.my_orders_pending.tr(),
          style: 12.medium.copyWith(color: AppColors.primerColor),
        ),
      );
    case StatusPadge.completed:
      return Row(
        spacing: 4,
        children: [
          SvgPicture.asset(AppIcons.completed),
          Text(
            LocaleKeys.my_orders_completed.tr(),
            style: 16.medium.copyWith(color: AppColors.green0C),
          ),
        ],
      );
    case StatusPadge.cancelled:
      return Row(
        spacing: 4,
        children: [
          SvgPicture.asset(AppIcons.cancelled),
          Text(
            LocaleKeys.my_orders_cancelled.tr(),
            style: 16.medium.copyWith(color: AppColors.redCC),
          ),
        ],
      );
  }
}
