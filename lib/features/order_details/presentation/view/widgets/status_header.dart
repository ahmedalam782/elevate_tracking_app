import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/features/order_details/presentation/view/widgets/order_status.dart';
import 'package:flutter/widgets.dart';

class StatusHeaderWidget extends StatelessWidget {
  final OrderStatus currentStatus;

  const StatusHeaderWidget({required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    const totalSteps = 5;
    final filledSteps = currentStatus.stepIndex + 1;

    return Container(
      color: AppColors.whiteFF,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(totalSteps, (index) {
              final isFilled = index < filledSteps;
              return Expanded(
                child: Container(
                  margin:
                      EdgeInsets.only(right: index < totalSteps - 1 ? 4 : 0),
                  height: 4,
                  decoration: BoxDecoration(
                    color: isFilled ? currentStatus.color : AppColors.whiteFF,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            'Status : ${currentStatus.label}',
            style: TextStyle(
              color: currentStatus.color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}