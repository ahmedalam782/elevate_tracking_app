import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/features/order_details/presentation/view/widgets/contact_icon.dart';
import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final String label;
  final String name;
  final String address;
  final String phone;
  final String? imageUrl;
  final bool isStore;

  const AddressCard({super.key, 
    required this.label,
    required this.name,
    required this.address,
    required this.phone,
    required this.imageUrl,
    required this.isStore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteFF,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: AppColors.gray53),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            address,
                            style: const TextStyle(
                              color: AppColors.gray53,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  ContactIcon(icon: Icons.phone_outlined, onTap: () {}),
                  const SizedBox(width: 8),
                  ContactIcon(
                      icon: Icons.chat_bubble_outline, onTap: () {}),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (isStore) {
      return Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: AppColors.primerColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.store_outlined,
            color: AppColors.primerColor, size: 22),
      );
    }
    if (imageUrl != null &&
        imageUrl!.isNotEmpty &&
        imageUrl != 'default-profile.png') {
      return CircleAvatar(
        radius: 22,
        backgroundImage: NetworkImage(imageUrl!),
      );
    }
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.primerColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person_outline,
          color: AppColors.primerColor, size: 22),
    );
  }
}