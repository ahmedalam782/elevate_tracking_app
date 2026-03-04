// TODO: presentation Order_trackingBody

import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/config/di/injectable_config.dart';
import 'package:elevate_tracking_app/core/helper/extensions/datetime_extensions.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_details_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_item_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_store_model.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_user_model.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/core/shared/widgets/custom_button.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:elevate_tracking_app/features/home/presentation/view/widgets/adress_container.dart';
import 'package:elevate_tracking_app/features/order_tracking/presentation/view/widgets/order_item_widget.dart';
import 'package:elevate_tracking_app/features/order_tracking/presentation/view/widgets/order_tracking_step.dart';
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

  String? _nextTrackingState(String? currentState) {
    switch (currentState) {
      case 'inProgress':
        return 'arrivedAtPickup';
      case 'arrivedAtPickup':
        return 'delivering';
      case 'delivering':
        return 'deliveredToTheUser';
      default:
        return null;
    }
  }

  @override
  void initState() {
    orderTrackingCubit = getIt<OrderTrackingCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirestoreOrderDetailsModel?>(
      stream: orderTrackingCubit.listenToOrderWithDetails(widget.id),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        int currentStep = 0;
        String statusText = "";
        String buttonText = LocaleKeys.order_track_arrived_at_pcikup_point.tr();
        if (asyncSnapshot.hasData) {
          final details = asyncSnapshot.data;
          final data = details?.order;
          final store = details?.store;
          final user = details?.user;
          final items = details?.items;
          final driver = details?.driver;
          final nextState = _nextTrackingState(data?.state);

          if (data?.state == "inProgress") {
            currentStep = 0;
            statusText = "Accepted";
            buttonText = LocaleKeys.order_track_arrived_at_pcikup_point.tr();
          } else if (data?.state == "arrivedAtPickup") {
            currentStep = 1;
            statusText = "Arrived at pickup";
            buttonText = "Start delivering";
          } else if (data?.state == "delivering") {
            currentStep = 2;
            statusText = "Delivering";
            buttonText = "Delivered to user";
          } else if (data?.state == "deliveredToTheUser") {
            currentStep = 3;
            statusText = "Delivered to user";
            buttonText = "Delivered";
          } else if (data?.state == "completed") {
            currentStep = 4;
            statusText = "Completed";
            buttonText = "Completed";
          }
          print("DRIVER LAT ${driver?.lat}");
          return PageView(children: []);

          return OrderTrackingDetails(
            currentStep: currentStep,
            statusText: statusText,
            data: data,
            store: store,
            user: user,
            items: items,
            nextState: nextState,
            orderTrackingCubit: orderTrackingCubit,
            widget: widget,
            buttonText: buttonText,
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

class OrderTrackingDetails extends StatelessWidget {
  const OrderTrackingDetails({
    super.key,
    required this.currentStep,
    required this.statusText,
    required this.data,
    required this.store,
    required this.user,
    required this.items,
    required this.nextState,
    required this.orderTrackingCubit,
    required this.widget,
    required this.buttonText,
  });

  final int currentStep;
  final String statusText;
  final FirestoreOrderModel? data;
  final FirestoreOrderStoreModel? store;
  final FirestoreOrderUserModel? user;
  final List<FirestoreOrderItemModel>? items;
  final String? nextState;
  final OrderTrackingCubit orderTrackingCubit;
  final OrderTrackingBody widget;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 24.h),
              Row(
                children: [
                  Icon(Icons.chevron_left, size: 36.sp),

                  Text(
                    LocaleKeys.order_track_order_track.tr(),
                    style: 20.medium,
                  ),
                  SizedBox(width: 8.w),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                children: List.generate(5, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: OrderTrackingStep(isActive: currentStep >= index),
                    ),
                  );
                }),
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: const Color(0xffF9ECF0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "${LocaleKeys.order_track_status.tr()} : ${statusText}",
                      style: 16.semiBold.copyWith(
                        color: const Color(0xff0CB359),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "${LocaleKeys.order_track_order_id.tr()}: #${data?.id ?? ""}",
                      style: 16.semiBold,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      data?.acceptedAt?.toDate().format(
                            "E, dd MMM yyyy, hh:mm a",
                          ) ??
                          "",
                      // "Wed, 03 Sep 2024, 11:00 AM ",
                      style: 16.medium.copyWith(color: Color(0xff535353)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              InkWell(
                onTap: () {},
                child: AddressContainer(
                  addressTypText: LocaleKeys.order_track_pickup_address.tr(),
                  image: (store?.image.isNotEmpty ?? false)
                      ? store!.image
                      : "https://placehold.co/600x400",
                  name: store?.name ?? "",
                  address: store?.address ?? "",
                  textStyle: 18.medium,
                  phone: store?.phoneNumber ?? "",
                ),
              ),
              SizedBox(height: 24.h),

              InkWell(
                onTap: () {},
                child: AddressContainer(
                  addressTypText: LocaleKeys.order_track_user_address.tr(),
                  image: (user?.photo.isNotEmpty ?? false)
                      ? user!.photo
                      : "https://placehold.co/600x400",
                  name: "${user?.firstName ?? ""} ${user?.lastName ?? ""}"
                      .trim(),
                  address: user?.address ?? "",
                  textStyle: 18.medium,
                  phone: user?.phone ?? "",
                  // phone: user?.phone ?? "",
                ),
              ),
              SizedBox(height: 24.h),
              Text(LocaleKeys.order_track_order_details.tr(), style: 18.medium),
              Column(
                children: [
                  SizedBox(height: 16.h),
                  if (items != null)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return OrderItemWidget(orderItemModel: items![index]);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 8.h);
                      },
                      itemCount: items?.length ?? 0,
                    ),
                ],
              ),

              // SizedBox(height: 16.h),
              // TODO ORDER DETAILS
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      blurRadius: 4,
                      color: Color(0xff53535340).withOpacity(0.25),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(LocaleKeys.order_track_total.tr(), style: 16.medium),
                    Text(
                      "${data?.totalPrice ?? 0}",
                      style: 14.medium.copyWith(color: Color(0xff535353)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      blurRadius: 4,
                      color: Color(0xff53535340).withOpacity(0.25),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.order_track_payment_method.tr(),
                      style: 16.medium,
                    ),
                    Text(
                      data?.paymentType ?? "",
                      style: 14.medium.copyWith(color: Color(0xff535353)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              CustomButton(
                onPressed: nextState == null
                    ? null
                    : () async {
                        await orderTrackingCubit.updateOrderState(
                          orderId: widget.id,
                          state: nextState ?? "",
                        );
                      },
                title: buttonText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
