import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomSkeltonizerWidget extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  const CustomSkeltonizerWidget({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      // enableSwitchAnimation: isLoading,
      enabled: isLoading,
      effect: getShimmerEffect(),
      child: child,
    );
  }
}

class CustomSliverSkeltonizer extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const CustomSliverSkeltonizer({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.sliver(
      enabled: isLoading,
      effect: getShimmerEffect(),
      child: child,
    );
  }
}

ShimmerEffect getShimmerEffect() {
  return const ShimmerEffect(
    duration: Duration(milliseconds: 1500),
    // baseColor: const Color(0xFFE0E0E0),
    baseColor: Color(0xffEBEBEB),
    highlightColor: Colors.white,
    // highlightColor: const Color(0xFFF5F5F5),
    // highlightColor: ColorConstants.primaryBlueColor,
  );
}
