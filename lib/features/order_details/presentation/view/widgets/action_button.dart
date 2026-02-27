import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/features/order_details/presentation/view/widgets/order_status.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final OrderStatus status;
  final VoidCallback? onPressed;

  const ActionButton({super.key, required this.status, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isEnabled = status.isButtonEnabled;

    return Container(
      color: AppColors.whiteFF,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isEnabled ? AppColors.primerColor : AppColors.gray53,
            foregroundColor: AppColors.whiteFF,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            status.actionButtonLabel,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}


