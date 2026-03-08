import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/config/di/injectable_config.dart';
import 'package:elevate_tracking_app/core/languages/lang.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:elevate_tracking_app/features/profile/domain/entities/profile_data_entity.dart';
import 'package:elevate_tracking_app/features/profile/presentation/view/widgets/language_bottom_sheet.dart';

import 'package:elevate_tracking_app/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:elevate_tracking_app/features/profile/presentation/view_model/cubit/profile_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..getProfileData(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
        title: Text(
          LocaleKeys.profile_profile_title.tr(),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 20.sp,
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE53935),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            return _ProfileContent(driver: state.driver);
          } else if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 12.h),
                  Text(state.message, textAlign: TextAlign.center),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ProfileCubit>().getProfileData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final DriverEntity driver;

  const _ProfileContent({required this.driver});

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
              _Card(
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
              _Card(
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
              _FlatRow(
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
              _FlatRow(
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

// ── Reusable white card ──
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteFF,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ── Flat tappable row ──
class _FlatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback onTap;

  const _FlatRow({
    required this.icon,
    required this.label,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: AppColors.black32),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                label,
                style: 15.medium.copyWith(color: AppColors.black32),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
