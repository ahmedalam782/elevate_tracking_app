import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:flutter/widgets.dart';


class ContactIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ContactIcon({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: const BoxDecoration(
          color: AppColors.primerColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primerColor, size: 18),
      ),
    );
  }
}