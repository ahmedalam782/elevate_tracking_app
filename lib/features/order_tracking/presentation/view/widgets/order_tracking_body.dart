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

class _OrderTrackingBodyState extends State<OrderTrackingBody>
    with WidgetsBindingObserver {
  late OrderTrackingCubit orderTrackingCubit;
  PageController pageController = PageController();

  /// Tracks the current driver ID so we can resume tracking after app resume.
  String? _currentDriverId;

  @override
  void initState() {
    super.initState();
    orderTrackingCubit = getIt<OrderTrackingCubit>();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    orderTrackingCubit.stopListeningToLocation();
    pageController.dispose();
    super.dispose();
  }

  /// Restart location tracking when the app comes back to the foreground,
  /// because the location package's foreground service can die in the background.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _currentDriverId != null) {
      orderTrackingCubit.restartListeningToLocation(
        orderId: widget.id,
        driverId: _currentDriverId!,
      );
    }
  }

  void _onDriverAvailable(String driverId) {
    if (_currentDriverId == driverId) return;
    _currentDriverId = driverId;
    // Use post-frame so we're not calling async logic inside build().
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        orderTrackingCubit.startListeningToLocation(
          orderId: widget.id,
          driverId: driverId,
        );
      }
    });
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
            _onDriverAvailable(driver.id);
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
