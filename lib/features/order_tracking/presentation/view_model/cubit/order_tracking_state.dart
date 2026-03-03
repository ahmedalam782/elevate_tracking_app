part of 'order_tracking_cubit.dart';

sealed class OrderTrackingState extends Equatable {
  const OrderTrackingState();

  @override
  List<Object> get props => [];
}

final class OrderTrackingInitial extends OrderTrackingState {}
