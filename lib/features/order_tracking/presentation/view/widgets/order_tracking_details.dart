import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/helper/extensions/datetime_extensions.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_details_model.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/core/shared/widgets/custom_button.dart';
import 'package:elevate_tracking_app/core/theme/app_typography.dart';
import 'package:elevate_tracking_app/features/home/presentation/view/widgets/adress_container.dart';
import 'package:elevate_tracking_app/features/order_tracking/presentation/view/widgets/order_item_widget.dart';
import 'package:elevate_tracking_app/features/order_tracking/presentation/view/widgets/order_tracking_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderTrackingDetails extends StatelessWidget {
  const OrderTrackingDetails({
    super.key,
    required this.details,
    required this.onAdvanceState,
    this.onUserAddressTapped,
    this.onStoreAddressTapped,
  });

  final FirestoreOrderDetailsModel details;
  final Future<void> Function(String nextState) onAdvanceState;
  final void Function()? onUserAddressTapped;
  final void Function()? onStoreAddressTapped;

  _OrderTrackingUiState _resolveUiState(String? orderState) {
    switch (orderState) {
      case "inProgress":
        return _OrderTrackingUiState(
          currentStep: 0,
          statusText: "Accepted",
          buttonText: LocaleKeys.order_track_arrived_at_pcikup_point.tr(),
          nextState: "arrivedAtPickup",
        );
      case "arrivedAtPickup":
        return _OrderTrackingUiState(
          currentStep: 1,
          statusText: "Arrived at pickup",
          buttonText: "Start delivering",
          nextState: "delivering",
        );
      case "delivering":
        return _OrderTrackingUiState(
          currentStep: 2,
          statusText: "Delivering",
          buttonText: "Delivered to user",
          nextState: "deliveredToTheUser",
        );
      case "deliveredToTheUser":
        return _OrderTrackingUiState(
          currentStep: 3,
          statusText: "Delivered to user",
          buttonText: "Delivered",
          nextState: null,
        );
      case "completed":
        return _OrderTrackingUiState(
          currentStep: 4,
          statusText: "Completed",
          buttonText: "Completed",
          nextState: null,
        );
      default:
        return _OrderTrackingUiState(
          currentStep: 0,
          statusText: "",
          buttonText: LocaleKeys.order_track_arrived_at_pcikup_point.tr(),
          nextState: null,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = details.order;
    final store = details.store;
    final user = details.user;
    final items = details.items;
    final uiState = _resolveUiState(data.state);

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
                      child: OrderTrackingStep(
                        isActive: uiState.currentStep >= index,
                      ),
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
                      "${LocaleKeys.order_track_status.tr()} : ${uiState.statusText}",
                      style: 16.semiBold.copyWith(
                        color: const Color(0xff0CB359),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "${LocaleKeys.order_track_order_id.tr()}: #${data.id}",
                      style: 16.semiBold,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      data.acceptedAt?.toDate().format(
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
                onTap: onStoreAddressTapped,
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
                onTap: onUserAddressTapped,
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
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return OrderItemWidget(orderItemModel: items[index]);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 8.h);
                    },
                    itemCount: items.length,
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
                      "${data.totalPrice}",
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
                      data.paymentType,
                      style: 14.medium.copyWith(color: Color(0xff535353)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              CustomButton(
                onPressed: uiState.nextState == null
                    ? null
                    : () async {
                        await onAdvanceState(uiState.nextState!);
                      },
                title: uiState.buttonText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderTrackingUiState {
  final int currentStep;
  final String statusText;
  final String buttonText;
  final String? nextState;

  _OrderTrackingUiState({
    required this.currentStep,
    required this.statusText,
    required this.buttonText,
    required this.nextState,
  });
}
