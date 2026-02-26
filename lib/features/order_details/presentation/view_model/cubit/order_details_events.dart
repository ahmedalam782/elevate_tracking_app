// TODO: presentation Order_detailsEvents
sealed class OrderDetailsEvents {}

class GetOrderDetailsEvent extends OrderDetailsEvents {
  final String driverOrderId;
  GetOrderDetailsEvent({required this.driverOrderId});
}