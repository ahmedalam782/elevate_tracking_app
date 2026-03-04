import 'package:flutter/material.dart';

class ContactIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ContactIcon({super.key, required this.icon, required this.onTap});

  static const _pink = Color(0xFFE91E8C);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: _pink.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: _pink, size: 18),
      ),
    );
  }
}