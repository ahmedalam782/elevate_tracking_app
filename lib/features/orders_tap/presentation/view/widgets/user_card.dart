import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_icons.dart';
import 'package:elevate_tracking_app/core/theme/app_images.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:elevate_tracking_app/features/orders_tap/domain/entities/orders_page_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});
  final OrderUserEntity user;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 3,
      children: [
        Text(
          LocaleKeys.my_orders_pickup_address.tr(),
          style: 12.regular.copyWith(color: AppColors.gray53),
        ),
        Container(
          height: 60,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.whiteF9,
            boxShadow: [
              BoxShadow(color: AppColors.gray53.withAlpha(63), blurRadius: 4),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(44),
                child: CachedNetworkImage(
                  imageUrl: user.photo,
                  fit: BoxFit.cover,
                  width: 44,
                  height: 44,
                  errorWidget: (context, url, error) =>
                      Image.asset(AppImages.imagesSplash),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.firstName} ${user.lastName}",
                    style: 13.regular.copyWith(color: AppColors.gray53),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.location,
                        height: 16,
                        width: 16,
                        colorFilter: const ColorFilter.mode(
                          AppColors.black0C,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(user.phone, style: 13.regular),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
