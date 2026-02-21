sealed class OrdersEvents {}

class GetOrdersEvent extends OrdersEvents {
  final int page;
  GetOrdersEvent({required this.page});
}
