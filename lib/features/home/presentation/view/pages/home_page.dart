import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit homeCubit;
  @override
  void initState() {
    super.initState();
    homeCubit = context.read<HomeCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      homeCubit.doIntent(GetPendingOrdersEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        return SafeArea(
          child: RefreshIndicator(
            backgroundColor: Colors.white,
            onRefresh: () async {
              await homeCubit.doIntent(GetPendingOrdersEvent());
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
                            homeCubit.doIntent(AcceptOrderEvent(index: index));
                          },
                          onRejectCallback: () {
                            homeCubit.doIntent(RejectOrderEvent(index: index));
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
    );
  }
}
