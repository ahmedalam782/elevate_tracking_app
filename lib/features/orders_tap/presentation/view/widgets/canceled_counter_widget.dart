import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_icons.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class CanceledCounterWidget extends StatelessWidget {
  const CanceledCounterWidget({super.key, required this.canceledCount});
  final int canceledCount;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.pinkF9,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(canceledCount.toString(), style: 18.medium),

          Row(
            children: [
              SvgPicture.asset(AppIcons.canceled),
              const SizedBox(width: 4),
              Text('Canceled', style: 16.medium),
            ],
          ),
        ],
      ),
    );
  }
}
