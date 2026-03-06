import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_icons.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

extension StatusPadgeExtension on StatusPadge {
  String get title {
    switch (this) {
      case StatusPadge.pending:
        return LocaleKeys.my_orders_pending.tr();
      case StatusPadge.completed:
        return LocaleKeys.my_orders_completed.tr();
      case StatusPadge.cancelled:
        return LocaleKeys.my_orders_cancelled.tr();
    }
  }

  Color get color {
    switch (this) {
      case StatusPadge.pending:
        return AppColors.primerColor;
      case StatusPadge.completed:
        return AppColors.green0C;
      case StatusPadge.cancelled:
        return AppColors.redCC;
    }
  }

  String get icon {
    switch (this) {
      case StatusPadge.pending:
        return '';
      case StatusPadge.completed:
        return AppIcons.iconsCompleted;
      case StatusPadge.cancelled:
        return AppIcons.iconsCancelled;
    }
  }
}

enum StatusPadge { pending, completed, cancelled }

class StatusPadgeWidget extends StatelessWidget {
  const StatusPadgeWidget({super.key, required this.status});
  static StatusPadge fromString(String status) {
    switch (status) {
      case 'pending':
        return StatusPadge.pending;
      case 'completed':
        return StatusPadge.completed;
      case 'canceled':
        return StatusPadge.cancelled;
      default:
        return StatusPadge.pending;
    }
  }

  final StatusPadge status;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        if (status.icon.isNotEmpty) SvgPicture.asset(status.icon),
        Text(status.title, style: 16.medium.copyWith(color: status.color)),
      ],
    );
  }
}
