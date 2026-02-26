import 'package:elevate_tracking_app/core/config/di/injectable_config.dart';
import 'package:elevate_tracking_app/features/order_details/presentation/view/widgets/order_details_body.dart';
import 'package:elevate_tracking_app/features/order_details/presentation/view_model/cubit/order_details_cubit.dart';
import 'package:elevate_tracking_app/features/order_details/presentation/view_model/cubit/order_details_events.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String driverOrderId;

  const OrderDetailsScreen({super.key, required this.driverOrderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrderDetailsCubit>()
        ..doInit(GetOrderDetailsEvent(driverOrderId: driverOrderId)),
      child: const OrderDetailsView(),
    );
  }
}