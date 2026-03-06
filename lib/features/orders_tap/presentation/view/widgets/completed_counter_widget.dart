import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_icons.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class CompletedCounterWidget extends StatelessWidget {
  const CompletedCounterWidget({super.key, required this.completedCount});
  final int completedCount;
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
          Text(completedCount.toString(), style: 18.medium),

          Row(
            children: [
              SvgPicture.asset(AppIcons.iconsCompleted),
              const SizedBox(width: 4),
              Text('Completed', style: 16.medium),
            ],
          ),
        ],
      ),
    );
  }
}
