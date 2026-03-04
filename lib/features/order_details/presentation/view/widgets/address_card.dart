import 'package:elevate_tracking_app/features/order_details/presentation/view/widgets/contact_icon.dart';
import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final String label;
  final String name;
  final String address;
  final String phone;
  final String? imageUrl;
  final bool isStore;

  static const _pink = Color(0xFFE91E8C);
  static const _grey = Color(0xFF9E9E9E);

  const AddressCard({
    super.key,
    required this.label,
    required this.name,
    required this.address,
    required this.phone,
    required this.imageUrl,
    required this.isStore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.all(16),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),

          // Card with border
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEEEEEE)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
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
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 13, color: _grey),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              address,
                              style: const TextStyle(color: _grey, fontSize: 12),
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
                    ContactIcon(icon: Icons.chat, onTap: () {}),
                  ],
                ),
              ],
            ),
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
        decoration: BoxDecoration(
          color: _pink.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.store_outlined, color: _pink, size: 22),
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
        color: _pink.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child:
          const Icon(Icons.person_outline, color: _pink, size: 22),
    );
  }
}