import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/languages/lang.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:elevate_tracking_app/features/profile/domain/entities/profile_data_entity.dart';
import 'package:elevate_tracking_app/features/profile/presentation/view/widgets/flat_row.dart';
import 'package:elevate_tracking_app/features/profile/presentation/view/widgets/language_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileContent extends StatelessWidget {
  final DriverEntity driver;

  const ProfileContent({required this.driver});

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteFF,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => LanguageBottomSheet(
        currentLanguage: context.locale.languageCode,
        onLanguageSelected: (locale) {
          context.setLocale(locale);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = context.locale.languageCode == arabic
        ? LocaleKeys.profile_Arabic.tr()
        : LocaleKeys.profile_English.tr();

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            children: [
              // ── User Info Card ──
              Card(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28.r,
                      backgroundImage: NetworkImage(driver.photo),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver.fullName,
                            style: 16.semiBold.copyWith(
                              color: AppColors.black32,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            driver.email,
                            style: 13.regular.copyWith(
                              color: AppColors.black85,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            driver.phone,
                            style: 13.regular.copyWith(
                              color: AppColors.black85,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.black,
                      size: 30.sp,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12.h),

              // ── Vehicle Info Card ──
              Card(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.profile_vehicle_info.tr(),
                            style: 15.semiBold.copyWith(
                              color: AppColors.black32,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Bike',
                            style: 13.regular.copyWith(
                              color: AppColors.black85,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            driver.vehicleNumber,
                            style: 13.regular.copyWith(
                              color: AppColors.black85,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.black,
                      size: 30.sp,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // ── Language Row ──
              FlatRow(
                icon: Icons.translate_rounded,
                label: LocaleKeys.profile_language.tr(),
                trailing: Text(
                  currentLang,
                  style: const TextStyle(color: AppColors.primerColor,fontSize: 12,fontWeight: FontWeight.w700),
                ),
                onTap: () => _showLanguageSheet(context),
              ),

              Divider(height: 1, indent: 40.w),

              // ── Logout Row ──
              FlatRow(
                icon: Icons.logout_rounded,
                label: LocaleKeys.profile_logout.tr(),
                trailing: Icon(
                  Icons.logout_rounded,
                  color: AppColors.black85,
                  size: 20.sp,
                ),
                onTap: () {
                  // TODO: handle logout
                },
              ),
            ],
          ),
        ),

        // ── Version ──
        Padding(
          padding: EdgeInsets.only(bottom: 24.h),
          child: Text(
            'v 6.3.0 · (446)',
            style: 12.regular.copyWith(color: AppColors.blackCE),
          ),
        ),
      ],
    );
  }
}
