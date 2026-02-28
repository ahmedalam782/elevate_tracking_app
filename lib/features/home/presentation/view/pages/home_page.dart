import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/config/di/injectable_config.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/core/routes/routes.dart';
import 'package:elevate_tracking_app/core/shared/widgets/custom_skeltonizer_widget.dart';
import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:elevate_tracking_app/features/home/presentation/view/widgets/home_order_widget.dart';
import 'package:elevate_tracking_app/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:elevate_tracking_app/features/home/presentation/view_model/cubit/home_events.dart';
import 'package:elevate_tracking_app/features/home/presentation/view_model/cubit/home_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  final HomeCubit? cubit;

  const HomePage({super.key, this.cubit});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeCubit homeCubit;
  late final bool _shouldCloseCubit;

  @override
  void initState() {
    super.initState();
    if (widget.cubit != null) {
      homeCubit = widget.cubit!;
      _shouldCloseCubit = false;
    } else {
      final providedCubit = _tryGetProvidedCubit();
      if (providedCubit != null) {
        homeCubit = providedCubit;
        _shouldCloseCubit = false;
      } else {
        homeCubit = getIt<HomeCubit>();
        _shouldCloseCubit = true;
      }
    }
    homeCubit.doIntent(GetPendingOrdersEvent());
  }

  HomeCubit? _tryGetProvidedCubit() {
    try {
      return context.read<HomeCubit>();
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    if (_shouldCloseCubit) {
      homeCubit.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeCubit,
      child: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state) {
          return SafeArea(
            child: RefreshIndicator(
              backgroundColor: Colors.white,
              onRefresh: () async {
                await context.read<HomeCubit>().doIntent(
                  GetPendingOrdersEvent(),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Text(
                      LocaleKeys.home_flowery_rider.tr(),
                      style: 20.regular.copyWith(color: AppColors.primerColor),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: CustomSkeltonizerWidget(
                      isLoading: state.pendingOrders.isInitialLoading,
                      child: ListView.separated(
                        clipBehavior: Clip.hardEdge,
                        itemBuilder: (context, index) {
                          return HomeOrderWidget(
                            onAcceptCallback: () {
                              // context.read<HomeCubit>().doIntent(
                              //   AcceptOrderEvent(index: index),
                              // );
                              context.push(Routes.orderTrackingScreen);
                            },
                            onRejectCallback: () {
                              context.read<HomeCubit>().doIntent(
                                RejectOrderEvent(index: index),
                              );
                            },
                            order: state.pendingOrders.items[index],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 24.h);
                        },
                        itemCount: state.pendingOrders.items.length,
                      ),
                    ),
                  ),
                  SizedBox(height: 64.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
