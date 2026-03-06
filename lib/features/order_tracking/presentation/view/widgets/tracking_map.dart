import 'package:easy_localization/easy_localization.dart';
import 'package:elevate_tracking_app/core/helper/firebase_store/models/firestore_order_details_model.dart';
import 'package:elevate_tracking_app/core/helper/functions/get_custom_marker.dart';
import 'package:elevate_tracking_app/core/languages/locale_keys.g.dart';
import 'package:elevate_tracking_app/features/home/presentation/view/widgets/adress_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingMap extends StatefulWidget {
  final bool showPickupAddressFirst;
  final FirestoreOrderDetailsModel details;
  final PageController pageControoler;
  final void Function(bool)? onPopInvoked;

  const TrackingMap({
    super.key,
    required this.details,
    required this.showPickupAddressFirst,
    this.onPopInvoked,
    required this.pageControoler,
  });

  @override
  State<TrackingMap> createState() => _TrackingMapState();
}

class _TrackingMapState extends State<TrackingMap> {
  late CameraPosition cameraPosition;
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    cameraPosition = CameraPosition(
      target: LatLng(
        showLocationFirst().$1,
        showLocationFirst().$2,
      ), // Example coordinates (San Francisco)
      zoom: 16,
    );
    changeMarker();

    super.initState();
  }

  Future<void> changeMarker() async {
    final storeIcon = await getCustomMarker(
      assetPath: "assets/images/Flowery location.png",
      width: 170,
    );
    final driverIcon = await getCustomMarker(
      assetPath: "assets/images/Your location.png",
      width: 170,
    );
    final userIcon = await getCustomMarker(
      assetPath: "assets/images/User location.png",
      width: 170,
    );
    // final doctorIcon = await getCustomMarker(
    //   assetPath: "assets/images/Flowery location.png",
    //   width: 170,
    // );
    markers.addAll([
      Marker(
        markerId: MarkerId("Store location"),
        position: LatLng(
          widget.details.store!.lat.toDouble(),
          widget.details.store!.lng.toDouble(),
        ),
        icon: storeIcon,
      ),
      Marker(
        markerId: MarkerId("Driver location"),
        position: LatLng(
          widget.details.driver!.lat.toDouble(),
          widget.details.driver!.lng.toDouble(),
        ),
        icon: driverIcon,
      ),
      Marker(
        markerId: MarkerId("User location"),
        position: LatLng(
          widget.details.user!.lat.toDouble(),
          widget.details.user!.lng.toDouble(),
        ),
        icon: userIcon,
      ),
    ]);
    setState(() {});
  }

  (double, double) showLocationFirst() {
    if (widget.showPickupAddressFirst) {
      return (
        widget.details.store!.lat.toDouble(),
        widget.details.store!.lng.toDouble(),
      );
    } else {
      return (
        widget.details.user!.lat.toDouble(),
        widget.details.user!.lng.toDouble(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (value, v) {
        widget.pageControoler.animateToPage(
          0,
          curve: Curves.linear,
          duration: const Duration(milliseconds: 300),
        );
        print("POPPPPP");
      },
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              markers: markers,
              initialCameraPosition: cameraPosition,
              onMapCreated: (controller) {
                mapController = controller;
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.only(
                  //   topLeft: ,
                  //   topRight:
                  // )
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        mapController.animateCamera(
                          CameraUpdate.newLatLng(
                            LatLng(
                              widget.details.store!.lat.toDouble(),
                              widget.details.store!.lng.toDouble(),
                            ),
                          ),
                        );
                      },
                      child: AddressContainer(
                        addressTypText: LocaleKeys.order_track_pickup_address
                            .tr(),
                        image: (widget.details.store?.image.isNotEmpty ?? false)
                            ? widget.details.store!.image
                            : "https://placehold.co/600x400",
                        name: widget.details.store?.name ?? "",
                        address: widget.details.store?.address ?? "",
                        phone: widget.details.store?.phoneNumber ?? "",
                      ),
                    ),
                    SizedBox(height: 24.h),

                    InkWell(
                      // onTap: onUserAddressTapped,
                      onTap: () {
                        mapController.animateCamera(
                          CameraUpdate.newLatLng(
                            LatLng(
                              widget.details.user!.lat.toDouble(),
                              widget.details.user!.lng.toDouble(),
                            ),
                          ),
                        );
                      },
                      child: AddressContainer(
                        addressTypText: LocaleKeys.order_track_user_address
                            .tr(),
                        image: (widget.details.user?.photo.isNotEmpty ?? false)
                            ? widget.details.user!.photo
                            : "https://placehold.co/600x400",
                        name:
                            "${widget.details.user?.firstName ?? ""} ${widget.details.user?.lastName ?? ""}"
                                .trim(),
                        address: widget.details.user?.address ?? "",
                        phone: widget.details.user?.phone ?? "",
                        // phone: user?.phone ?? "",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
