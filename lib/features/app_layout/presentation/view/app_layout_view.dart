import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:elevate_tracking_app/features/app_layout/data/model/app_layout_data.dart';
import 'package:elevate_tracking_app/features/app_layout/presentation/view_model/cubit/app_layout_cubit.dart';
import 'package:elevate_tracking_app/features/app_layout/presentation/view_model/cubit/app_layout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AppLayoutView extends StatelessWidget {
  const AppLayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppLayoutCubit(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<AppLayoutCubit>();
          return BlocBuilder<AppLayoutCubit, AppLayoutState>(
            builder: (context, state) {
              return Scaffold(
                body: Stack(
                  children: [
                    cubit.pages[cubit.index],
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60.h,
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        decoration: const BoxDecoration(
                          color: AppColors.whiteF9,
                          border: Border(
                            top: BorderSide(width: 1, color: AppColors.grayCF),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            AppLayoutData.getAppLayoutData().length,
                            (index) {
                              final item =
                                  AppLayoutData.getAppLayoutData()[index];
                              final bool isSelected = cubit.index == index;
                              return InkWell(
                                onTap: () {
                                  cubit.changeIndex(index);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      item.imagePath,
                                      colorFilter: ColorFilter.mode(
                                        isSelected
                                            ? AppColors.primerColor
                                            : AppColors.gray7D,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      item.title.tr(),
                                      style: 12.medium.copyWith(
                                        color: isSelected
                                            ? AppColors.primerColor
                                            : AppColors.gray7D,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
