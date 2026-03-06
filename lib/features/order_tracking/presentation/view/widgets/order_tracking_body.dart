// TODO: presentation Order_trackingBody

import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/config/di/injectable_config.dart';
import 'package:elevate_tracking_app/core/helper/extensions/datetime_extensions.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_details_model.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/core/shared/widgets/custom_button.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:elevate_tracking_app/features/home/presentation/view/widgets/adress_container.dart';
import 'package:elevate_tracking_app/features/order_tracking/presentation/view/widgets/order_item_widget.dart';
import 'package:elevate_tracking_app/features/order_tracking/presentation/view/widgets/order_tracking_details.dart';
import 'package:elevate_tracking_app/features/order_tracking/presentation/view/widgets/order_tracking_step.dart';
import 'package:elevate_tracking_app/features/order_tracking/presentation/view/widgets/tracking_map.dart';
import 'package:elevate_tracking_app/features/order_tracking/presentation/view_model/cubit/order_tracking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderTrackingBody extends StatefulWidget {
  final String id;
  const OrderTrackingBody({super.key, required this.id});

  @override
  State<OrderTrackingBody> createState() => _OrderTrackingBodyState();
}

class _OrderTrackingBodyState extends State<OrderTrackingBody> {
  late OrderTrackingCubit orderTrackingCubit;
  PageController pageController = PageController();

  @override
  void initState() {
    orderTrackingCubit = getIt<OrderTrackingCubit>();
    super.initState();
  }

  @override
  void dispose() {
    orderTrackingCubit.stopListeningToLocation();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirestoreOrderDetailsModel?>(
      stream: orderTrackingCubit.listenToOrderWithDetails(widget.id),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (asyncSnapshot.hasData) {
          final details = asyncSnapshot.data;
          if (details == null) {
            return SizedBox.shrink();
          }
          final driver = details.driver;
          if (driver != null) {
            orderTrackingCubit.startListeningToLocation(
              orderId: widget.id,
              driverId: driver.id,
            );
          }
          print("DRIVER LAT ${driver?.lat}");
          return PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              OrderTrackingDetails(
                onStoreAddressTapped: () {
                  pageController.animateToPage(
                    2,
                    curve: Curves.linear,
                    duration: const Duration(milliseconds: 300),
                  );
                },
                onUserAddressTapped: () {
                  pageController.animateToPage(
                    1,
                    curve: Curves.linear,
                    duration: const Duration(milliseconds: 300),
                  );
                },
                details: details,
                onAdvanceState: (nextState) async {
                  await orderTrackingCubit.updateOrderState(
                    orderId: widget.id,
                    state: nextState,
                  );
                },
              ),
              TrackingMap(
                details: details,
                showPickupAddressFirst: false,
                pageControoler: pageController,
              ),
              TrackingMap(
                details: details,
                showPickupAddressFirst: true,
                pageControoler: pageController,
              ),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
