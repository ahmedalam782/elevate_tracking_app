import 'package:elevate_tracking_app/core/theme/app_colors.dart';
import 'package:elevate_tracking_app/features/order_details/domain/entities/order_details_entity.dart';
import 'package:elevate_tracking_app/features/order_details/presentation/view/widgets/action_button.dart';
import 'package:elevate_tracking_app/features/order_details/presentation/view/widgets/address_card.dart';
import 'package:elevate_tracking_app/features/order_details/presentation/view/widgets/order_info.dart';
import 'package:elevate_tracking_app/features/order_details/presentation/view/widgets/order_item_card.dart';
import 'package:elevate_tracking_app/features/order_details/presentation/view/widgets/order_status.dart';
import 'package:elevate_tracking_app/features/order_details/presentation/view/widgets/status_header.dart';
import 'package:elevate_tracking_app/features/order_details/presentation/view_model/cubit/order_details_cubit.dart';
import 'package:elevate_tracking_app/features/order_details/presentation/view_model/cubit/order_details_states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailsView extends StatefulWidget {
  const OrderDetailsView({super.key});

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  OrderStatus _currentStatus = OrderStatus.accepted;

  void _onActionPressed() {
    setState(() {
      final nextIndex = _currentStatus.index + 1;
      if (nextIndex < OrderStatus.values.length) {
        _currentStatus = OrderStatus.values[nextIndex];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteFF,
      appBar: _buildAppBar(),
      body: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
        builder: (context, state) {
          if (kDebugMode) {
            print('STATE: ${state.orderDetails.state}');
          }
          if (kDebugMode) {
            print('MESSAGE: ${state.message}');
          }
          return state.orderDetails.when(
            initial: () => const SizedBox(),
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primerColor),
            ),
            success: (data) => _buildContent(data),
            error: (_) => Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            // moreLoading: (_) =>  const SizedBox(height: 725.0,),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.whiteFF,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(
          Icons.arrow_back_ios,
          color: AppColors.black,
          size: 20,
        ),
      ),
      title: const Text(
        'Order details',
        style: TextStyle(
          color: AppColors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildContent(OrderDetailsEntity data) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                StatusHeaderWidget(currentStatus: _currentStatus),
                const SizedBox(height: 8),
                OrderInfoWidget(entity: data),
                const SizedBox(height: 8),
                AddressCard(
                  label: 'Pickup address',
                  name: data.store.name,
                  address: data.store.address,
                  phone: data.store.phoneNumber,
                  imageUrl: null,
                  isStore: true,
                ),
                const SizedBox(height: 8),
                AddressCard(
                  label: 'User address',
                  name: data.user.fullName,
                  address: 'User delivery address',
                  phone: data.user.phone,
                  imageUrl: data.user.photo,
                  isStore: false,
                ),
                const SizedBox(height: 8),
                OrderItemsCard(
                  items: data.orderItems,
                  totalPrice: data.totalPrice,
                  paymentType: data.paymentType,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        ActionButton(
          status: _currentStatus,
          onPressed: _currentStatus.isButtonEnabled ? _onActionPressed : null,
        ),
      ],
    );
  }
}
