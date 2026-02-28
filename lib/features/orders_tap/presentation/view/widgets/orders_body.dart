import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/config/base_state/base_state.dart';
import 'package:elevate_tracking_app/core/config/di/injectable_config.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/core/routes/routes.dart';
import 'package:elevate_tracking_app/core/shared/widgets/custom_button.dart';
import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:elevate_tracking_app/features/orders_tap/presentation/view/widgets/counters_section.dart';
import 'package:elevate_tracking_app/features/orders_tap/presentation/view/widgets/order_card.dart';
import 'package:elevate_tracking_app/features/orders_tap/presentation/view_model/cubit/orders_cubit.dart';
import 'package:elevate_tracking_app/features/orders_tap/presentation/view_model/cubit/orders_events.dart';
import 'package:elevate_tracking_app/features/orders_tap/presentation/view_model/cubit/orders_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OrdersBody extends StatefulWidget {
  const OrdersBody({super.key});

  @override
  State<OrdersBody> createState() => _OrdersBodyState();
}

class _OrdersBodyState extends State<OrdersBody> {
  late ScrollController _controller;
  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 200) {
        getIt<OrdersCubit>().doInit(
          GetMoreOrders(page: getIt<OrdersCubit>().state.page + 1),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<OrdersCubit>()..doInit(GetOrdersEvent(page: 1)),
      child: SafeArea(
        child: CustomScrollView(
          controller: _controller,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 10,
                  top: 16,
                ),
                child: Text(LocaleKeys.my_orders_title.tr(), style: 20.medium),
              ),
            ),
            SliverAppBar(
              floating: true,
              toolbarHeight: 84,
              titleSpacing: 0,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
              ),
              automaticallyImplyLeading: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              title: BlocSelector<OrdersCubit, OrdersState, (int, int)>(
                selector: (OrdersState state) =>
                    (state.canceledOrdersCount, state.completedOrdersCount),
                builder: (BuildContext context, (int, int) state) => Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: CountersSection(
                    canceledCount: state.$1,
                    completedCount: state.$2,
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 20,
                  bottom: 8,
                ),
                child: Text(
                  LocaleKeys.my_orders_recent_orders.tr(),
                  style: 18.medium,
                ),
              ),
            ),
            BlocBuilder<OrdersCubit, OrdersState>(
              buildWhen: (previous, current) =>
                  current.orders.state != StateType.moreLoading ||
                  current.canceledOrdersCount != previous.canceledOrdersCount ||
                  current.completedOrdersCount != previous.completedOrdersCount,
              builder: (BuildContext context, OrdersState state) {
                if (state.orders.state == StateType.loading) {
                  return const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 500,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                } else if (state.orders.state == StateType.success) {
                  return SliverList.builder(
                    itemCount: state.orders.data!.orders.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          context.push(
                            Routes.orderDetailsScreen,
                            extra: state
                                .orders
                                .data!
                                .orders[index]
                                .orderDetails
                                .orderId,
                          );
                        },
                        child: OrderCard(
                          order: state.orders.data!.orders[index],
                        ),
                      );
                    },
                  );
                } else {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomButton(
                          onPressed: () =>
                              getIt<OrdersCubit>().doInit(GetOrdersEvent()),
                          title: state.message,
                          titleStyle: 16.medium.copyWith(
                            color: AppColors.whiteF9,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            SliverToBoxAdapter(
              child: BlocSelector<OrdersCubit, OrdersState, bool>(
                builder: (context, state) {
                  return state
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Loading....",
                              style: 14.bold.copyWith(
                                color: AppColors.primerColor,
                                letterSpacing: 2,
                              ),
                            ),
                            // SizedBox(
                            //   height: 25,
                            //   width: 25,
                            //   child: CircularProgressIndicator(),
                            // ),
                          ],
                        )
                      : const SizedBox.shrink();
                },
                selector: (OrdersState state) {
                  return state.orders.state == StateType.moreLoading;
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 65)),
          ],
        ),
      ),
    );
  }
}
