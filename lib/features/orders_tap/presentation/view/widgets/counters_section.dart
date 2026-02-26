import 'package:elevate_tracking_app/features/orders_tap/presentation/view/widgets/canceled_counter_widget.dart';
import 'package:elevate_tracking_app/features/orders_tap/presentation/view/widgets/completed_counter_widget.dart';
import 'package:flutter/cupertino.dart';

class CountersSection extends StatelessWidget {
  const CountersSection({super.key, required this.completedCount, required this.canceledCount});
  final int completedCount;
  final int canceledCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CompletedCounterWidget(completedCount: completedCount,),
          CanceledCounterWidget(canceledCount: canceledCount,),
        ],
      ),
    );
  }
}
